FROM ghcr.io/netcracker/qubership/core-base:2.0.0

WORKDIR /workspace

ARG ISTIO_VERSION=1.28.0

# Install istioctl
RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=amd64 sh - && \
    ln -sf $(pwd)/istio-*/bin/istioctl /usr/local/bin/istioctl && \
    istioctl version

COPY --chmod=555 ./entrypoint.sh  /workspace/

CMD ["/workspace/entrypoint.sh"]