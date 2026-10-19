from datetime import datetime, timezone
from typing import Annotated, Literal, Optional, Union
from beanie import Document, Indexed
from pydantic import BaseModel, Field
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

NonNegative = Annotated[float, Field(ge=0)]
OptionalReading = Union[NonNegative, Literal["N/A"]]

# Fields the client sends. Shared by the request schema and the stored document.
class WaterdataBase(BaseModel):
    source: Waterbody
    station: str = Field(min_length=1, max_length=100)
    conductivity: NonNegative
    waterTemperature: float
    dissolvedOxygen: NonNegative
    saturationDO: NonNegative
    ph: float = Field(ge=0, le=14)
    nitrate: OptionalReading = "N/A"
    ammonium: OptionalReading = "N/A"
    phosphate: OptionalReading = "N/A"
    turbidity: NonNegative
    pcFluoroSense: OptionalReading = "N/A"
    pastWeather : WeatherConditions
    currWeather: WeatherConditions
    notes: Optional[str] = Field(default=None, max_length=2000)

class WaterdataCreate(WaterdataBase):
    fieldMembers: str = Field(default="", max_length=200)

class Waterdata(WaterdataBase, Document):
    fieldMembers: str = Field(min_length=1, max_length=300)
    created: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))

    class Settings:
            name = "Waterdata"
