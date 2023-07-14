# syntax=docker/dockerfile:1
ARG UID=2002
ARG USER=liquidsoap


# FROM savonet/liquidsoap:v2.1.4 as base
FROM savonet/liquidsoap:f4e378b as base

ENTRYPOINT ["/usr/bin/env"]

USER root

ARG UID

ARG USER

RUN userdel liquidsoap && \
  useradd -d /usr/share/liquidsoap -s /usr/sbin/nologin -u ${UID} \
  -U ${USER} && \
  groupadd -g 1001 tfulp && \
  adduser ${USER} tfulp

RUN chown ${USER}:${USER} /usr/share/liquidsoap

RUN rm -rf /*.deb


FROM base as development

ARG UID

ARG USER

RUN set -eux; \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  bind9-dnsutils \
  iputils-ping \
  lsof \
  nodejs \
  procps \
  yarnpkg && \
  rm -rf /var/lib/apt/lists/*

USER ${USER}

WORKDIR /node

RUN \
  --mount=type=bind,src=package.json,target=package.json \
  --mount=type=bind,src=yarn.lock,target=yarn.lock \
  --mount=type=cache,id=ngradio_yarn_cache_${USER},sharing=locked,target=/home/${USER}/.cache/yarn,uid=${UID} \
  # Defaults to installing all (prod + dev) packages.
  yarnpkg --no-progress

WORKDIR /app

ENV PATH /node/node_modules/.bin:$PATH

ENV NODE_ENV development

CMD ["nodemon", "-e", "liq,cert,key", "--signal", "SIGTERM", "--exec", "/usr/bin/liquidsoap", "--", "radio.liq"]
# CMD ["nodemon", "-e", "liq,cert,key", "--signal", "SIGTERM", "--exec", "/usr/bin/liquidsoap", "--", "/app/test.liq"]
