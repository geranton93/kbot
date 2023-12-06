APP=$(shell basename $(shell git remote get-url origin))
REGISTRY_DEFAULT=xl1ver
REGISTRY ?= $(REGISTRY_DEFAULT)
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux # darwin windows
TARGETARCH=amd64 # arm64 x86_64
GCLOUD_REGISTRY=gcr.io
GCLOUD_PROJECT=devops-course-405218

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
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

image-gcloud:
	docker build . -t $(GCLOUD_REGISTRY)/$(GCLOUD_PROJECT)/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push-gcloud:
	docker push $(GCLOUD_REGISTRY)/$(GCLOUD_PROJECT)/${APP}:${VERSION}-${TARGETARCH}

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/geranton93/kbot/cmd.appVersion=${VERSION}

define build_template
build-$(1)-$(2): format
        CGO_ENABLED=0 GOOS=$(1) GOARCH=$(2) go build -v -o kbot -ldflags "-X="github.com/geranton93/kbot/cmd.appVersion=${VERSION}
endef

$(foreach os, $(TARGETOS), $(foreach arch, $(TARGETARCH), $(eval $(call build_template,$(os),$(arch)))))
