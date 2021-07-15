SHELL = /bin/bash

.DEFAULT_GOAL := help

define printhelp
	@printf '%-30s %s\n' $(1) $(2)
endef

.PHONY: help
help:
	$(call printhelp, Target, Description)
	$(call printhelp, ----------, ---------------)
	$(call printhelp, 'bashrc', 'Setup bashrc')
	@# $(call printhelp, 'fish', 'Install fish shell')
	$(call printhelp, 'docker', 'Install docker and docker-compose')

.PHONY: bashrc
bashrc:
	grep '# Added by host setup makefile' ~/.bashrc || cat ./bashrc >> ~/.bashrc

.PHONY: fish
fish:
	apt-get update
	apt-get install --no-install-recommends --yes software-properties-common
	apt-add-repository ppa:fish-shell/release-3
	apt-get update
	apt-get install --no-install-recommends --yes fish
	chsh -s $(shell which fish)

.PHONY: docker
docker: docker-clean docker-add-repository docker-install-engine docker-compose-install
	usermod -aG docker $(shell whoami)
	cp -r ./docker ~/.docker

.PHONY: docker-clean
docker-clean:
	apt-get remove docker docker-engine docker.io containerd runc

.PHONY: docker-add-repository
docker-add-repository:
	apt-get update
	apt-get install --no-install-recommends --yes apt-transport-https ca-certificates curl gnupg lsb-release
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	@# check CPU architecure and exit if it does not match
	@if [ $(shell uname -m) != 'x86_64' ]; then echo the CPU architecure is not supported; exit 1; fi
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

.PHONY: docker-install-engine
docker-install-engine: # prerequisites commented out for reusability -- docker-clean docker-add-repository
	apt-get update
	apt-get install --no-install-recommends --yes docker-ce docker-ce-cli containerd.io

.PHONY: docker-compose-install
docker-compose-install:
	apt-get update
	apt-get install --no-install-recommends --yes python3-pip
	pip install docker-compose
	mkdir ~/workspace
