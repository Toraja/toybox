SHELL = /bin/bash

# Specify COMPOSE_PROJECT_NAME to avoid the collision of container name and volume name between IDEs
base_cmd = COMPOSE_PROJECT_NAME=$(i) docker-compose --file docker-compose.yml --file ./$(i)/docker-compose.yml

define validate_arg
	@if [[ -z "$(i)" ]]; then echo 'Specify IDE as in `i=<ide>`'; exit 1; fi
endef

.DEFAULT_GOAL := dummy

.PHONY: dummy
dummy:
	@echo Select a target.

.PHONY: config
config:
	$(call validate_arg)
	$(base_cmd) config

.PHONY: build
build:
	$(call validate_arg)
	$(base_cmd) build

.PHONY: up
up:
	$(call validate_arg)
	$(base_cmd) up

.PHONY: start
start:
	$(call validate_arg)
	$(base_cmd) up -d

.PHONY: enter
enter: start
	$(call validate_arg)
	$(base_cmd) exec ide fish

.PHONY: stop
stop:
	$(call validate_arg)
	$(base_cmd) stop

.PHONY: down
down:
	$(call validate_arg)
	$(base_cmd) down

.PHONY: destroy
destroy:
	$(call validate_arg)
	$(base_cmd) down -v
