#!/usr/bin/env bash
exit
function dotenv_load() {
    if [ -f .env ]; then
      export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
    fi
}

function require_env() {
    if [ -z "$1" ]; then
        echo "Missing environment variables [$1]. Terminating."
        return 1
    fi

    return 0
}
