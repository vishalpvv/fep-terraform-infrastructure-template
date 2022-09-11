#!/bin/bash

# Declared associative array that keeps a link between the main folders and the resource underneath it
# E.g. how to include multiple resources in a deployment layer
# [web_apps]='enrichment_web_app
#             fep_postcode_service_web_app'

declare -A ENRICHMENT=(
     [azure_postgres_servers]='shared_postgres_server'
     [azure_databases]='sec_api_postgres_db'
     [web_apps]='enrichment_web_app')

declare -A DATAFEED=(
     [azure_postgres_servers]='shared_postgres_server'
     [azure_databases]='sec_api_postgres_db'
     [web_apps]='datafeed_web_app')

declare -A TASKMANAGER=(
     [azure_postgres_servers]='shared_postgres_server'
     [azure_databases]='task_mgr_postgres_db
                       reference_data_postgres_db'
     [web_apps]='taskmanager_web_app')

declare -A PUSH_API=(
     [web_apps]='push_api_web_app')

declare -A REFERENCE_DB=(
    [web_apps]='reference_db_web_app')

declare -A DATA_RETENTION=(
     [azure_functions]='data_retention_function')

declare -A PENNY_BLACK=(
     [azure_postgres_servers]='shared_postgres_server'
     [azure_databases]='penny_black_postgres_db'
     [web_apps]='penny_black_web_app')