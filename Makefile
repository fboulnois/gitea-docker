DOCKER := $(if $(shell docker ps >/dev/null 2>&1 && echo ok), docker, sudo docker)

EMPTY :=
SPACE := $(EMPTY) $(EMPTY)
DIRNAME := $(lastword $(subst /,$(SPACE),$(subst $(SPACE),_,$(CURDIR))))

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
