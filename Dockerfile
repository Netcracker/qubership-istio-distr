# renovate: datasource=docker depName=ghcr.io/netcracker/qubership-core-base
FROM ghcr.io/netcracker/qubership-core-base:2.2.4

USER root
WORKDIR /workspace

# renovate: datasource=github-releases depName=istio/istio
ARG ISTIO_VERSION=1.29.0
LABEL maintainer="qubership"

# Install istioctl
RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=amd64 sh - && \
    ln -sf $(pwd)/istio-*/bin/istioctl /usr/local/bin/istioctl 
RUN istioctl version --remote=false

COPY --chmod=755 ./entrypoint.sh  /workspace/entrypoint.sh

CMD ["/workspace/entrypoint.sh"]