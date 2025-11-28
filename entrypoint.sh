#!/bin/bash

cd /workspace || exit 1

CONFIG_FILE="/config/istio-operator.yaml"
WAIT_TIMEOUT="${WAIT_TIMEOUT:-10}"  
POLL_INTERVAL="${POLL_INTERVAL:-2}"  

echo "Waiting up to ${WAIT_TIMEOUT}s for config file '${CONFIG_FILE}'..."

start_time=$(date +%s)
end_time=$((start_time + WAIT_TIMEOUT))

while true; do
    if [ -f "${CONFIG_FILE}" ]; then
        echo "Configuration file '${CONFIG_FILE}' found."
        break
    fi

    now=$(date +%s)
    if [ "${now}" -ge "${end_time}" ]; then
        echo "Timed out waiting for '${CONFIG_FILE}' after ${WAIT_TIMEOUT}s. File does not exist or is not a regular file. Exit on error"
        exit 1
    fi

    echo "Config not present yet; sleeping ${POLL_INTERVAL}s..."
    sleep "${POLL_INTERVAL}"
done

if grep -q "profile: ambient" "${CONFIG_FILE}"; then
    echo "Ambient profile extension found, proceed with an installation"
    istioctl install -y -f "${CONFIG_FILE}"
else
    echo "Unsupported configuration: configuration should have 'profile: ambient' parameter set"
    exit 1 
fi

