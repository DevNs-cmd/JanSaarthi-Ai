package main

import (
  "crypto/tls"
  "crypto/x509"
  "encoding/json"
  "io"
  "log"
  "net/http"
  "os"
  "strings"
  "time"

  "github.com/MicahParks/keyfunc"
  "github.com/golang-jwt/jwt/v5"
)

type RecordUpdate struct {
  Key       string `json:"key"`
  Value     string `json:"value"`
  UpdatedAt string `json:"updatedAt"`
}

type EdgeSyncRequest struct {
  EdgeId               string         `json:"edgeId"`
  LastSyncAt           string         `json:"lastSyncAt"`
  Events               []string       `json:"events"`
  PolicyBundleVersions []string       `json:"policyBundleVersions"`
  Updates              []RecordUpdate `json:"updates"`
}

type EdgeSyncResponse struct {
  Status           string   `json:"status"`
  NewPolicyBundles []string `json:"newPolicyBundles"`
  Conflicts        []string `json:"conflicts"`
}

var store = map[string]RecordUpdate{}

func requireRole(next http.HandlerFunc, role string, secret string, issuer string, audience string, jwksUrl string) http.HandlerFunc {
  return func(w http.ResponseWriter, r *http.Request) {
    auth := r.Header.Get("Authorization")
    if !strings.HasPrefix(auth, "Bearer ") {
      w.WriteHeader(http.StatusUnauthorized)
      return
    }
    tokenStr := strings.TrimPrefix(auth, "Bearer ")
    var token *jwt.Token
    var err error
    if jwksUrl != "" {
      jwks, jwkErr := keyfunc.Get(jwksUrl, keyfunc.Options{})
      if jwkErr != nil {
        w.WriteHeader(http.StatusUnauthorized)
        return
      }
      token, err = jwt.Parse(tokenStr, jwks.Keyfunc)
    } else {
      token, err = jwt.Parse(tokenStr, func(t *jwt.Token) (interface{}, error) {
        return []byte(secret), nil
      })
    }
    if err != nil || !token.Valid {
      w.WriteHeader(http.StatusUnauthorized)
      return
    }
    claims, ok := token.Claims.(jwt.MapClaims)
    if !ok {
      w.WriteHeader(http.StatusUnauthorized)
      return
    }
    if issuer != "" && claims["iss"] != issuer {
      w.WriteHeader(http.StatusUnauthorized)
      return
    }
    if audience != "" && claims["aud"] != audience {
      w.WriteHeader(http.StatusUnauthorized)
      return
    }
    roles, _ := claims["roles"].([]interface{})
    allowed := false
    for _, r := range roles {
      if r.(string) == role {
        allowed = true
      }
    }
    if !allowed {
      w.WriteHeader(http.StatusForbidden)
      return
    }
    next(w, r)
  }
}

func main() {
  jwtSecret := os.Getenv("JWT_SECRET")
  if jwtSecret == "" {
    jwtSecret = "CHANGE_ME_32_CHAR_MIN_SECRET"
  }
  jwtSecret = loadVaultSecretOrDefault("JWT_SECRET", jwtSecret)
  jwtIssuer := os.Getenv("JWT_ISSUER")
  if jwtIssuer == "" {
    jwtIssuer = "jan-saarthi"
  }
  jwtAudience := os.Getenv("JWT_AUDIENCE")
  if jwtAudience == "" {
    jwtAudience = "jan-saarthi-services"
  }
  jwksUrl := os.Getenv("OIDC_JWKS_URL")
  mtlsEnabled := os.Getenv("MTLS_ENABLED") == "true"
  certFile := os.Getenv("TLS_CERT_FILE")
  keyFile := os.Getenv("TLS_KEY_FILE")
  caFile := os.Getenv("TLS_CA_FILE")

  mux := http.NewServeMux()
  mux.HandleFunc("/api/v1/edge/sync", requireRole(func(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodPost {
      w.WriteHeader(http.StatusMethodNotAllowed)
      return
    }
    var req EdgeSyncRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
      w.WriteHeader(http.StatusBadRequest)
      return
    }

    conflicts := mergeUpdates(req)
    log.Printf("edge sync edge=%s events=%d updates=%d", req.EdgeId, len(req.Events), len(req.Updates))
    resp := EdgeSyncResponse{Status: "ok", NewPolicyBundles: []string{}, Conflicts: conflicts}
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(resp)
  }, "EDGE_SYNC", jwtSecret, jwtIssuer, jwtAudience, jwksUrl))

  addr := ":8092"
  if v := os.Getenv("PORT"); v != "" {
    addr = ":" + v
  }
  log.Printf("edge-sync listening on %s", addr)
  if mtlsEnabled {
    cert, err := tls.LoadX509KeyPair(certFile, keyFile)
    if err != nil {
      log.Fatalf("tls cert error: %v", err)
    }
    caCert, err := os.ReadFile(caFile)
    if err != nil {
      log.Fatalf("ca cert error: %v", err)
    }
    caPool := x509.NewCertPool()
    caPool.AppendCertsFromPEM(caCert)
    srv := &http.Server{
      Addr:    addr,
      Handler: mux,
      TLSConfig: &tls.Config{
        Certificates: []tls.Certificate{cert},
        ClientAuth:   tls.RequireAndVerifyClientCert,
        ClientCAs:    caPool,
        MinVersion:   tls.VersionTLS13,
      },
    }
    log.Fatal(srv.ListenAndServeTLS("", ""))
  } else {
    http.ListenAndServe(addr, mux)
  }
}

func loadVaultSecretOrDefault(key string, def string) string {
  addr := os.Getenv("VAULT_ADDR")
  token := os.Getenv("VAULT_TOKEN")
  path := os.Getenv("VAULT_SECRET_PATH")
  if addr == "" || token == "" || path == "" {
    return def
  }
  url := strings.TrimRight(addr, "/") + "/v1/" + strings.TrimLeft(path, "/")
  req, _ := http.NewRequest("GET", url, nil)
  req.Header.Set("X-Vault-Token", token)
  resp, err := http.DefaultClient.Do(req)
  if err != nil || resp.StatusCode != 200 {
    return def
  }
  defer resp.Body.Close()
  body, _ := io.ReadAll(resp.Body)
  var doc map[string]any
  if err := json.Unmarshal(body, &doc); err != nil {
    return def
  }
  data, _ := doc["data"].(map[string]any)
  if data == nil {
    return def
  }
  inner, _ := data["data"].(map[string]any)
  if inner == nil {
    inner = data
  }
  if v, ok := inner[strings.ToLower(key)].(string); ok && v != "" {
    return v
  }
  if v, ok := inner[key].(string); ok && v != "" {
    return v
  }
  if v, ok := inner["value"].(string); ok && v != "" {
    return v
  }
  return def
}
