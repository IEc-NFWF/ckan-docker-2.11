FROM ckan/ckan-base:2.11

# Install any extensions needed by your CKAN instance
# See Dockerfile.dev for more details and examples

USER root
# RUN apt-get update && apt-get upgrade && apt-get install -y openssh-client --fix-missing && rm -rf /var/lib/apt/lists/*

# Which branch, tag or commit of each repository to build. The defaults are the
# production branches; a server picks something else in its .env (EXT_REF,
# OAUTH2_REF), so this file stays identical on staging and production.
# A commit ID rebuilds reliably; a branch name is cached until --no-cache.
ARG OAUTH2_REF=2.11
ARG EXT_REF=2.11

RUN pip3 install -e "git+https://github.com/IEc-NFWF/ckanext-oauth2.git@${OAUTH2_REF}#egg=ckanext-oauth2"
# COPY nfwf-ckan-extensions-deploy-key /root/.ssh/nfwf-ckan-extensions-deploy-key
# RUN chmod 600 /root/.ssh/nfwf-ckan-extensions-deploy-key
RUN pip3 install -e "git+https://github.com/IEc-NFWF/nfwf-ckan-extensions.git@${EXT_REF}#egg=ckanext-nfwf_fields&subdirectory=ckanext-nfwf_fields"
RUN pip3 install -r ${APP_DIR}/src/ckanext-nfwf-fields/ckanext-nfwf_fields/requirements.txt
RUN pip3 install -e "git+https://github.com/IEc-NFWF/nfwf-ckan-extensions.git@${EXT_REF}#egg=ckanext-nfwf_theme&subdirectory=ckanext-nfwf_theme"
RUN pip3 install -r ${APP_DIR}/src/ckanext-nfwf-theme/ckanext-nfwf_theme/requirements.txt
# Owns the role and account-status model; ckanext-nfwf_fields imports its
# vocabulary, so it must be installed even though only nfwf_fields draws the UI.
RUN pip3 install -e "git+https://github.com/IEc-NFWF/nfwf-ckan-extensions.git@${EXT_REF}#egg=ckanext-nfwf_permissions&subdirectory=ckanext-nfwf_permissions"
RUN pip3 install -r ${APP_DIR}/src/ckanext-nfwf-permissions/ckanext-nfwf_permissions/requirements.txt

# Copy custom initialization scripts
COPY --chown=ckan-sys:ckan-sys docker-entrypoint.d/* /docker-entrypoint.d/

# Apply any patches needed to CKAN core or any of the built extensions (not the
# runtime mounted ones)
COPY --chown=ckan-sys:ckan-sys patches ${APP_DIR}/patches

USER ckan

RUN for d in $APP_DIR/patches/*; do \
        if [ -d $d ]; then \
            for f in `ls $d/*.patch | sort -g`; do \
                cd $SRC_DIR/`basename "$d"` && echo "$0: Applying patch $f to $SRC_DIR/`basename $d`"; patch --forward --reject-file=/dev/null -p1 < "$f" || true ; \
            done ; \
        fi ; \
    done