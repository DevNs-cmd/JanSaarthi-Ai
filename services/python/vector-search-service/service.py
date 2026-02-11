import os
import uvicorn

if __name__ == "__main__":
    mtls = os.getenv("MTLS_ENABLED", "false").lower() == "true"
    cert = os.getenv("TLS_CERT_FILE")
    key = os.getenv("TLS_KEY_FILE")
    ca = os.getenv("TLS_CA_FILE")

    kwargs = {"host": "0.0.0.0", "port": int(os.getenv("PORT", "8002"))}
    if mtls:
        kwargs.update({"ssl_certfile": cert, "ssl_keyfile": key, "ssl_ca_certs": ca, "ssl_cert_reqs": 2})

    uvicorn.run("main:app", **kwargs)
