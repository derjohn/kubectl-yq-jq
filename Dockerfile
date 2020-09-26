FROM bitnami/kubectl
MAINTAINER himself@derjohn.de
USER root

RUN wget https://github.com/mikefarah/yq/releases/download/3.4.0/yq_linux_amd64 -O /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

RUN apt-get update \
&& apt-get install -y \
  jq \
  dnsutils \
  vim \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

ENTRYPOINT /bin/bash -c ${*:-'bash'}

