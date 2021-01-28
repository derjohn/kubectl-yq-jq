ARG DEBARCH # amd64,arm64v8
ARG ARCH # amd64,arm64
FROM --platform=linux/${ARCH} ${DEBARCH}/debian:buster-slim

ARG ARCH
ARG KUBECTL=v1.20.2
ARG YQ=v4.4.1

MAINTAINER himself@derjohn.de
USER root

RUN apt-get update \
    && apt-get install -y \
    wget \
    curl \
    jq \
    dnsutils \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://storage.googleapis.com/kubernetes-release/release/${KUBECTL}/bin/linux/${ARCH}/kubectl -O /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

RUN wget https://github.com/mikefarah/yq/releases/download/${YQ}/yq_linux_${ARCH} -O /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

ENTRYPOINT /bin/bash -c ${*:-'bash'}

