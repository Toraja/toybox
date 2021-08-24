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

.PHONY: validate_arg
validate_arg:
	$(call validate_arg)

.PHONY: config
config: validate_arg
	$(base_cmd) config

.PHONY: build
build: validate_arg
	$(base_cmd) build

.PHONY: up
up: validate_arg
	$(base_cmd) up

.PHONY: start
start: validate_arg
	$(base_cmd) up -d

.PHONY: enter
enter: start
	$(base_cmd) exec ide fish

.PHONY: stop
stop: validate_arg
	$(base_cmd) stop

.PHONY: down
down: validate_arg
	$(base_cmd) down

.PHONY: destroy
destroy: validate_arg
	$(base_cmd) down -v
