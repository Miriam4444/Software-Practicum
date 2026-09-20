from beanie import init_beanie
from pymongo import AsyncMongoClient
from model.Users import User
from config import settings

# Add each Beanie Document class here as you create them (e.g. User).
DOCUMENT_MODELS: list = [User]

client: AsyncMongoClient | None = None


async def init_db() -> None:
    global client
    client = AsyncMongoClient(settings.mongo_uri)
    await init_beanie(
        database=client[settings.database_name],
        document_models=DOCUMENT_MODELS,
    )


async def close_db() -> None:
    if client is not None:
        await client.close()
