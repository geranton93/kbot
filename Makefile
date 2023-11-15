APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=xl1ver
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64

format: 
	gofmt -s -w ./

lint:
	golint

install:
	go get

test:
	go test -v

clean:
	rm -rf kbot

image: 
	docker build . -t ${REGISTRY}/${APP}/${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}/${VERSION}-${TARGETARCH}

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/geranton93/kbot/cmd.appVersion=${VERSION}