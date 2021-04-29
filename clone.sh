#!/bin/sh
die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -gt 1 ] || die "at least 2 argument required, $# provided, expect port branch"
port=$1
branch=$2
schema_filter=${3:-*}
table_filter=${4:-*}
PORT=${port} docker-compose -p "${branch}" up -d mariadb hive

# wait until hive is up and listening
echo "waiting for hive metastore"
PORT=${port} docker-compose -p "${branch}"  exec hive /usr/local/bin/wait-for localhost:9083 --timeout=90
# copy table and partitions to new metastore
docker-compose -p "${branch}" run lakectl metastore copy-all --from-client-type glue --to-client-type hive --to-address hive:9083 --branch "${branch}" --schema-filter "${schema_filter}" --table-filter "${table_filter}"
