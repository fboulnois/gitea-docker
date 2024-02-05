DOCKER := $(if $(shell docker ps >/dev/null 2>&1 && echo ok), docker, sudo docker)

DIRNAME := $(notdir $(CURDIR))

.PHONY: build bootstrap clean purge deploy rm

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
