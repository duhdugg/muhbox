SHELL=/bin/bash
PODMAN_BIN=$(shell which podman 2>/dev/null)
DISTROBOX_BIN=$(shell which distrobox 2>/dev/null)
ifneq ($(strip $(PODMAN_BIN)),)
	DOCKER_COMMAND=podman
else
	DOCKER_COMMAND=docker
endif
ifneq ($(strip $(DISTROBOX_BIN)),)
	DISTROBOX_COMMAND=distrobox
else
	DISTROBOX_COMMAND=toolbox
endif

build: build-image create-box setup

build-image:
	$(DOCKER_COMMAND) build --format docker -t muhbox .

create-box:
	DBX_CONTAINER_ALWAYS_PULL=0 $(DISTROBOX_COMMAND) create \
		--image muhbox \
		--name muhbox

setup:
	$(DISTROBOX_COMMAND) enter muhbox -e muhjust setup

clean:
	$(DISTROBOX_COMMAND) stop muhbox; \
	$(DISTROBOX_COMMAND) rm muhbox; \
	$(DOCKER_COMMAND) rmi muhbox
