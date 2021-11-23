RESOURCE_GROUP				= omi01-rg
LOCATION				= canadacentral
NAME					= golang-grpc02
CONTAINERAPPS_ENVIRONMENT		= containerapps-env01
CONTAINERAPPS_NAME			= $(NAME)
CR_NAME					?= ghcr.io
CR_USER					?= takekazuomi
IMAGE_NAME				?= $(CR_NAME)/$(CR_USER)/$(NAME)
APP_FQDN				?= $(shell az containerapp show \
						--resource-group $(RESOURCE_GROUP) \
						--name $(CONTAINERAPPS_NAME) \
						--query configuration.ingress.fqdn \
						-o tsv)
TAG					= $(shell git log -1 --pretty=format:%h)
MIN_REPLICAS				= 1
TRANSPORT				= http2
ALLOWINSECURE				= false
SERVER_PORT				= 443
CONTAINER_PORT				= 50051
CONTAINER_ONLY				= false

help:		## Show this help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

setup: 			## initial setup. only for first time
setup: setup-azcli
	cd app; $(MAKE) ghcr-login

setup-azcli:
	az extension show -n containerapp -o none || \
	az extension add --upgrade \
	--source https://workerappscliextension.blob.core.windows.net/azure-cli-extension/containerapp-0.2.0-py2.py3-none-any.whl

create-rg:		## create resouce group
	az group create \
	--name $(RESOURCE_GROUP) \
	--location "$(LOCATION)"

app-list:		## list container apps
	az containerapp list \
	--resource-group $(RESOURCE_GROUP) \
	-o table

app-show:		## show container apps
	az containerapp show \
	--resource-group $(RESOURCE_GROUP) \
	--name $(CONTAINERAPPS_NAME) \
	-o json

rev-list:		## show details of a containerapp's revision
	az containerapp revision list \
	--resource-group $(RESOURCE_GROUP) \
	--name $(CONTAINERAPPS_NAME) \
	-o json

app-fqdn:		## show container apps fqdn
	@echo $(APP_FQDN)

app-grpcurl:		## curl container apps
	cd app; $(MAKE) grpcurl SERVER=$(APP_FQDN) SERVER_PORT=$(SERVER_PORT)

app-delete:		## delete container apps
	az containerapp delete \
	--resource-group $(RESOURCE_GROUP) \
	--name $(CONTAINERAPPS_NAME) \
	-o table

build:			## build application
	cd app; $(MAKE) CR_NAME=$(CR_NAME) CR_USER=$(CR_USER) IMAGE_NAME=$(IMAGE_NAME) TAG=$(TAG) build push

.PHONY: deploy
deploy:
	az deployment group create -g $(RESOURCE_GROUP) -f ./deploy/main.bicep \
	-p \
	environmentName=$(CONTAINERAPPS_ENVIRONMENT) \
	containerAppName=$(CONTAINERAPPS_NAME) \
	containerImage=$(IMAGE_NAME):$(TAG) \
	containerPort=$(CONTAINER_PORT) \
	containerRegistry=$(CR_NAME) \
	containerRegistryUsername=$(CR_USER) \
	containerRegistryPassword=$${CR_PAT} \
	minReplicas=$(MIN_REPLICAS) \
	isExternalIngress=true \
	transport=$(TRANSPORT) \
	allowInsecure=$(ALLOWINSECURE) \
	containerOnly=$(CONTAINER_ONLY) \
	-o table

app-deploy:
	$(MAKE) deploy CONTAINER_ONLY=true

clean:
	az group delete \
	--name $(RESOURCE_GROUP)

