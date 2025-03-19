# FROM postgres:12-alpine
FROM postgis/postgis:12-3.5

# Include extra setup scripts (eg datastore)
COPY --chown=postgres:postgres docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
