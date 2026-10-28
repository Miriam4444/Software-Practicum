from fastapi import APIRouter, HTTPException, Response
from pydantic import ValidationError

from model.waterdata import Waterdata, WaterdataCreate
from service.Waterdata import MissingFieldMembers, WaterdataCreationError, create_waterdata

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
