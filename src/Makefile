.PHONY: info install update composer-install ci composer-update cu composer-autoload ca composer-post-install db-install reset-theme uploads-install
.ONESHELL:
.SILENT:

COMPOSER_MEMORY_LIMIT = -1

info:
	@echo "WP Developer Setting Up"
	@echo " "
	@echo "Usage:"
	@echo "	make command"
	@echo " "
	@echo "Available commands:"
	@echo "	install  Activate plugin and sync with backoffice"
	@echo "	update  Updating project"
	@echo "	composer-install|ci		Run composer install w/ env options"
	@echo "	composer-update|cu		Run composer update w/ env options"
	@echo "	composer-autoload|ca		Run composer dump autoload w/ env options"
	@echo "	composer-post-install		Run composer for creating env options"
	@echo "	db-install		Run composer for importing DB from runtime"

SHELL = /bin/bash

# command options
COMPOSER_OPTS = COMPOSER_MEMORY_LIMIT=$(COMPOSER_MEMORY_LIMIT)
COMPOSER_PATH = composer.json

#install: composer-install db-install uploads-install
install: composer-install 
	#wp  --allow-root search-replace "https://lenderkit.com" "${WP_HOME}" --all-tables

update: composer-install

# Composer helpers
ci: composer-install
composer-install:
	set -e
	@if [ -z '$(SKIP_VENDORS)' ]
	    then
		echo 'Composer install, checking force update...'
		if [ '$(FORCE_VENDOR_UPDATE)' = '1' ]; then
			echo 'Force composer update...'
			echo "$(COMPOSER_OPTS) composer update"
		#	$(COMPOSER_OPTS) composer update
		else
			echo 'Install composer...'
			echo "$(COMPOSER_OPTS) composer install"
		#	$(COMPOSER_OPTS) composer install
		fi
	else
		echo 'SKIP_VENDORS is active. Skipping composer install...'
	fi

cu: composer-update
composer-update:
	@if [ -z '$(SKIP_VENDORS)' ]
	    then
		echo 'Update composer...'
		echo '$(COMPOSER_OPTS) composer update'
	#	$(COMPOSER_OPTS) composer update
	else
		echo 'SKIP_VENDORS is active. Skipping composer update...'
	fi

ca: composer-autoload
composer-autoload:
	#$(COMPOSER_OPTS) composer dump-autoload

composer-post-install:
	#$(COMPOSER_OPTS) composer wp:postInstall

db-install:
	set -e
	@if [[ -z `grep '[^[:space:]]' ./runtime/dump.sql` ]]; then
		rm -rf ./runtime/dump.sql
	fi
	@if [ -f ./runtime/dump.sql ]; then
		wp --allow-root db import ./runtime/dump.sql
	else
		echo 'DB not exists'
		echo 'Please provide login and password below to download DB dump automatically from $(WP_THEME_STORAGE)'
		echo -n 'login: '
		read BB_LOGIN
		echo -n 'password: '
		read -s BB_PASSWORD
		wget --user $$BB_LOGIN --password $$BB_PASSWORD $(WP_THEME_STORAGE)dump.sql -O ./runtime/dump.sql
		wp --allow-root db import ./runtime/dump.sql
	fi

uploads-install:
	set -e
	if [ -f ./runtime/uploads.tar.gz ]
	    then
		gunzip ./runtime/uploads.tar.gz
	fi
	@if [ -f ./runtime/uploads.tar ]
		then
		tar -xf ./runtime/uploads.tar -C ./wp-content/
		else
		echo 'Uploads archive does not exists'
		echo 'Please provide login and password below to download uploads automatically from $(WP_THEME_STORAGE)'
		echo -n 'login: '
		read BB_LOGIN
		echo -n 'password: '
		read -s BB_PASSWORD
		wget --user $$BB_LOGIN --password $$BB_PASSWORD $(WP_THEME_STORAGE)uploads.tar.gz -O ./runtime/uploads.tar.gz
		gunzip ./runtime/uploads.tar.gz
		tar -xf ./runtime/uploads.tar -C ./wp-content/
	fi
