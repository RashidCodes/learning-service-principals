#!/bin/bash 

# How to create firewall rules for an Azure Devops Agent
check_run_status() {
    : '
    Check the run status of the most recent command
    '

    if [[ $? -eq 0 ]]
    then 
        echo $1;
    else 
        echo $2;
    fi;
}


# Create an enterprise application (service principal)
# az ad sp create-for-rbac

# Assign a role to the service principal
# Roles can also be assigned to the resource directly (portal)
# az role assignment create --assignee ${USERNAME} --role ${ROLE} --scope /subscriptions/${SUBSCRIPTION}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.Sql/servers/${SERVER_NAME}

# Get the service principal details (Get details from Marco)
. ./env.sh
START_IP_ADDRESS=$(ip addr show $(ip route | awk '/default/ { print $5 }') | grep "inet" | head -n 1 | awk '/inet/ {print $2}' | cut -d'/' -f1);
END_IP_ADDRESS=$(ip addr show $(ip route | awk '/default/ { print $5 }') | grep "inet" | head -n 1 | awk '/inet/ {print $2}' | cut -d'/' -f1);
FIREWALL_RULE_NAME="AllowUbuntuContainer"

# Login using user name and password
az login --service-principal -u ${USERNAME} -p ${PASSWORD} --tenant ${TENANT} &> /dev/null
check_run_status "Successfully logged in" "Failed to login into tenant: ${TENANT}";

# Add firewall rule
az sql server firewall-rule create -g ${RESOURCE_GROUP} -s ${SERVER_NAME} -n allowLocalMachineRule --start-ip-address ${START_IP_ADDRESS} --end-ip-address ${END_IP_ADDRESS} &> /dev/null
check_run_status "Successfully created firewall rule: ${FIREWALL_RULE_NAME}" "Failed to create firewall rule: ${FIREWALL_RULE_NAME}";

# Perform SQL Tasks

# Remove firewall rule
az sql server firewall-rule delete -g ${RESOURCE_GROUP} -s ${SERVER_NAME} -n allowLocalMachineRule;
check_run_status "Successfully deleted firewall rule: ${FIREWALL_RULE_NAME}" "Failed to delete firewall rule: ${FIREWALL_RULE_NAME}"