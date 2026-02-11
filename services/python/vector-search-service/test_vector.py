from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_vector_requires_auth():
    resp = client.post("/api/v1/vector/search", json={"query":"test","top_k":3})
    assert resp.status_code in (401, 403)
