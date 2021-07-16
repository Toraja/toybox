SHELL = /bin/bash

define validate_arg
	@if [[ -z "$(i)" ]]; then echo 'Specify IDE as in `i=<ide>`'; exit 1; fi
endef

.DEFAULT_GOAL := dummy

.PHONY: dummy
dummy:
	@echo Select a target.

.PHONY: build
build:
	$(call validate_arg)
	docker-compose -f ./$(i)/docker-compose.yml build

.PHONY: up
up:
	$(call validate_arg)
	docker-compose -f ./$(i)/docker-compose.yml up

.PHONY: start
start:
	$(call validate_arg)
	docker-compose -f ./$(i)/docker-compose.yml up -d

.PHONY: enter
enter: start
	$(call validate_arg)
	docker-compose -f ./$(i)/docker-compose.yml exec ide fish

.PHONY: down
down:
	$(call validate_arg)
	docker-compose -f ./$(i)/docker-compose.yml down

.PHONY: destroy
destroy:
	$(call validate_arg)
	docker-compose -f ./$(i)/docker-compose.yml down -v
