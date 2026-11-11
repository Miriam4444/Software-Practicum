from model.waterdata import Waterdata
from seed import seed


async def test_seed_is_repeatable(client):
    assert await seed(10) == 10
    assert await seed(10) == 0
    assert await Waterdata.count() == 10
