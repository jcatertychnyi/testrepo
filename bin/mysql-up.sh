#!/usr/bin/env bash

# includes
SCRIPT_PATH=${0%/*}
source "$SCRIPT_PATH/helpers.sh"

# constants
dc='docker-compose'
dbService=${DC_DB_SERVICE:-db}
defaultTimeout=120

# check do we have local container and need to proceed.
dckrDbImage=$(docker-compose images | grep -e 'mysql')
echo "Docker mysql db image: $dckrDbImage"
if [ -z "$dckrDbImage" ]; then
    echo 'Terminating.'
    exit 0
fi

dotenv_load
[ -z "$DB_DATABASE" ] && echo 'Missing env [DB_DATABASE]' && exit 1
[ -z "$DB_USERNAME" ] && echo 'Missing env [DB_USERNAME]' && exit 1
[ -z "$DB_PASSWORD" ] && echo 'Missing env [DB_PASSWORD]' && exit 1

echo 'Up DB container'
$dc up -d $dbService
sleep 1

i=0;
[ "${WAITING_TIMEOUT:-null}" = 'null' ] && WAITING_TIMEOUT=$defaultTimeout

until [ $i -ge $WAITING_TIMEOUT ];
do
    (( i++ ))
    if [[ $i -ge $WAITING_TIMEOUT ]]; then
        echo "ERROR: MySQL IS NOT READY. Terminating by timeout."
        exit 1
    fi

    sleep 1;
    echo "Check MySQL..."
    containerDbName=$($dc exec -T $dbService bash -c 'echo $MYSQL_DATABASE')
    dbSearch=$($dc exec -T $dbService bash -c 'mysql -u root -pdeveloper -e "show databases;" 2>/dev/null |awk "{print $1}" | grep -e ^$MYSQL_DATABASE$')

    if [ "$dbSearch" = "$containerDbName" ]; then
        echo "MySQL is ready to handle requests"
        i=${WAITING_TIMEOUT};
    fi
done
