# APE Demo Factory

Public, agent-ready repository for self-contained Docker Compose demonstrations.

## Quick start

```bash
cp demos/hello-compose/.env.example demos/hello-compose/.env
make validate
make smoke DEMO=hello-compose
```

## Create a new demo

```bash
./scripts/create-demo.sh my-demo
```

Then complete `demos/my-demo/demo.yaml`, implementation, tests, and documentation.

## Governance

- Work starts from a typed GitHub Issue.
- Changes arrive through Pull Requests.
- CI validates repository contracts, security, and smoke behavior.
- Human review is mandatory.
- `AGENTS.md` is the canonical instruction file for coding agents.
