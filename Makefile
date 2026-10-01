SHELL := /usr/bin/env bash
DEMO ?= hello-compose

.PHONY: validate smoke reset
validate:
	./scripts/validate-repository.sh

smoke:
	./scripts/smoke-test.sh "$(DEMO)"

reset:
	./demos/$(DEMO)/reset.sh
