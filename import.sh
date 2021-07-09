#!/bin/sh
die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -gt 2 ] || die "at least 3 argument required, $# provided, expect port repo branch"
port=$1
repo=$2
branch=$3
schema_filter=${4:-*}
table_filter=${5:-*}
PORT=${port} docker-compose -p "${branch}" up -d mariadb hive

# wait until hive is up and listening
echo "waiting for hive metastore"
PORT=${port} docker-compose -p "${branch}"  exec hive /usr/local/bin/wait-for localhost:9083 --timeout=90
# copy table and partitions to new metastore
docker-compose -p "${branch}" run lakectl metastore import-all --from-client-type glue --to-client-type hive --to-address hive:9083 --repo "${repo}" --branch "${branch}" --schema-filter "${schema_filter}" --table-filter "${table_filter}"
