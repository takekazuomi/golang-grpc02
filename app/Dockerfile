# syntax=docker/dockerfile:1

FROM golang:1.17-bullseye as builder

ENV PROTOC_VER 3.19.1

WORKDIR /app

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
	&& apt-get install -y --no-install-recommends \
		unzip \
	; \
	rm -rf /var/lib/apt/lists/*

RUN wget -q -P /tmp https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VER}/protoc-${PROTOC_VER}-linux-x86_64.zip; \
    cd /usr/local && unzip /tmp/protoc-${PROTOC_VER}-linux-x86_64.zip; \
    go get -u -v github.com/golang/protobuf/protoc-gen-go

COPY . .
RUN go mod download -x

ENV CGO_ENABLED=0
RUN go build -o server/server server/main.go \
    && go build -o client/client client/main.go


FROM scratch
#FROM debian:bullseye-slim

WORKDIR /app
#COPY --from=builder /app/client/client .
COPY --from=builder /app/server/server .

CMD [ "./server" ]
