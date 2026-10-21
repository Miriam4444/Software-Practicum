from fastapi import APIRouter, HTTPException
from pydantic import ValidationError

from model.waterdata import Waterdata, WaterdataCreate
from service.Waterdata import WaterdataCreationError, create_waterdata

# Needed again for the protected route below.
# from fastapi import Depends
# from model.Users import User
# from routes.dependencies import protect

router = APIRouter(prefix="/waterdata", tags=["waterdata"])


# Unprotected for now: the Swift frontend has no login yet.
# Swap this for the protected version below once login is in the frontend.
@router.post("", response_model=Waterdata, status_code=201)
async def create(body: WaterdataCreate):
    try:
        return await create_waterdata(body)
    except ValidationError as e:
        raise HTTPException(status_code=422, detail=e.errors(include_url=False))
    except WaterdataCreationError:
        raise HTTPException(status_code=500, detail="Error creating waterdata")


# Protected version: requires "Authorization: Bearer <token>" and adds the
# logged-in user to fieldMembers.
# @router.post("", response_model=Waterdata, status_code=201)
# async def create(body: WaterdataCreate, user: User = Depends(protect)):
#     try:
#         return await create_waterdata(body, user)
#     except ValidationError as e:
#         raise HTTPException(status_code=422, detail=e.errors(include_url=False))
#     except WaterdataCreationError:
#         raise HTTPException(status_code=500, detail="Error creating waterdata")
