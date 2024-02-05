USE_SUDO := $(shell which docker >/dev/null && docker ps 2>&1 | grep -q "permission denied" && echo sudo)
DOCKER := $(if $(USE_SUDO), sudo docker, docker)
DIRNAME := $(notdir $(CURDIR))

.PHONY: build bootstrap clean purge up down

build:
	$(DOCKER) build --target env-build  . --tag $(DIRNAME)-build
	$(DOCKER) build --target env-deploy . --tag $(DIRNAME)

bootstrap:
	$(DOCKER) swarm init || true

clean:
	$(DOCKER) system prune -f

purge: clean
	$(DOCKER) volume prune -f

up:
	$(DOCKER) compose up -d

down:
	$(DOCKER) compose down
