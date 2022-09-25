DOCKER_COMPOSE ?= docker-compose
EXECUTE_APP ?= $(DOCKER_COMPOSE) exec app
EXECUTE_DB ?= $(DOCKER_COMPOSE) exec db
PHP ?= $(DOCKER_COMPOSE) run --rm --no-deps app

up:
	$(DOCKER_COMPOSE) up --remove-orphans -d
.PHONY: up

down:
	$(DOCKER_COMPOSE) down --remove-orphans
.PHONY: down

pull:
	$(DOCKER_COMPOSE) pull
.PHONY: pull

clean:
	$(DOCKER_COMPOSE) rm --force --stop
.PHONY: clean

ps:
	$(DOCKER_COMPOSE) ps
.PHONY: ps

up-app:
	$(DOCKER_COMPOSE) up --no-deps --remove-orphans -d app
.PHONY: up-app

build:
	$(DOCKER_COMPOSE) build --pull
.PHONY: build

ssh:
	@$(EXECUTE_APP) bash
.PHONY: ssh

composer-install:
	@$(EXECUTE_APP) composer install
.PHONY: composer-install
