VERSION?=v1.19.0
DOCKER_REGISTRY_URL=docker.fylr.io/goreleaser/goreleaser-cross

build:
	docker build \
		-t ${DOCKER_REGISTRY_URL}:${VERSION} \
		--build-arg VERSION=${VERSION} \
		--no-cache \
		-f Dockerfile .

push:
	docker push ${DOCKER_REGISTRY_URL}:${VERSION}
