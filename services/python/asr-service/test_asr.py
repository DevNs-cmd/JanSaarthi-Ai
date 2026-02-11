from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_asr_requires_auth():
    resp = client.post("/api/v1/asr/transcribe", json={"audioRef":"local://a","language":"hi-IN"})
    assert resp.status_code in (401, 403)
