FROM alpine:3.15

RUN echo "@edge-testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk update \
  && apk add --no-cache \
    cfssl@edge-testing \
    mini_httpd \
    openssl \
    shadow \
  && rm -r /var/cache/apk/*

ENV CFSSL_CERT_PATH="/var/lib/cfssl" \
    CFSSL_CONFIG_CA="/etc/cfssl/config.ca.json" \
    CFSSL_CONFIG_REQ="/etc/cfssl/config.req.json" \
    CFSSL_CA_REMOTE="ca" \
    CFSSL_CA_SIGNING_PROFILE="server_cert"

RUN adduser -D -H -u 500 pki \
  && mkdir ${CFSSL_CERT_PATH} \
  && chown pki:pki ${CFSSL_CERT_PATH}

COPY overlay /

USER pki
WORKDIR ${CFSSL_CERT_PATH}
