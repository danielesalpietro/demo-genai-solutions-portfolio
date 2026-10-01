---
applyTo: "**/compose.yaml"
---

# Compose file instructions

## Required

- Pin every image to an explicit, immutable version tag. No `latest`.
- Define a `healthcheck` for every service.
- Use named volumes; avoid host path mounts.
- Set `restart: "no"` (demos are not persistent services).

## Security defaults (apply to every service)

```yaml
read_only: true
security_opt:
  - no-new-privileges:true
cap_drop:
  - ALL
```

Add capabilities back only when necessary and document why.

## Prohibited

```
privileged: true
network_mode: host
/var/run/docker.sock  (without approved exception)
image: name:latest
```

## Validation

```bash
docker compose -f compose.yaml config --quiet
```

Must exit 0 before committing.
