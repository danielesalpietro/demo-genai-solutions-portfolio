SHELL := /usr/bin/env bash
DEMO     ?= hello-compose
GPU      ?= rtx5060ti
TAG      ?= latest
PLATFORM ?= runpod
ENV      ?= noprod
KEY      ?=
VALUE    ?=

.PHONY: validate validate-demo validate-compose smoke reset index check-links \
        package-validate package-build deploy-runpod deploy-vastai cloud-test \
        creds-init creds-show creds-set creds-rotate access-init access-show

validate:
	./scripts/validate-repository.sh

validate-demo:
	./scripts/validate-demo.sh "$(DEMO)"

validate-compose:
	./scripts/validate-compose.sh

smoke:
	./scripts/smoke-test.sh "$(DEMO)"

reset:
	./demos/$(DEMO)/reset.sh

index:
	./scripts/generate-index.sh

check-links:
	./scripts/check-links.sh

## Package targets
package-validate:
	check-jsonschema --schemafile schemas/package.schema.json packages/$(DEMO)/package.yaml

package-build:
	GHCR_OWNER="$(shell git config --get remote.origin.url | sed 's/.*github.com[:/]\([^/]*\)\/.*/\1/')" \
	  ./scripts/package-demo.sh "$(DEMO)" "$(TAG)"

deploy-runpod:
	./scripts/deploy-runpod.sh "$(DEMO)" "$(GPU)"

deploy-vastai:
	./scripts/deploy-vastai.sh "$(DEMO)" "$(GPU)"

cloud-test:
	./scripts/test-cloud.sh "$(DEMO)" "$(PLATFORM)" "$(GPU)"

## Credential management targets
creds-init:
	./scripts/manage-credentials.sh init "$(DEMO)" "$(ENV)"

creds-show:
	./scripts/manage-credentials.sh show "$(DEMO)" "$(ENV)"

creds-set:
	./scripts/manage-credentials.sh set "$(DEMO)" "$(ENV)" "$(KEY)" "$(VALUE)"

creds-rotate:
	./scripts/manage-credentials.sh rotate "$(DEMO)" "$(ENV)"

access-init:
	./scripts/manage-credentials.sh access init "$(DEMO)"

access-show:
	./scripts/manage-credentials.sh access show "$(DEMO)"
