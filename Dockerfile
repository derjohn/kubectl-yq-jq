FROM bitnami/kubectl
MAINTAINER himself@derjohn.de
USER root

RUN wget https://github.com/mikefarah/yq/releases/download/v4.4.1/yq_linux_amd64 -O /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

RUN apt-get update \
&& apt-get install -y \
  jq \
  dnsutils \
  vim \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

ENTRYPOINT /bin/bash -c ${*:-'bash'}

