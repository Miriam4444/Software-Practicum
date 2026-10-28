import hashlib
import json
import logging

from pymongo.errors import DuplicateKeyError

from model.Users import User
from model.waterdata import Waterdata, WaterdataCreate

log = logging.getLogger(__name__)

class WaterdataCreationError(Exception):
    pass

class MissingFieldMembers(Exception):
    pass

# creator is optional until the frontend has login. When given, the creator is
# added to the front of fieldMembers.
# Returns (waterdata, created). created is False when the same reading was
# already stored, e.g. the phone retried an upload after losing signal.
async def create_waterdata(data: WaterdataCreate, creator: User | None = None) -> tuple[Waterdata, bool]:
    others = [m.strip() for m in data.fieldMembers.split(",") if m.strip()]
    if creator:
        members = [creator.name] + [m for m in others if m != creator.name]
    else:
        members = others
    if not members:
        raise MissingFieldMembers("fieldMembers is required until login exists")

    fields = data.model_dump(mode="json", exclude={"fieldMembers"})
    fields["fieldMembers"] = members
    fingerprint = hashlib.sha256(json.dumps(fields, sort_keys=True).encode()).hexdigest()

    existing = await Waterdata.find_one(Waterdata.fingerprint == fingerprint)
    if existing:
        log.info(f"duplicate upload {fingerprint[:12]}, returning {existing.id}")
        return existing, False

    waterdata = Waterdata(**data.model_dump(exclude={"fieldMembers"}), fieldMembers=", ".join(members), fingerprint=fingerprint)
    try:
        await waterdata.insert()
    except DuplicateKeyError:
        # two identical uploads raced past the find_one above
        return await Waterdata.find_one(Waterdata.fingerprint == fingerprint), False
    except Exception as e:
        log.exception("waterdata insert failed")
        raise WaterdataCreationError("Error Creating Waterdata") from e
    log.info(f"stored waterdata {waterdata.id} from {data.source.value} / {data.station}")
    return waterdata, True
