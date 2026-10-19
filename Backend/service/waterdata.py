from model.waterdata import Waterdata

class WaterdataCreationError(Exception):
    pass

async def create_waterdata(waterdata: Waterdata) -> Waterdata:
    try:
        await waterdata.insert()
    except Exception as e:
        raise WaterdataCreationError("Error Creating Waterdata") from e
    return waterdata