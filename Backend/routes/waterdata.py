from beanie import PydanticObjectId
from fastapi import APIRouter, HTTPException, Query, Response
from pydantic import ValidationError

from model.waterdata import Waterdata, WaterdataCreate
from service.Waterdata import MissingFieldMembers, WaterdataCreationError, create_waterdata, list_waterdata

# Needed again for the protected route below.
# from fastapi import Depends
# from model.Users import User
# from routes.dependencies import protect

router = APIRouter(prefix="/waterdata", tags=["waterdata"])


# Unprotected for now: the Swift frontend has no login yet.
# Swap this for the protected version below once login is in the frontend.
# 201 = stored, 200 = this exact reading was already stored (a retry).
@router.post("", response_model=Waterdata, status_code=201)
async def create(body: WaterdataCreate, response: Response):
    try:
        waterdata, created = await create_waterdata(body)
    except MissingFieldMembers as e:
        raise HTTPException(status_code=422, detail=str(e))
    except ValidationError as e:
        raise HTTPException(status_code=422, detail=e.errors(include_url=False))
    except WaterdataCreationError:
        raise HTTPException(status_code=500, detail="Error creating waterdata")
    if not created:
        response.status_code = 200
    return waterdata


# Unprotected for now, same as POST above.
@router.get("", response_model=list[Waterdata])
async def list_all(limit: int = Query(default=50, ge=1, le=200), skip: int = Query(default=0, ge=0)):
    return await list_waterdata(limit, skip)


@router.get("/{id}", response_model=Waterdata)
async def get_one(id: PydanticObjectId):
    waterdata = await Waterdata.get(id)
    if not waterdata:
        raise HTTPException(status_code=404, detail="Waterdata not found")
    return waterdata


# Protected version: requires "Authorization: Bearer <token>" and adds the
# logged-in user to fieldMembers.
# @router.post("", response_model=Waterdata, status_code=201)
# async def create(body: WaterdataCreate, response: Response, user: User = Depends(protect)):
#     try:
#         waterdata, created = await create_waterdata(body, user)
#     except ValidationError as e:
#         raise HTTPException(status_code=422, detail=e.errors(include_url=False))
#     except WaterdataCreationError:
#         raise HTTPException(status_code=500, detail="Error creating waterdata")
#     if not created:
#         response.status_code = 200
#     return waterdata
