from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_analytics_requires_auth():
    resp = client.post("/api/v1/analytics/forecast", json={"window_from":"2026-02-01","window_to":"2026-02-10","district":"X","signals":["s1"]})
    assert resp.status_code in (401, 403)
