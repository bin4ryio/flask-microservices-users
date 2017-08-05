#!/bin/bash

set -e
set -u

function create_user_and_database() {
	local database=$1
	echo "  Creating user and database '$database'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE USER $database;
	    CREATE DATABASE $database;
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
	EOSQL
}

if [ $POSTGRES_MULTIPLE_DATABASES ]; then
	echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
	for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
		create_user_and_database $db
	done
	echo "Multiple databases created"
fi


# psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
#     CREATE DATABASE users_prod;
#     CREATE DATABASE users_staging;
#     CREATE DATABASE users_dev;
#     CREATE DATABASE users_test;
# EOSQL

# GRANT ALL PRIVILEGES ON DATABASE users_prod TO docker;
# GRANT ALL PRIVILEGES ON DATABASE users_staging TO docker;
# GRANT ALL PRIVILEGES ON DATABASE users_dev TO docker;
# GRANT ALL PRIVILEGES ON DATABASE users_test TO docker;
# CREATE USER docker;