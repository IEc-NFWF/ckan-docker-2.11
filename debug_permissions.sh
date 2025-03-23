#!/bin/bash

docker exec -u root -it ckan-docker-211-ckan-dev-1 chown -R ckan /srv/app/src_extensions/ckanext-nfwf_theme/
docker exec -u root -it ckan-docker-211-ckan-dev-1 chown -R ckan /srv/app/src_extensions/ckanext-nfwf_fields/
