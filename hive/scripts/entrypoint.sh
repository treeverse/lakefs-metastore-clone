#!/bin/bash

[[ -n "${DB_URI}" ]] && wait-for ${DB_URI}

[[ ! -f initSchema.completed ]] && schematool -dbType mysql -initSchema && touch initSchema.completed
HIVE_OPTS=""
if [[ -n "${S3A_ENDPOINT}" ]]; then
  HIVE_OPTS="--hiveconf fs.s3a.endpoint=${S3A_ENDPOINT}"
fi
echo "hive options: ${S3A_ENDPOINT}"
hive --service metastore $HIVE_OPTS
