#!/bin/bash

# Check if an argument was provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <path_to_ckan_dump_file>"
    echo "Example: $0 ./ckan.dump"
    exit 1
fi

# Store the dump file path
DUMP_FILE="$1"

# Check if the file exists
if [ ! -f "$DUMP_FILE" ]; then
    echo "Error: Dump file '$DUMP_FILE' not found."
    exit 1
fi

echo "Step 1: Cleaning the CKAN database..."
docker exec -it ckan-docker-211-ckan-dev-1 ckan -c /srv/app/ckan.ini db clean

if [ $? -ne 0 ]; then
    echo "Error: Failed to clean the CKAN database."
    exit 1
fi

echo "Step 2: Restoring the databases from '$DUMP_FILE'..."
cat "$DUMP_FILE" | docker exec -i ckan-docker-211-db-1 pg_restore --clean --if-exists -U postgres -d ckan_test
cat "$DUMP_FILE" | docker exec -i ckan-docker-211-db-1 pg_restore --clean --if-exists -U postgres -d ckan

if [ $? -ne 0 ]; then
    echo "Warning: pg_restore completed with non-zero status. This might be due to non-fatal errors."
    echo "Please check if the restore was successful by inspecting your CKAN instance."
else
    echo "Database restore completed successfully."
fi

docker exec -it ckan-docker-211-ckan-dev-1 ckan -c /srv/app/ckan.ini search-index rebuild

echo "Database restore process finished."
