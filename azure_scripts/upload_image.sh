#!/bin/bash

# Log in to Azure
az login

# Log in to ACR
az acr login --name devopenwebui  # ACR Name 

# Pull the Open WebUI image from GitHub
docker pull ghcr.io/open-webui/open-webui:main

# Tag the image for ACR
docker tag ghcr.io/open-webui/open-webui:main devopenwebui.azurecr.io/open-webui:main

# Push the image to ACR
docker push devopenwebui.azurecr.io/open-webui:main  # ACR Image File Name 
