#!/bin/bash

# Reading application associative arrays
source apps_to_deploy.sh

terraform_terminate() {
    terraform init
    terraform workspace new ${ENV}
    terraform workspace select ${ENV}
    terraform destroy -auto-approve -var environment_prefix="${ENV}"

    if [ ${?} -ne 0 ]; then
        echo 'Error encountered when destroying the resource with terraform.' >&2
        exit 1
    fi
}


#Check for input paramenters
if [ ${#} -ne 2 ]; then
    echo 'This script requires porject and environment arguments' >&2
    echo "Usage ${0}  <project> <environment>" >&2
    exit 1
fi

echo 'Terminating the infrastructure...'

PROJECT=$(echo "${1}" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
ENV=$(echo "${2}" | tr '[:upper:]' '[:lower:]')

WORKING_DIR=${PWD}
# Added this list to keep the order in which the resource types are deployed
LAYER_FOLDERS=( azure_functions web_apps container_instances azure_databases azure_postgres_servers )

for i in "${!LAYER_FOLDERS[@]}"; do 
    #fetch the layer folder
    LAYER_FOLDER=${LAYER_FOLDERS[$i]}
    cd ${LAYER_FOLDER}

    # Go through each of the resource that is listed and deploy it
    RESOURCE_FOLDERS=${PROJECT}[$LAYER_FOLDER]

    # if this the database folder and the project has database resrouces, wait before destroying any database resource
    if [ ${LAYER_FOLDER} == 'azure_databases' ]  && [[  ! -z ${!RESOURCE_FOLDERS// } ]]; then
        echo 'Waiting 5 mins for Azure to complete updating, before destroying the DB layer...'
        sleep 5m
    fi

    for RESOURCE_FOLDER in ${!RESOURCE_FOLDERS}; do
        if [ ! -z ${RESOURCE_FOLDER} ]; then
            echo "Terminating ${RESOURCE_FOLDER}..."
            cd ${RESOURCE_FOLDER}
            terraform_terminate
            cd ..
        fi
        done

    cd ${WORKING_DIR}


done

exit 0