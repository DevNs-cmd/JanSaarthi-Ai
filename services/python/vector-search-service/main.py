from fastapi import FastAPI, Header, HTTPException
from pydantic import BaseModel
from typing import List
import jwt
import os
import requests

app = FastAPI(title="JanSaarthi Vector Search Service")

JWT_SECRET = os.getenv("JWT_SECRET", "CHANGE_ME_32_CHAR_MIN_SECRET")
JWT_ISSUER = os.getenv("JWT_ISSUER", "jan-saarthi")
JWT_AUDIENCE = os.getenv("JWT_AUDIENCE", "jan-saarthi-services")
OIDC_JWKS_URL = os.getenv("OIDC_JWKS_URL")
AUTH_MODE = os.getenv("AUTH_MODE", "hs256")
REQUIRED_ROLE = "VECTOR_SEARCH"

def load_vault_secret(default_value: str) -> str:
    addr = os.getenv("VAULT_ADDR")
    token = os.getenv("VAULT_TOKEN")
    path = os.getenv("VAULT_SECRET_PATH")
    if not addr or not token or not path:
        return default_value
    url = addr.rstrip("/") + "/v1/" + path.lstrip("/")
    try:
        resp = requests.get(url, headers={"X-Vault-Token": token}, timeout=2)
        if resp.status_code != 200:
            return default_value
        data = resp.json().get("data", {})
        inner = data.get("data", data)
        return inner.get("jwt_secret", inner.get("JWT_SECRET", inner.get("value", default_value)))
    except Exception:
        return default_value

JWT_SECRET = load_vault_secret(JWT_SECRET)

class VectorQuery(BaseModel):
    query: str
    top_k: int = 5

class VectorResult(BaseModel):
    scheme_id: str
    score: float

def require_role(auth: str | None):
    if not auth or not auth.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="unauthorized")
    token = auth.split(" ", 1)[1]
    if AUTH_MODE == "oidc" and OIDC_JWKS_URL:
        jwk_client = jwt.PyJWKClient(OIDC_JWKS_URL)
        signing_key = jwk_client.get_signing_key_from_jwt(token)
        claims = jwt.decode(token, signing_key.key, algorithms=["RS256"], issuer=JWT_ISSUER, audience=JWT_AUDIENCE)
    else:
        claims = jwt.decode(token, JWT_SECRET, algorithms=["HS256"], issuer=JWT_ISSUER, audience=JWT_AUDIENCE)
    roles = claims.get("roles", [])
    if REQUIRED_ROLE not in roles:
        raise HTTPException(status_code=403, detail="forbidden")

@app.post("/api/v1/vector/search", response_model=List[VectorResult])
async def search(req: VectorQuery, authorization: str | None = Header(default=None)):
    require_role(authorization)
    return [VectorResult(scheme_id="SCHEME-001", score=0.85)]
