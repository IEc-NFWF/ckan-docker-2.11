FROM ckan/ckan-base:2.11

# Install any extensions needed by your CKAN instance
# See Dockerfile.dev for more details and examples

USER root
# RUN apt-get update && apt-get upgrade && apt-get install -y openssh-client --fix-missing && rm -rf /var/lib/apt/lists/*

RUN pip3 install -e 'git+https://github.com/IEc-NFWF/ckanext-oauth2.git@2.11#egg=ckanext-oauth2'
# COPY nfwf-ckan-extensions-deploy-key /root/.ssh/nfwf-ckan-extensions-deploy-key
# RUN chmod 600 /root/.ssh/nfwf-ckan-extensions-deploy-key
RUN pip3 install -e 'git+https://github.com/IEc-NFWF/nfwf-ckan-extensions.git@2.11#egg=ckanext-nfwf_fields&subdirectory=ckanext-nfwf_fields'
#    pip3 install -r ${APP_DIR}/src/ckanext-nfwf_fields/requirements.txt
RUN pip3 install -e 'git+https://github.com/IEc-NFWF/nfwf-ckan-extensions.git@2.11#egg=ckanext-nfwf_theme&subdirectory=ckanext-nfwf_theme'
#    pip3 install -r ${APP_DIR}/src/ckanext-nfwf_theme/requirements.txt


# Copy custom initialization scripts
COPY --chown=ckan-sys:ckan-sys docker-entrypoint.d/* /docker-entrypoint.d/

# Apply any patches needed to CKAN core or any of the built extensions (not the
# runtime mounted ones)
COPY --chown=ckan-sys:ckan-sys patches ${APP_DIR}/patches

USER ckan

RUN for d in $APP_DIR/patches/*; do \
        if [ -d $d ]; then \
            for f in `ls $d/*.patch | sort -g`; do \
                cd $SRC_DIR/`basename "$d"` && echo "$0: Applying patch $f to $SRC_DIR/`basename $d`"; patch -p1 < "$f" ; \
            done ; \
        fi ; \
    done