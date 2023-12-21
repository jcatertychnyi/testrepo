.PHONY: re-init reset-theme

##
# @command re-init 		Force copy (override) important configuration files and environment with defaults
##
re-init:
	${MAYBE_SUDO} cp -f .env.example .env
	${MAYBE_SUDO} cp -f src/.env.example src/.env
	${MAYBE_SUDO} cp -f docker-compose.example.yml docker-compose.yml
	${MAYBE_SUDO} cp -f ./configs/nginx-server.example.conf ./configs/nginx-server.conf
