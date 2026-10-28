USER = {"name": "Test User", "email": "test@example.com", "password": "password123"}

async def test_register_login_me(client):
    r = await client.post("/auth/register", json=USER)
    assert r.status_code == 201
    r = await client.post("/auth/login", json={"email": USER["email"], "password": USER["password"]})
    assert r.status_code == 200
    token = r.json()["access_token"]
    r = await client.get("/auth/me", headers={"Authorization": f"Bearer {token}"})
    assert r.status_code == 200
    assert r.json()["email"] == USER["email"]

async def test_wrong_password(client):
    await client.post("/auth/register", json=USER)
    r = await client.post("/auth/login", json={"email": USER["email"], "password": "wrongpass1"})
    assert r.status_code == 401
