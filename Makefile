APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=xl1ver
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
TARGETARCH=amd64 #amd64 arm64 x86_64
GCLOUD_REGISTRY=gcr.io
GCLOUD_PROJECT=devops-course-405218

linux:
	TARGETOS=linux TARGETARCH=amd64 build

arm:
	TARGETOS=linux TARGETARCH=arm build

macos:
	TARGETOS=windows TARGETARCH=amd64 build

windows:
	TARGETOS=windows TARGETARCH=amd64 build

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
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

image: 
	docker build . -t ${REGISTRY}/${APP}/${VERSION}-${TARGETARCH}

image-gcloud:
	docker build . -t $(GCLOUD_REGISTRY)/$(GCLOUD_PROJECT)/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}/${VERSION}-${TARGETARCH}

push-gcloud:
	docker push $(GCLOUD_REGISTRY)/$(GCLOUD_PROJECT)/${APP}:${VERSION}-${TARGETARCH}

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/geranton93/kbot/cmd.appVersion=${VERSION}
