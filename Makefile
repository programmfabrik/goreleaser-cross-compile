VERSION?=v1.20.0
ORIGIN_VERSION=v1.20.0
DOCKER_REGISTRY_URL=docker.fylr.io/goreleaser/goreleaser-cross

build:
	docker build \
		-t ${DOCKER_REGISTRY_URL}:${VERSION} \
		--build-arg VERSION=${ORIGIN_VERSION} \
		--no-cache \
		-f Dockerfile .

push:
	docker push ${DOCKER_REGISTRY_URL}:${VERSION}
