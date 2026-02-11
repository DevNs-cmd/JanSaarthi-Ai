package main

import "time"

func mergeUpdates(req EdgeSyncRequest) []string {
  conflicts := []string{}
  for _, upd := range req.Updates {
    existing, ok := store[upd.Key]
    if !ok {
      store[upd.Key] = upd
      continue
    }
    tNew, _ := time.Parse(time.RFC3339, upd.UpdatedAt)
    tOld, _ := time.Parse(time.RFC3339, existing.UpdatedAt)
    if tNew.After(tOld) {
      store[upd.Key] = upd
    } else if tNew.Equal(tOld) && upd.Value != existing.Value {
      conflicts = append(conflicts, upd.Key)
    }
  }
  return conflicts
}
