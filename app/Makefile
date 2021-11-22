CR_NAME		?= ghcr.io
CR_USER		?= takekazuomi
IMAGE_NAME	?= $(CR_NAME)/$(CR_USER)/golang-grpc02
TAG		= $(shell git log -1 --pretty=format:%h)
SERVER		= localhost
SERVER_PORT	= 50051


help:		## Show this help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

up:		## Run in docker
	docker run --rm -it -p $(SERVER_PORT):50051 $(IMAGE_NAME):$(TAG)

build:		## build docker image`
	docker build \
		-t $(IMAGE_NAME):$(TAG) \
		-t $(IMAGE_NAME):latest \
		-f Dockerfile .

push:		## push to container registry
push:	build
	docker push $(IMAGE_NAME):$(TAG)
	docker push $(IMAGE_NAME):latest

ghcr-login:	## login github container registry
	echo $${CR_PAT} | docker login ghcr.io -u $(CR_USER) --password-stdin

login:		## login docker shell
	docker run -it --rm -u=$$(id -u):$$(id -g) -v $(PWD):/workspace $(IMAGE_NAME):$(TAG) /bin/sh

proto:
	protoc --go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative \
		helloworld/helloworld.proto

go-install:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.27
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1
	go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

proto-list:
	docker run --rm -v $${PWD}/helloworld:/protos fullstorydev/grpcurl -import-path /protos -proto helloworld.proto list

grpcurl:		## grpcurl container apps
#	$(GRPCURL) -proto helloworld/helloworld.proto $(SERVER):$(SERVER_PORT) helloworld.Greeter.SayHello
	if [ "$(SERVER_PORT)" != "443" ]; then \
        	OPT="--plaintext"; \
	fi;\
	docker run --rm -v $${PWD}/helloworld:/protos --network=host fullstorydev/grpcurl \
		$${OPT} \
		-proto ../protos/helloworld.proto $(SERVER):$(SERVER_PORT) helloworld.Greeter.SayHello

grpcurl-list:		## grpcurl helloworld.proto service list
	docker run --rm -v $${PWD}/helloworld:/protos fullstorydev/grpcurl \
		-import-path /protos \
		-proto helloworld.proto list
