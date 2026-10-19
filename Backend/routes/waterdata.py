from fastapi import APIRouter, Depends, HTTPException
from pydantic import ValidationError

from model.Users import User
from model.waterdata import Waterdata, WaterdataCreate
from routes.dependencies import protect
from service.Waterdata import WaterdataCreationError, create_waterdata

router = APIRouter(prefix="/waterdata", tags=["waterdata"])


@router.post("", response_model=Waterdata, status_code=201)
async def create(body: WaterdataCreate, user: User = Depends(protect)):
    try:
        return await create_waterdata(body, user)
    except ValidationError as e:
        raise HTTPException(status_code=422, detail=e.errors(include_url=False))
    except WaterdataCreationError:
        raise HTTPException(status_code=500, detail="Error creating waterdata")
