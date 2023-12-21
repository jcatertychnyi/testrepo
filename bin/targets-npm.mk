.PHONY: npm-install npm-build npm-watch nodejs-bash

DC_NODEJS_BASH := ${DC} run --rm wp-nodejs bash

##
# @command npm-install Run npm install/ci based on package-lock.json file existence
##
npm-install:
	#${DC_NODEJS_BASH} -c 'cd /var/www/html/wp-content/themes/lk-marketing/assets && [ -f package-lock.json ] && echo "package-lock.json file found, running quick install" && npm ci || echo "Warning: package-lock.json file missing." && npm install'

##
# @command npm-build 	Build web assets into static resources
##
npm-build:
	#${DC_NODEJS_BASH} -c 'cd /var/www/html/wp-content/themes/lk-marketing/assets && npm run build'

##
# @command npm-watch 	Run npm watch for live assets re-build during development
##
npm-watch:
	#${DC_NODEJS_BASH} -c 'cd /var/www/html/wp-content/themes/lk-marketing/assets/ && npm run dev'

##
# @command nodejs-bash 		Run nodejs container bash (to run js cli if needed)
##
nodejs-bash:
	${DC_NODEJS_BASH}
