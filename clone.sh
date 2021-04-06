#!/bin/sh
die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -gt 2 ] || die "at least 3 argument required, $# provided, expect source_address port branch"
source_address=$1
port=$2
branch=$3
schema_filter=${4:-*}
table_filter=${5:-*}
PORT=${port} docker-compose  up -d mariadb hive

# wait until hive is up and listening
echo "waiting for hive metastore"
PORT=${port} docker-compose  exec hive /usr/local/bin/wait-for localhost:9083 --timeout=90
# copy table and partitions to new metastore
docker-compose run lakectl metastore copy-all --from-address "${source_address}" --to-address hive:9083 --branch "${branch}" --schema-filter "${schema_filter}" --table-filter "${table_filter}"
