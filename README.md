## Hive metastore clone

### About

This repository provides a way to get a containerized clone of your Glue Metastore, 
pointing to a lakeFS branch.  

This repository contains 
- docker-compose for running Hive Metastore
- the clone script that uses docker compose 
- the import script that uses docker compose

### Prerequisite

export your lakeFS endpoint and lakeFS credentials 

```sh
$ export S3A_ENDPOINT=s3.my.lakefs.com
$ export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
$ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
``` 

Edit the following fields in the `lakectl.yaml` file
</br>`catalog_id` - aws numerical account-id</br>`region`</br>`access_secret_key`</br>`access_key_id`

### Running the clone script

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
$ ./clone.sh 9084 example_branch "s.*" "a.*"
```

The Metastore for the requested branch is available on port `9084` for all interfaces.


### Running the import script

In case our tables in the source Metastore do not exist in lakeFS
we should use the import script `import.sh`.
The import script transforms the table location from an external location to a lakeFS location.
e.g table with location s3://my-bucket/path/to/table will be imported to the destination metastore with location s3://my-repo/my-branch/path/to/table

`import.sh` should receive the following arguments
- port to export for new Hive Metastore
- destination repository name
- destination branch name
- filter for schemas to be copied [OPTIONAL]
- filter for tables to be copied [OPTIONAL]

For example, in order to get a copy of all schemas and tables (directed to example_repo/example_branch) from glue to new hive metastore on port 9084 run:

```sh
$ ./import.sh 9084 example_repo example_branch 
```

For example, filtering schemas starting with "s" and tables starting with "a" run:

```sh
$ ./import.sh 9084 example_repo example_branch "s.*" "a.*"
```

The Metastore for the requested branch is available on port `9084` for all interfaces.


