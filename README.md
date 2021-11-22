---
title: golang grpc Azure Container Apps sample project
---

## Overview

1. golang + grpc. almost as same as <https://grpc.io/docs/languages/go/quickstart>
2. docker
3. GitHub container registry
4. vscode devcontainer
5. deploy to azure container apps. almost as same as <https://github.com/Azure-Samples/container-apps-store-api-microservice>

## 1. Setup GitHub container registry

To use image from your private GitHub Packages account, do the following

1. [Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
2. Copy .envrc.local.template to .envrc.local and put your GitHub username and the PAT you created

Open with VSCode devcontainer and open a terminal in the directory where the Makefile is located. If the settings have been configured, the image will be built and pushed by the following command.

## 2. deploy to azure container apps

### setup

first time only

```sh
make setup
az login
```

### build

```sh
export RESOURCE_GROUP=<your resource group name>
export CR_USER=<your github account name>

make create-rg
make build
```

### 3. deploy

Set the following two items according to your environment.

```sh
make deploy
```

### 4. to confirm

Check if you can call it using grpc curl. If message is returned, it is successful.

```sh
$ make app-grpcurl
WARNING: Command group 'containerapp' is in preview and under development. Reference and support levels: https://aka.ms/CLI_refstatus
cd app; make grpcurl SERVER=golang-grpc02.gentlepond-b91fb3f5.canadacentral.azurecontainerapps.io SERVER_PORT=443
make[1]: Entering directory '/workspaces/golang-grpc02/app'
if [ "443" != "443" ]; then \
                OPT="--plaintext"; \
fi;\
docker run --rm -v ${PWD}/helloworld:/protos --network=host fullstorydev/grpcurl \
        ${OPT} \
        -proto ../protos/helloworld.proto golang-grpc02.gentlepond-b91fb3f5.canadacentral.azurecontainerapps.io:443 helloworld.Greeter.SayHello
{
  "message": "Hello  from golang-grpc02--qze7q05-854d975c4f-zq8qw"
}
```

## TODO

WIP
