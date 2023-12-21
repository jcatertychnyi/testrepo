.PHONY: help

UID := $(shell id -u)
GID := $(shell id -g)

##
# @command help 		Print commands list and command details
#
# @usage 	make help
# @usage 	make help T=<target> 	Example: make help T=init
##
help:
	@echo "${PROJECT_NAME}"
	@if [ -z "${T}" ]; then \
		echo ''; \
		echo '${FG_YELLOW}Usage:${FG_RESET}'; \
		echo '    make'; \
		echo '    make <target> [options]'; \
		echo ''; \
		echo '${FG_YELLOW}Commands:${FG_RESET}'; \
		cat Makefile bin/*.mk | grep "#\s@command" | sed 's/^# //g' | sed 's/^@command/   /g'; \
		echo ''; \
		echo '${FG_PURPLE} * to learn more about command run: make help T=target${FG_RESET}'; \
	else \
		echo ''; \
		echo '${FG_YELLOW}Command help:  ${FG_GREEN}${T}${FG_RESET}'; \
		cat Makefile bin/*.mk | grep -Pzo "(?s)##\n#\s@command\s${T}\s.*?##\n" | sed 's/^#*/ /g'; \
		echo ''; \
	fi;

##
# @command xdebug-init 	Initialize XDEBUG_REMOTE_HOST in .env file for MacOS install inside Vagrant
##
xdebug-init:
	@export XDEBUG_REMOTE_HOST=`/sbin/ip route|awk '/default/ { print $$3 }'` \
		&& echo "Setting XDEBUG_REMOTE_HOST to $${XDEBUG_REMOTE_HOST} in .env..." \
		&& ${MAYBE_SUDO} sed -i "s/XDEBUG_REMOTE_HOST=.*/XDEBUG_REMOTE_HOST=$${XDEBUG_REMOTE_HOST}/g" .env;

##
# @command dotenv-set-uid 	Set current UID and GID to .env to run docker as non-root
##
dotenv-set-uid:
	${MAYBE_SUDO} sed -i "s/USER_UID=9000.*/USER_UID=${UID}/g" .env;
	${MAYBE_SUDO} sed -i "s/USER_GID=9000.*/USER_GID=${GID}/g" .env;
