# goreleaser-cross-compile

## Description

This repository extends the [cross-compile docker image for goreleaser](https://github.com/goreleaser/goreleaser-cross) to build the [fylr](https://github.com/programmfabrik/fylr) application.

## Tag schema

Tags follow the [origin version scheme] (https://github.com/goreleaser/goreleaser-cross/releases) with one exception:

Versions that follow the `vX.X.X-X` scheme are intended as patches for the origin `vX.X.X` version

## Updating this to a newer version

1. at least update the versions in `Makefile`

2. make a release in this repository with a new tag, syntax as the other existing releases

## Using our variant of goreleaser-cross

1. Place a `.goreleaser.yml` file in the root of the repository you want to use it in. See `.goreleaser.yml` in  [fylr](https://github.com/programmfabrik/fylr) if you have access. Otherwise: Example:

```yaml
before:
  hooks:
    - make generate
    - go mod tidy

builds:
  - id: fylr-build-darwin-amd64
    binary: example
    env:
      - CGO_ENABLED=1
      - CC=o64-clang
      - CXX=o64-clang++
    main: .
    goos:
      - darwin
    goarch:
      - amd64
    ldflags:
      - -s -w -X main.buildCommit=${GIT_COMMIT_SHA} -X main.buildTime=${BUILD_TIME} -X main.buildVersion={{.Version}}

  - id: fylr-build-darwin-arm64
    binary: example
    env:
      - CGO_ENABLED=1
      - CC=aarch64-apple-darwin20.2-clang
      - CXX=aarch64-apple-darwin20.2-clang++
    main: .
    goos:
      - darwin
    goarch:
      - arm64
    ldflags:
      - -s -w -X main.buildCommit=${GIT_COMMIT_SHA} -X main.buildTime=${BUILD_TIME} -X main.buildVersion={{.Version}}

  - id: fylr-build-linux
    binary: example
    env:
      - CGO_ENABLED=1
    main: .
    goos:
      - linux
    goarch:
      - amd64
    ldflags:
      - -s -w -X main.buildCommit=${GIT_COMMIT_SHA} -X main.buildTime=${BUILD_TIME} -X main.buildVersion={{.Version}}

  - id: fylr-build-windows-x64
    binary: example
    env:
      - CGO_ENABLED=1
      - CC=x86_64-w64-mingw32-gcc
      - CXX=x86_64-w64-mingw32-g++
    main: .
    goos:
      - windows
    goarch:
      - amd64
    ldflags:
      - -s -w -X main.buildCommit=${GIT_COMMIT_SHA} -X main.buildTime=${BUILD_TIME} -X main.buildVersion={{.Version}} -buildmode=exe

archives:
- format: tar.gz
  format_overrides:
    - goos: windows
      format: zip
  name_template: "{{ .Binary }}_v{{ .Version }}_{{ .ShortCommit }}_{{ .Os }}_{{ .Arch }}"
  replacements:
    amd64: x64
    arm64: ARM64
    darwin: macOS
    linux: Linux
    windows: Windows
  allow_different_binary_count: true

release:
  draft: true
  prerelease: auto
  name_template: "Release {{.Tag}}"

checksum:
  name_template: "{{ .ProjectName }}_checksums.txt"

snapshot:
  name_template: SNAPSHOT-{{.ShortCommit}}

changelog:
  use: github
  sort: asc
  groups:
    - title: Features
      regexp: "^.*feat[(\\w)]*:+.*$"
      order: 0
    - title: "Bug fixes"
      regexp: "^.*fix[(\\w)]*:+.*$"
      order: 1
    - title: "Enhancements"
      regexp: "^.*enhancement[(\\w)]*:+.*$"
      order: 2
    - title: Others
      order: 999
  filters:
    exclude:
      - "^docs:"
      - "^test:"
      - "^github:"
      - "^ci:"
      - "^cd:"
      - "^ci/cd:"
      - "^example:"
      - "^gomod:"
      - "^git:"
      - "^goreleaser:"
      - "^Merge branch"
      - "WIP"
```

2. run goreleaser-cross

in this example: a snapshot (--snapshot)

```bash
docker run \
    --rm \
    --privileged \
    -e CGO_ENABLED=1 \
    --env-file .release-env \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v `pwd`:/go/src/$(PACKAGE_NAME) \
    -v `pwd`/sysroot:/sysroot \
    -w /go/src/$(PACKAGE_NAME) \
    docker.fylr.io/goreleaser/goreleaser-cross:${GOLANG_CROSS_VERSION} \
    release --rm-dist --snapshot
```

