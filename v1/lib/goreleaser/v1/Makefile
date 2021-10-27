.DELETE_ON_ERROR:

GORELEASER_VERSION ?= v0.183.0
GO_MODULE_PATH := $(go list -m)
GORELEASER := docker run --rm --privileged \
  -v "$(MF_PROJECT_ROOT):/go/src/$(GO_MODULE_PATH)" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w /go/src/$(GO_MODULE_PATH) \
  -e GITHUB_TOKEN \
  -e DOCKER_USERNAME \
  -e DOCKER_PASSWORD \
  -e DOCKER_REGISTRY \
  goreleaser/goreleaser

artifacts/test/goreleaser: SHELL=/bin/bash -o pipefail
artifacts/test/goreleaser: .goreleaser.yml $(GENERATED_FILES) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(GORELEASER) check | tee "$(@)"

lint:: artifacts/test/goreleaser

tools::

.PHONY: goreleaser-build
goreleaser-build:
	$(GORELEASER) build $(GORELEASER_ARGS)

.PHONY: goreleaser-check
goreleaser-check:
	$(GORELEASER) check $(GORELEASER_ARGS)

.PHONY: goreleaser-init
goreleaser-init:
	$(GORELEASER) init $(GORELEASER_ARGS)

.PHONY: goreleaser-release
goreleaser-release:
	$(GORELEASER) release $(GORELEASER_ARGS)
