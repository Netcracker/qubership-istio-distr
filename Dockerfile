FROM ghcr.io/netcracker/qubership/core-base:2.0.0

WORKDIR /workspace

ARG ISTIO_VERSION=1.28.0
LABEL maintainer="qubership"

USER root

# Install istioctl
RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=amd64 sh - && \
    ln -sf $(pwd)/istio-*/bin/istioctl /usr/local/bin/istioctl && \
    istioctl version

COPY --chown=10001:0 --chmod=755 ./entrypoint.sh  /workspace/entrypoint.sh

USER 10001:10001

CMD ["/workspace/entrypoint.sh"]