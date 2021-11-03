.DELETE_ON_ERROR:

GORELEASER_VERSION ?= v0.183.0
GO_MODULE_PATH := $(shell go list -m)
GORELEASER := docker run --rm --privileged \
  -v "$(MF_PROJECT_ROOT):/go/src/$(GO_MODULE_PATH)" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w /go/src/$(GO_MODULE_PATH) \
  -e GITHUB_TOKEN \
  -e DOCKER_USERNAME \
  -e DOCKER_PASSWORD \
  -e DOCKER_REGISTRY \
  goreleaser/goreleaser:$(GORELEASER_VERSION)

artifacts/test/goreleaser: SHELL=/bin/bash -o pipefail
artifacts/test/goreleaser: .goreleaser.yml $(GENERATED_FILES) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	DOCKER_HOST= DOCKER_TLS_VERIFY= $(GORELEASER) check | tee "$(@)"

lint:: artifacts/test/goreleaser

tools::

.PHONY: goreleaser-build
goreleaser-build:
	DOCKER_HOST= DOCKER_TLS_VERIFY= $(GORELEASER) build $(GORELEASER_ARGS)

.PHONY: goreleaser-check
goreleaser-check:
	DOCKER_HOST= DOCKER_TLS_VERIFY= $(GORELEASER) check $(GORELEASER_ARGS)

.PHONY: goreleaser-init
goreleaser-init:
	DOCKER_HOST= DOCKER_TLS_VERIFY= $(GORELEASER) init $(GORELEASER_ARGS)

.PHONY: goreleaser-release
goreleaser-release:
	DOCKER_HOST= DOCKER_TLS_VERIFY= $(GORELEASER) release $(GORELEASER_ARGS)
