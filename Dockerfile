FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y curl unzip git -q && \
    apt-get clean

WORKDIR /workspace

ARG ISTIO_VERSION=1.27.1
# Install istioctl
RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=amd64 sh - && \
    ln -sf $(pwd)/istio-*/bin/istioctl /usr/local/bin/istioctl && \
    istioctl version

COPY ./entrypoint.sh  /workspace/

CMD ["/workspace/entrypoint.sh"]