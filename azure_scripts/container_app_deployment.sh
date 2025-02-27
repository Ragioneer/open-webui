# First make an environment variable
# export OPENAI_API_KEY=""

#!/bin/bash

echo "Logging into Azure..."
az login

echo "Log in to ACR"
az acr login --name devopenwebui
echo "Login Succeeded"

# Define Variables
RESOURCE_GROUP="dev-stage"
CONTAINER_APP_NAME="dev-open-webui"
REGISTRY_SERVER="devopenwebui.azurecr.io"
IMAGE_NAME="open-webui:main"
STORAGE_NAME="open-webui"
MOUNT_PATH="/app/backend/data"
REGION="eastus"  # Change this to your preferred region

# Ensure OPENAI_API_KEY is set in the environment
if [ -z "$OPENAI_API_KEY" ]; then
  echo "Error: OPENAI_API_KEY is not set. Please export it before running this script."
  exit 1
fi

# Step 1: Create a new Container Apps Environment (auto-generate name)
ENVIRONMENT_NAME="managedEnvironment-${RESOURCE_GROUP}-$(openssl rand -hex 3)"

az containerapp env create \
  --name $ENVIRONMENT_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $REGION

# Step 2: Deploy the Container App
az containerapp create \
  --name $CONTAINER_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --environment $ENVIRONMENT_NAME \
  --image $REGISTRY_SERVER/$IMAGE_NAME \
  --registry-server $REGISTRY_SERVER \
  --ingress external \
  --target-port 8080 \
  --env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --volume name=$STORAGE_NAME storage-type=EmptyDir mount-path=$MOUNT_PATH \
  --restart-policy Always

echo "Container App $CONTAINER_APP_NAME deployed successfully in environment $ENVIRONMENT_NAME (Region: $REGION)"
