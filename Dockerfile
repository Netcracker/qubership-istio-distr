FROM alpine:3.22.2

WORKDIR /workspace

RUN apk update --no-cache
RUN apk add --no-cache ca-certificates curl bash
RUN apk add --no-cache --upgrade libcrypto3 libssl3

ARG ISTIO_VERSION=1.27.1

# Install istioctl
RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=amd64  sh - && \
    ln -sf $(pwd)/istio-*/bin/istioctl /usr/local/bin/istioctl && \
    istioctl version

COPY --chmod=555 ./entrypoint.sh  /workspace/

CMD ["/workspace/entrypoint.sh"]