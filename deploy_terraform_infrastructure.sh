#!/bin/bash

# Reading application associative arrays
source apps_to_deploy.sh

terraform_deploy() {
    terraform init
    terraform workspace new ${ENV}
    terraform workspace select ${ENV}
    terraform apply -auto-approve -var environment_prefix="${ENV}"

    if [ ${?} -ne 0 ]; then
        echo 'Error encountered when creating the resource with terraform.' >&2
        exit 1
    fi
}


#Check for input paramenters
if [ ${#} -ne 2 ]; then
    echo 'This script requires porject and environment arguments' >&2
    echo "Usage ${0}  <project> <environment>" >&2
    exit 1
fi

echo 'Deploying the infrastructure...'

PROJECT=$(echo "${1}" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
ENV=$(echo "${2}" | tr '[:upper:]' '[:lower:]')

WORKING_DIR=${PWD}
# Added this list to keep the order in which the resource types are deployed
LAYER_FOLDERS=(azure_postgres_servers azure_databases container_instances web_apps azure_functions)

for i in "${!LAYER_FOLDERS[@]}"; do 
    #fetch the layer folder
    LAYER_FOLDER=${LAYER_FOLDERS[$i]}
    cd ${LAYER_FOLDER}

    # Go through each of the resource that is listed and deploy it
    RESOURCE_FOLDERS=${PROJECT}[$LAYER_FOLDER]
    for RESOURCE_FOLDER in ${!RESOURCE_FOLDERS}; do
        if [ ! -z ${RESOURCE_FOLDER} ]; then 
            echo "Deploying ${RESOURCE_FOLDER}..."
            cd ${RESOURCE_FOLDER}
            terraform_deploy
            cd ..
        fi
        done

    cd ${WORKING_DIR}
done

exit 0