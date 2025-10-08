#!/bin/bash

cd /workspace

CONFIG_FILE="/config/istio-operator.yaml"

if [ -f "${CONFIG_FILE}" ]; then
    echo "Configuration file '${CONFIG_FILE}' exists."
    if grep -q "profile: ambient" "${CONFIG_FILE}"; then
        echo "Ambient profile extention found, proceed with an installation"
        istioctl install -y -f ${CONFIG_FILE}
    else
        echo "File content is invalid. There was no correct profile found for deployment"
        exit 1 
    fi
else
    echo "File '${CONFIG_FILE}' does not exist or is not a regular file. Exit on error"
    exit 1
fi

