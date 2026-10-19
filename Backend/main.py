from contextlib import asynccontextmanager

from fastapi import FastAPI

from database import close_db, init_db
from routes.auth import router as auth_router
from routes.waterdata import router as waterdata_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_db()
    yield
    await close_db()


app = FastAPI(title="Water Station API", lifespan=lifespan)
app.include_router(auth_router)
app.include_router(waterdata_router)

