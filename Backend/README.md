# Water Station

Water Station is an IoT-based water quality monitoring system built for community volunteers. Sensor stations sit beside a body of water, and volunteers walk up to them to take measurements. Those readings help track the health of local waterways over time.

## What it measures

- **Water clarity (opacity/turbidity)**
- **Dissolved oxygen**
- **pH**
- **Elements and compounds in the water**, along with their concentration levels

## How it works

1. **Measure:** A volunteer visits a station and takes readings with its IoT sensors.
2. **Connect:** The Water Station app pairs with the station over Bluetooth and pulls the readings automatically, with no manual data entry.
3. **Sync:** The app uploads the data to our database.
4. **Route:** The data is forwarded to the appropriate channels for tracking, analysis, and reporting.

## Why it matters

Consistent, volunteer-collected data makes it easier to spot changes in water quality early, track trends over time, and share reliable data with the people who need it.

## Tech Stack (Backend)

**Core**

- [FastAPI](https://fastapi.tiangolo.com/) (Python) with [uvicorn](https://www.uvicorn.org/)
- [MongoDB](https://www.mongodb.com/) via [Motor](https://motor.readthedocs.io/) + [Beanie](https://beanie-odm.dev/) (async ODM) + [Pydantic](https://docs.pydantic.dev/) for validation
- [PyJWT](https://pyjwt.readthedocs.io/) for auth tokens, [bcrypt](https://pypi.org/project/bcrypt/) for password hashing
- [pydantic-settings](https://docs.pydantic.dev/latest/concepts/pydantic_settings/) / python-dotenv for config

**Tooling**

- [uv](https://docs.astral.sh/uv/) for dependency and environment management
- [pytest](https://docs.pytest.org/) + [pytest-asyncio](https://pytest-asyncio.readthedocs.io/) + [httpx](https://www.python-httpx.org/) for testing
- [Ruff](https://docs.astral.sh/ruff/) for linting and formatting
