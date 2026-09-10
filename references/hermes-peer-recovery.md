---
bike-method-phase: 1
three-ms-attribution: |
  Adapted from The Three Ms of AI™ © 2026 Nate Herk.
---

# Hermes Peer & Tailscale Recovery Runbook

> When peers break or Tailscale gets confused, follow this checklist before asking AI to fix it. Most breaks come from a small set of known causes.

## Current Known-Good State (2026-09-10)

| Machine | Tailnet IP | Role | Status |
|---|---|---|---|
| promax | 100.71.218.5 | Main Hermes (this machine) | Active |
| pcgamer | 100.110.220.50 | Peer Hermes (Windows) | Active, relay "mia" |
| truenas-scale | 100.106.207.71 | TrueNAS (SMB target) | Active, direct |

## Diagnose First (don't skip)

Before touching anything, run these three commands and note the output:

```bash
tailscale status                    # Are all peers showing?
curl http://100.110.220.50:8642/health   # Is pcgamer's API server up?
hermes peer list                    # What does Hermes think the peers are?
```

**Three outcomes:**

1. **All green** → Network is fine; problem is elsewhere.
2. **Tailscale shows peers but health check fails** → Peer API server is down (see Section A).
3. **Tailscale itself is broken** (no peers, no self) → Tailscale daemon issue (see Section B).

---

## A. Peer API Server Down

### Symptom
`curl http://<ip>:8642/health` times out or returns non-200.

### Fix (on the broken peer machine)
```bash
# Check if api_server is running
curl http://127.0.0.1:8642/health

# If not, start it
export API_SERVER_KEY=<peer-key>
export API_SERVER_HOST=0.0.0.0
export API_SERVER_PORT=8642
hermes gateway run --api-server --no-supervise

# Verify
curl http://<tailnet-ip>:8642/health
# Expected: {"status": "ok"}
```

### If health returns 404
The gateway is running but the health endpoint isn't registered. Check port mismatch:

```bash
# On the peer machine, check what port is actually configured
grep API_SERVER_PORT ~/.hermes/.env
```

**Known issue:** A previous config had pcgamer on port 8643. The canonical port is 8642. If you see 8643, that's likely wrong — fix it in `~/.hermes/.env` and restart.

---

## B. Tailscale Broken

### Symptom
`tailscale status` shows no peers, or "BackendState" is not "Running".

### Fix
```bash
# Check daemon state
tailscale status --self --json | jq '.BackendState'

# If not Running:
sudo tailscale down
sudo tailscale up

# After reconnecting:
tailscale status
```

### If settings get wiped (DNS, exit nodes, etc.)
```bash
# Re-apply your usual flags
sudo tailscale up --accept-routes --advertise-exit-node
# OR for normal client:
sudo tailscale up --accept-routes
```

---

## C. Peer Registration Lost

### Symptom
`hermes peer list` shows nothing, or DMs fail with 404.

### Fix (bidirectional — do on BOTH machines)

**On promax (this machine):**
```bash
hermes peer add pcgamer --url http://100.110.220.50:8642 --key <pcgamer-api-key>
```

**On pcgamer:**
```bash
hermes peer add promax --url http://100.71.218.5:8642 --key <promax-api-key>
```

**Test both directions:**
```bash
# From promax:
hermes peer dm pcgamer "test from promax"

# From pcgamer:
hermes peer dm promax "test from pcgamer"
```

**API keys are per-profile.** Key format: 16+ char string. Find them in each machine's `~/.hermes/.env` under `API_SERVER_KEY=`.

---

## Best Practices (User Education)

These are the behaviors that cause breaks. Avoid them unless you understand the consequence.

### 1. Don't change ports without updating both ends
If you change `API_SERVER_PORT` on pcgamer, the promax peer config must also change. They must agree.

### 2. Don't wipe Tailscale config casually
`sudo tailscale down` followed by `tailscale up` with different flags can reset routes, DNS, and exit-node settings. Always re-apply your flags explicitly.

### 3. Profile isolation is real
Each profile (critic, magellan, mechanic) has its own `skills/`, `plugins/`, `cron/`, `memories/`. Peer connections are per-profile. If a peer breaks, check which profile you're in: `hermes --profile <name>`.

### 4. Don't let AI guess credentials
When rebuilding, AI may fabricate keys or use wrong ports. Always verify against the actual `~/.hermes/.env` on the target machine.

### 5. Verify before and after
Before any network change, run the three diagnostic commands. After, run them again. Compare. If they don't match, you have a regression.

### 6. The `/link` and `/audit` skills are read-only on the network
They won't fix peer connections. Use this runbook first, then escalate.

---

## Escalation Path

If this runbook doesn't fix it:

1. Capture output of all three diagnostic commands.
2. Check `~/.hermes/logs/` on both machines for errors.
3. Ask AI to analyze the logs — but don't let it guess credentials or ports.
4. As a last resort, rebuild peer registration from scratch using Section C.

---

**Last verified:** 2026-09-10
**Applies to:** promax ↔ pcgamer peer connection, Tailscale tail80f03a
