FROM debian:11-slim AS env-build

# install build prerequisites
RUN set -x \
  && apt-get update \
  && apt-get install -y curl gnupg

# set work directory
WORKDIR /srv

# gitea build time args
ARG GITEA_VERSION=1.17.0 \
  GITEA_DOWNLOAD=https://github.com/go-gitea/gitea/releases/download \
  GITEA_GPG_RECV=7C9E68152594688862D62AF62D9AE806EC1592E2

# download and verify gitea
RUN curl -LO ${GITEA_DOWNLOAD}/v${GITEA_VERSION}/gitea-${GITEA_VERSION}-linux-amd64 \
  && gpg --keyserver keys.openpgp.org --recv ${GITEA_GPG_RECV} \
  && curl -LO ${GITEA_DOWNLOAD}/v${GITEA_VERSION}/gitea-${GITEA_VERSION}-linux-amd64.asc \
  && gpg --verify gitea-${GITEA_VERSION}-linux-amd64.asc gitea-${GITEA_VERSION}-linux-amd64 \
  && curl -L ${GITEA_DOWNLOAD}/v${GITEA_VERSION}/gitea-${GITEA_VERSION}-linux-amd64.sha256 | sha256sum -c - \
  && chmod +x gitea-${GITEA_VERSION}-linux-amd64 \
  && cp gitea-${GITEA_VERSION}-linux-amd64 gitea

FROM debian:11-slim AS env-deploy

# import gitea from build container
COPY --from=env-build /srv/gitea /usr/local/bin/gitea

# install prerequisites
RUN set -x \
  && apt-get update \
  && apt-get install -y git

# add gitea environment variable
ENV GITEA_WORK_DIR=/home/git

# create and configure gitea user
RUN useradd --system --create-home git

USER git

WORKDIR ${GITEA_WORK_DIR}

COPY --chown=git app.ini ${GITEA_WORK_DIR}/custom/conf/app.ini

EXPOSE 3000

CMD [ "gitea" ]
