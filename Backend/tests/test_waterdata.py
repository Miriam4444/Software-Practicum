async def test_upload(client, reading):
    r = await client.post("/waterdata", json=reading)
    assert r.status_code == 201
    body = r.json()
    assert body["fieldMembers"] == "Marwan, Kevin"
    assert body["ammonium"] == "N/A"


async def test_missing_field_members_is_a_clear_422(client, reading):
    del reading["fieldMembers"]
    r = await client.post("/waterdata", json=reading)
    assert r.status_code == 422
    assert "fieldMembers" in r.json()["detail"]


async def test_retry_does_not_duplicate(client, reading):
    first = await client.post("/waterdata", json=reading)
    second = await client.post("/waterdata", json=reading)
    assert first.status_code == 201
    assert second.status_code == 200
    assert first.json()["_id"] == second.json()["_id"]
