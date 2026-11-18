import argparse
import asyncio
import random
from datetime import datetime, timedelta, timezone

from database import close_db, init_db
from model.waterdata import Waterbody, WaterdataCreate, WeatherConditions
from service.Waterdata import create_waterdata

# Fake readings for demos and frontend work, shaped like the client's real
# CLOnet export (2,491 field visits, 2019-2026, see docs/SCHEMA.md): same value
# steps as the paper form, same spread, same rates of skipped tests.
# Fixed random seed, so running it again finds the same readings and stores no
# duplicates (create_waterdata dedupes on the fingerprint).
MEMBERS = ["Alex Rivera", "Jordan Lee", "Sam Patel", "Taylor Brooks", "Casey Nguyen"]
STATIONS = ["East", "West", "North end", "Bridge", "Outfall", "Dock"]
NOTES = ["Algae near shore", "Geese on the water", "Low water level", "Water murky after rain"]
# real share of each "weather now" answer
WEATHER = [WeatherConditions.CLEAR] * 64 + [WeatherConditions.OVERCAST] * 30 + [WeatherConditions.SHOWERS] * 5 + [WeatherConditions.RAIN, WeatherConditions.STORM]


def fake_reading(rng: random.Random) -> WaterdataCreate:
    def test(p_skipped, choices):
        # the form's dropdown steps; most kits skip nitrate and phosphate
        return "N/A" if rng.random() < p_skipped else rng.choice(choices)

    temp = round(rng.uniform(4, 31), 1)
    # cold water holds more oxygen: about 14 mg/L near freezing, 7 at 30 C
    do = round(min(max(14.6 - 0.24 * temp + rng.gauss(0, 2), 1), 16) * 5) / 5
    return WaterdataCreate(
        source=rng.choice(list(Waterbody)),
        station=rng.choice(STATIONS),
        # log-normal: median about 300 uS, a few brackish sites in the thousands
        conductivity=round(min(rng.lognormvariate(5.7, 1.35), 27000)),
        waterTemperature=temp,
        dissolvedOxygen=do,
        saturationDO=round(rng.uniform(40, 140), 1),
        ph=min(max(round(rng.gauss(7, 0.8) * 2) / 2, 5.5), 9.5),
        nitrate=test(0.95, [0, 0.25, 0.5, 1, 2, 4]),
        ammonium=test(0.90, [0, 0.25, 0.5, 1, 2]),
        phosphate=test(0.99, [10, 20]),
        # Secchi depth in feet, not NTU: how deep a disk stays visible
        turbidity=round(rng.uniform(0.25, 3.5) * 20) / 20,
        pcFluoroSense=test(0.66, [round(rng.uniform(1, 199), 1)]),
        pastWeather=rng.choice(WEATHER),
        currWeather=rng.choice(WEATHER),
        notes=rng.choice(NOTES) if rng.random() < 0.58 else None,
        fieldMembers=", ".join(rng.sample(MEMBERS, rng.choice([1] * 6 + [2]))),
    )


# Returns how many readings were new. Spreads `created` over the last `days`
# days so the history screen has something to scroll through.
async def seed(n: int = 60, days: int = 90) -> int:
    rng = random.Random(485)
    now = datetime.now(timezone.utc).replace(hour=12, minute=0, second=0, microsecond=0)
    new = 0
    for i in range(n):
        waterdata, created = await create_waterdata(fake_reading(rng))
        if created:
            waterdata.created = now - timedelta(days=days * (n - i) / n)
            await waterdata.save()
            new += 1
    return new


async def main(n: int) -> None:
    await init_db()
    try:
        print(f"seeded {await seed(n)} new readings ({n} requested)")
    finally:
        await close_db()


if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Fill the database with fake water readings.")
    p.add_argument("-n", type=int, default=60, help="number of readings (default 60)")
    asyncio.run(main(p.parse_args().n))
