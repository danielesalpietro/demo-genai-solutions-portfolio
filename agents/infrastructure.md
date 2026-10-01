# Infrastructure reference

Questo file elenca i sistemi disponibili per l'esecuzione di handoff remoti.
Non contiene credenziali. I path delle chiavi SSH e le password vengono forniti
dall'operatore in-session al momento dell'attivazione con `/remote-control`.

---

## Sistemi disponibili

| Nome | Tipo | IP / Hostname | Utente | OS | Scopo |
|---|---|---|---|---|---|
| Z8 G4 | Server fisico | 192.168.1.110 | admin | Linux | Deploy, test Docker nativo, validazione stack |

---

## Execution context codes

| Codice | Significato | Come attivare |
|---|---|---|
| `local` | Sessione locale sul PC dell'operatore | Desktop-app tab o terminale locale |
| `remote:z8g4` | Sessione SSH sul server Z8 G4 | `ssh admin@192.168.1.110` → `claude` → `/remote-control <handoff>` |
| `remote:runpod` | Runner GPU RunPod (cloud) | Script `scripts/test-cloud.sh` o console RunPod |
| `remote:vastai` | Runner GPU Vast.ai (cloud) | Script `scripts/test-cloud.sh` o console Vast.ai |

---

## Credenziali e accesso

- **Z8 G4**: chiave SSH locale sul PC dell'operatore. Il path viene fornito in-session; mai committato.
- **RunPod / Vast.ai**: API key in `packages/<demo>/secrets/logical-access.json.template` (campo `cloud_providers`).

---

## Aggiornamento

Aggiornare questo file quando si aggiungono o rimuovono sistemi.
Non includere mai indirizzi di rete privata di produzione, chiavi o password.
