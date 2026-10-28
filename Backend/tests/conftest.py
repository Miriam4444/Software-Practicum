import pytest
from beanie import init_beanie
from httpx import ASGITransport, AsyncClient
from pymongo import AsyncMongoClient

from config import settings
from database import DOCUMENT_MODELS
from main import app

# Separate database so tests never touch real readings. Needs mongod running.
TEST_DB = settings.database_name + "_test"


@pytest.fixture
async def client():
    mongo = AsyncMongoClient(settings.mongo_uri)
    await mongo.drop_database(TEST_DB)
    await init_beanie(database=mongo[TEST_DB], document_models=DOCUMENT_MODELS)
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as c:
        yield c
    await mongo.drop_database(TEST_DB)
    await mongo.close()


@pytest.fixture
def reading():
    return {
        "source": "Deal Lake",
        "station": "Station 1",
        "conductivity": 410.5,
        "waterTemperature": 18.2,
        "dissolvedOxygen": 8.1,
        "saturationDO": 92.0,
        "ph": 7.4,
        "nitrate": 0.3,
        "turbidity": 4.0,
        "pastWeather": "Overcast",
        "currWeather": "CLEAR/SUNNY",
        "fieldMembers": "Marwan, Kevin",
    }
