.PHONY: info init init-dev build run test-run install update stop chown chown-dev reset-theme npm-install npm-build npm-watch php-bash php-exec nodejs-bash mysql-grants

SHELL=/bin/bash
include bin/colors-xterm.mk

PROJECT_NAME := WordPress Configuration/Launcher
SQL_DB_MAX_WAIT := 120

default:
	@echo '${PROJECT_NAME}'
	@echo 'Run ${FG_YELLOW}make help${FG_RESET} to find out available commands'

include bin/vars.mk
include bin/utils.mk

include bin/targets-npm.mk
include bin/targets-dev.mk

##
# @command init 	Initialize important configuration files and environment
##
init:
	@if [ ! -f '.env' ]; then \
		echo 'Copying .env file...'; \
		${MAYBE_SUDO} cp .env.example .env; \
	fi
	@if [ ! -f 'src/.env' ]; then \
		echo 'Copying src/.env file...'; \
		${MAYBE_SUDO} cp src/.env.example src/.env; \
	fi
	@if [ ! -f 'docker-compose.yml' ]; then \
		echo 'Copying docker-compose.yml file...'; \
		${MAYBE_SUDO} cp docker-compose.example.yml docker-compose.yml; \
	fi
	@if [ ! -f 'configs/nginx-server.conf' ]; then \
		echo 'Copying nginx config file...'; \
		${MAYBE_SUDO} cp ./configs/nginx-server.example.conf ./configs/nginx-server.conf; \
	fi
	@echo ''
	@echo 'NOTE: Please check your configuration in ".env" before run.'
	@echo 'NOTE: Please check your configuration in "docker-compose.yml" before run.'
	@echo 'NOTE: You can update nginx server configuration in "configs/nginx-server.conf".'
	@echo ''
	@echo 'IMPORTANT: Please set correct theme and URLs in "src/.env" before run.'
	@echo ''


##
# @command init-dev 	Initialize important configuration files and environment for development, based on `init` command
##
init-dev: init
	@if [ ! -f 'docker-compose.override.yml' ]; then \
		echo 'Copying "docker-compose.override.yml" with dev mode envs...'; \
		${MAYBE_SUDO} cp build/docker-compose.dev.yml docker-compose.override.yml; \
	fi

##
# @command init-db 	Start database containers to be initialized before first project installation
##
init-db:
	${DC} up    --force-recreate  wp-db

##
# @command install 	Run project installation (PHP, NPM)
##
install: dotenv-set-uid
	docker-compose stop
	$(MAKE) ensure-mysql-up
	${DC_RUN} wp-app bash -c "make install SKIP_VENDORS=${SKIP_VENDORS}"
	@if [ -z '$(SKIP_VENDORS)' ]; then \
		$(MAKE) npm-install; \
		$(MAKE) npm-build; \
	else \
		echo 'SKIP_VENDORS is active. Skipping npm install and npm build...'; \
	fi
	${MAYBE_SUDO} mkdir runtime || true
	${MAYBE_SUDO} touch runtime/installed
	$(MAKE) run V=${VAGRANT_MODE}

##
# @command update 	Run project update (PHP, NPM)
##
update: dotenv-set-uid
	docker-compose stop
	$(MAKE) ensure-mysql-up
	${DC_RUN} wp-app bash -c "make update SKIP_VENDORS=${SKIP_VENDORS}"
	@if [ -z '$(SKIP_VENDORS)' ]; then \
		$(MAKE) npm-install; \
		$(MAKE) npm-build; \
	else \
		echo 'SKIP_VENDORS is active. Skipping npm install and npm build...'; \
	fi
	$(MAKE) run V=${VAGRANT_MODE}

##
# @command up 		Up/start docker-compose stack "wp-nginx" container with dependencies. Aliases: `run` (back compatibility for CI/CD)
##
run: up
up:
	${DC} up -d --force-recreate  wp-nginx

##
# @command down 	Down docker-compose stack and clean volumes. Aliases: `stop` (back compatibility for CI/CD)
##
stop: down
down:
	${DC} down -v

##
# @command test 	Running unit tests in CI/CD
##
test:
	echo "WordPress doesn't support unit tests"

##
# @command logs 	Show/follow docker compose logs
##
logs:
	docker-compose logs -f

##
# @command php-bash 	Open app container bash (PHP-FPM)
##
php-bash:
	${DC_EXEC} wp-app gosu jc bash

##
# @command chown 	Return files ownership for files created/updated by docker container (ex. migrations, vendor, etc.)
##
chown:
	sudo chown -R $$(whoami) .env .env.* docker-compose.* src/ configs/

##
# @command ensure-mysql-up 	Ensure that MySQL container is initialized and running if present in stack
##
ensure-mysql-up:
	${MAYBE_SUDO} chmod +x bin/helpers.sh bin/mysql-up.sh
	WAITING_TIMEOUT=${SQL_DB_MAX_WAIT} DC_DB_SERVICE=wp-db ./bin/mysql-up.sh
