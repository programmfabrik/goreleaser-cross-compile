VERSION?=v1.21.1
ORIGIN_VERSION=v1.21.1
DOCKER_REGISTRY_2_URL=docker-push.fylr.io/goreleaser/goreleaser-cross

build:
	docker build \
		-t ${DOCKER_REGISTRY_2_URL}:${VERSION} \
		--build-arg VERSION=${ORIGIN_VERSION} \
		--no-cache \
		-f Dockerfile .

push:
	docker push ${DOCKER_REGISTRY_2_URL}:${VERSION}
