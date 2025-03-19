#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE ckan_test OWNER "$CKAN_DB_USER" ENCODING 'utf-8';
    CREATE DATABASE datastore_test OWNER "$CKAN_DB_USER" ENCODING 'utf-8';
    CREATE EXTENSION POSTGIS;
    ALTER VIEW geometry_columns OWNER TO "$CKAN_DB_USER";
    GRANT ALL PRIVILEGES ON geometry_columns TO "$POSTGRES_USER";
    ALTER TABLE spatial_ref_sys OWNER TO "$CKAN_DB_USER";
    GRANT ALL PRIVILEGES ON spatial_ref_sys TO "$POSTGRES_USER";
EOSQL
