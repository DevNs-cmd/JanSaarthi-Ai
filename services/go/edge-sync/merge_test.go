package main

import "testing"

func TestMergeUpdatesNoConflict(t *testing.T) {
  store = map[string]RecordUpdate{}
  req := EdgeSyncRequest{
    Updates: []RecordUpdate{{Key: "k1", Value: "v1", UpdatedAt: "2026-02-10T00:00:00Z"}},
  }
  conflicts := mergeUpdates(req)
  if len(conflicts) != 0 {
    t.Fatalf("expected no conflicts")
  }
  if store["k1"].Value != "v1" {
    t.Fatalf("expected v1")
  }
}

func TestMergeUpdatesConflict(t *testing.T) {
  store = map[string]RecordUpdate{"k1": {Key: "k1", Value: "v1", UpdatedAt: "2026-02-10T00:00:00Z"}}
  req := EdgeSyncRequest{
    Updates: []RecordUpdate{{Key: "k1", Value: "v2", UpdatedAt: "2026-02-10T00:00:00Z"}},
  }
  conflicts := mergeUpdates(req)
  if len(conflicts) != 1 {
    t.Fatalf("expected conflict")
  }
}
