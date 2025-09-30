FROM ubuntu:20.04

WORKDIR /workspace

RUN apt-get update && \
    apt-get install -y curl unzip git -q

ARG ISTIO_VERSION=latest

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv ./kubectl /usr/local/bin/ && \
    kubectl version --client

# Install istioctl
RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=amd64  sh - && \
    cp istio-*/bin/istioctl /usr/local/bin/ && \
    istioctl version

COPY ./entrypoint.sh ./helm-templates/istio-deployer/crds  /workspace/

CMD ["/workspace/entrypoint.sh"]