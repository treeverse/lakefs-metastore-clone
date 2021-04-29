## Hive metastore clone

### About

This repository provides a way to get a containerized clone of your Hive Metastore, 
pointing to a lakeFS branch.  

This repository contains 
- docker-compose for running Hive Metastore
- the clone script that uses docker compose 

### Prerequisite

export your lakeFS endpoint and AWS credentials 

```sh
$ export S3A_ENDPOINT=s3.my.lakefs.com
$ export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
$ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
``` 

Edit the following fields in the `lakectl.yaml` file
</br>`catalog_id` - aws numerical account-id</br>`region`</br>`access_secret_key`</br>`access_key_id`

### Running the script

In order to create a new Hive Metastore with tables from our source Hive Metastore
we should run the script `clone.sh`.

`clone.sh` should receive the following arguments
- port to export for new Hive Metastore
- destination branch name
- filter for schemas to be copied [OPTIONAL]
- filter for tables to be copied [OPTIONAL]

For example, in order to get a copy of all schemas and tables (directed to example_branch) from glue to new hive metastore on port 9084 run:

```sh
$ ./clone.sh  9084 example_branch 
```

For filtering schemas starting with "s" and tables starting with "a" run:

```sh
$ ./clone-to-branch.sh my.metastore.example.com:9083 9084 example_branch "s.*" "a.*"
```

The Metastore for the requested branch is available on port `9084` for all interfaces.