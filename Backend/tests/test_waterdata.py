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


async def test_list_is_newest_first(client, reading):
    old = await client.post("/waterdata", json=reading)
    reading["ph"] = 7.5
    new = await client.post("/waterdata", json=reading)
    r = await client.get("/waterdata")
    assert r.status_code == 200
    assert [x["_id"] for x in r.json()] == [new.json()["_id"], old.json()["_id"]]


async def test_get_one(client, reading):
    created = await client.post("/waterdata", json=reading)
    r = await client.get(f"/waterdata/{created.json()['_id']}")
    assert r.status_code == 200
    assert r.json()["station"] == reading["station"]
    missing = await client.get("/waterdata/000000000000000000000000")
    assert missing.status_code == 404
    assert (await client.get("/waterdata/not-an-id")).status_code == 422
