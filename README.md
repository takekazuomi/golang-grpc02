---
title: golang grpc Azure Container Apps sample project
---

## Overview

1. golang + grpc. almost as same as https://grpc.io/docs/languages/go/quickstart/.
2. docker
3. GitHub container registry
4. vscode devcontainer
5. deploy to azure container apps

## 1. Setup GitHub container registry

To use image from your private GitHub Packages account, do the following

1. [Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
2. Copy .envrc.local.template to .envrc.local and put your GitHub username and the PAT you created

Open with VSCode devcontainer and open a terminal in the directory where the Makefile is located. If the settings have been configured, the image will be built and pushed by the following command.

```sh
make gh-login build push
```

## 2. deploy to azure container apps

概ね下記の流れでおこなう。

- 1. setup
  - az cliへの containerapp extensionのインストール
  - github container repo(ghcr.io)へのログイン
- 2. build
  - container apps で使うAzure リソースの作成
- 3.deploy
  - container apps で使うAzure リソースの作成

### 1. setup

```sh
make setup
```

### 2. build

```sh
cd app
make build push
```

### 3. deploy

Set the following two items according to your environment.

```sh
export RESOURCE_GROUP=<your resource group name>
export CR_USER=<your github account name>
```

`container apps` の作成。`deploy/main.bicep` は、必要なリソース一式を作成する。デプロイには、docker imageが必要なので、ビルド、プッシュして、main.bicep deployの順で実行する。

```sh
make deploy
```

## update code

更新、コードを修正したら、新しいイメージをプッシュして、app-deployで`containerapps` リソースを更新する。

```sh
make build app-deploy
```

## TODO

WIP
