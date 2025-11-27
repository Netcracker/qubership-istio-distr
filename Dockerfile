FROM ghcr.io/netcracker/qubership/core-base:2.0.0

USER root
WORKDIR /workspace

ARG ISTIO_VERSION=1.28.0
LABEL maintainer="qubership"

# Install istioctl
RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=amd64 sh - && \
    ln -sf $(pwd)/istio-*/bin/istioctl /usr/local/bin/istioctl 
RUN istioctl version --remote=false

COPY --chmod=755 ./entrypoint.sh  /workspace/entrypoint.sh

CMD ["/workspace/entrypoint.sh"]