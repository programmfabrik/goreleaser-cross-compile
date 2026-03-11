VERSION?=v1.26
ORIGIN_VERSION=v1.26
DOCKER_REGISTRY_2_URL=docker-push.fylr.io/goreleaser/goreleaser-cross

build:
	docker build \
		-t ${DOCKER_REGISTRY_2_URL}:${VERSION} \
		--build-arg VERSION=${ORIGIN_VERSION} \
		--no-cache \
		-f Dockerfile .

push:
	docker push ${DOCKER_REGISTRY_2_URL}:${VERSION}
