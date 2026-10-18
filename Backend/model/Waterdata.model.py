from datetime import datetime, timezone
from typing import Literal, Optional, Union
from beanie import Document, Indexed
from pydantic import Field
from enum import Enum

class Waterbody(str, Enum):
    FLETCHER_LAKE = "Fletcher Lake"
    DEAL_LAKE = "Deal Lake"
    JACKSON_WOODS = "Jackson Woods"
    LAKE_COMO = "Lake Como"
    LAKE_TAKANASSEE_WHALE_POND_BROOK = "Lake Takanassee / Whale Pond Brook"
    SHADOW_LAKE = "Shadow Lake"
    SILVER_LAKE = "Silver Lake"
    SPRING_LAKE = "Spring Lake"
    SUNSET_LAKE = "Sunset Lake"
    SYLVAN_LAKE = "Sylvan Lake"
    WESLEY_LAKE = "Wesley Lake"
    WRECK_POND = "Wreck Pond"

class WeatherConditions(str, Enum):
    STORM = "Storm (heavy rain)"
    RAIN = "Rain (steady rain)"
    SHOWERS = "Showers (intermittent rain)"
    OVERCAST = "Overcast"
    CLEAR = "CLEAR/SUNNY"

class Waterdata(Document):
    fieldMembers: str
    source: Waterbody
    station: str
    created: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    conductivity: float
    waterTemperature: float
    dissolvedOxygen: float
    saturationDO: float
    ph: float
    nitrate: Union[float, Literal["N/A"]] = "N/A"
    ammonium: Union[float, Literal["N/A"]] = "N/A"
    phosphate: Union[float, Literal["N/A"]] = "N/A"
    turbidity: float
    pcFluoroSense: Union[float, Literal["N/A"]] = "N/A"
    pastWeather : WeatherConditions
    currWeather: WeatherConditions
    notes: Optional[str] = None

    class Settings:
            name = "Waterdata"