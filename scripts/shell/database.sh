#!/usr/bin/env bash

DATASOURCE_HOST=${DATASOURCE_HOST:-127.0.0.1}
DATASOURCE_PORT=${DATASOURCE_PORT:-3306}
export DATASOURCE_ENDPOINT="$DATASOURCE_USER:$DATASOURCE_PASSWORD@tcp($DATASOURCE_HOST:$DATASOURCE_PORT)/$DATASOURCE_DATABASE"

MIGRATE_DATABASE_CONFIG='config/database/dbconfig.yml'

function database_drop () {
  mysql \
    --user "$DATASOURCE_USER" \
    --host "$DATASOURCE_HOST" \
    --port "$DATASOURCE_PORT" \
    -p"$DATASOURCE_PASSWORD" \
    --database "$DATASOURCE_DATABASE" \
    -e "DROP DATABASE $DATASOURCE_DATABASE; CREATE DATABASE $DATASOURCE_DATABASE;"

  sleep 1
}

function migrate_up () {
  sql-migrate up -config="$MIGRATE_DATABASE_CONFIG" --dryrun
  sql-migrate up -config="$MIGRATE_DATABASE_CONFIG"
}

function database_seed () {
  echo "Do you want to initialize database? (yes/[no])"
  read -r ANSWER

  if [[ "$ANSWER" != 'yes' ]]; then
    return 1
  fi

  if ! database_drop; then
    echo 'Failed to drop table'
    return 1
  fi

  if ! migrate_up; then
    echo 'Failed to migrate database'
    return 1
  fi

  RESULT=$(mysql \
    --user "$DATASOURCE_USER" \
    --host "$DATASOURCE_HOST" \
    --port "$DATASOURCE_PORT" \
    -p"$DATASOURCE_PASSWORD" \
    --database "$DATASOURCE_DATABASE" \
    -e "source ${DATA_SOURCE:-config/database/data/data.sql}")

  if [ "$RESULT" != 0 ]; then
    echo 'Failed to seed database'
    return 1
  fi
}


if [ "$1" == "" ]; then
  echo 'subcommand must be set'
  exit 1
fi

SUB_COMMAND="$1"

case "$SUB_COMMAND" in
  database_seed)
    database_seed
    ;;
  database_drop)
    database_drop
    ;;
  migrate_up)
    migrate_up
    ;;
  *)
    echo "'$SUB_COMMAND' is not defined"
    ;;
esac
