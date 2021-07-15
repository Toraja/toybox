.DEFAULT_GOAL := dummy

define start_ide
	docker-compose -f ./$(1)/docker-compose.yml up -d \
		&& docker-compose -f ./$(1)/docker-compose.yml exec ide fish
endef

define build_image
	docker-compose -f ./$(1)/docker-compose.yml build
endef

dummy:
	@echo Select a target.

base:
	$(call build_image, base)

go:
	$(call start_ide, go)

java:
	$(call start_ide, java)

php:
	$(call start_ide, php)
