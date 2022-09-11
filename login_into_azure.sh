#!/bin/bash

if [ ${#} -ne 2 ]; then
    echo 'This script requires username and password arguments.' >&2
    echo "Usage ${0} <username> <password>" >&2
    exit 1
fi

AZURE_USERNAME="${1}"
AZURE_PASS="${2}"

echo 'Login into Azure..'
az login --username "${AZURE_USERNAME}"  --password "${AZURE_PASS}"
az account set --subscription "SUBSCRIPTION_NAME"

exit ${?}