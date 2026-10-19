from model.Users import User
from model.waterdata import Waterdata, WaterdataCreate

class WaterdataCreationError(Exception):
    pass

async def create_waterdata(data: WaterdataCreate, creator: User) -> Waterdata:
    others = [m.strip() for m in data.fieldMembers.split(",") if m.strip()]
    members = [creator.name] + [m for m in others if m != creator.name]
    waterdata = Waterdata(**data.model_dump(exclude={"fieldMembers"}), fieldMembers=", ".join(members))
    try:
        await waterdata.insert()
    except Exception as e:
        raise WaterdataCreationError("Error Creating Waterdata") from e
    return waterdata
