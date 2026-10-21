from model.Users import User
from model.waterdata import Waterdata, WaterdataCreate

class WaterdataCreationError(Exception):
    pass

# creator is optional until the frontend has login. When given, the creator is
# added to the front of fieldMembers.
async def create_waterdata(data: WaterdataCreate, creator: User | None = None) -> Waterdata:
    others = [m.strip() for m in data.fieldMembers.split(",") if m.strip()]
    if creator:
        members = [creator.name] + [m for m in others if m != creator.name]
    else:
        members = others
    waterdata = Waterdata(**data.model_dump(exclude={"fieldMembers"}), fieldMembers=", ".join(members))
    try:
        await waterdata.insert()
    except Exception as e:
        raise WaterdataCreationError("Error Creating Waterdata") from e
    return waterdata
