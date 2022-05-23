.DELETE_ON_ERROR:

GORELEASER_VERSION ?= v1.9.1
GORELEASER := artifacts/bin/goreleaser
$(GORELEASER):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	curl -sSfL https://raw.githubusercontent.com/na4ma4/makefiles-ext/main/scripts/install-goreleaser.sh | sh -s -- -b "$(@D)" -v "$(GORELEASER_VERSION)"
# GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go install github.com/goreleaser/goreleaser@$(GORELEASER_VERSION)

artifacts/test/goreleaser: SHELL=/bin/bash -o pipefail
artifacts/test/goreleaser: .goreleaser.yml $(GORELEASER) $(GENERATED_FILES) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	DOCKER_HOST= DOCKER_TLS_VERIFY= $(GORELEASER) check | tee "$(@)"

lint:: artifacts/test/goreleaser

tools::

.PHONY: goreleaser-build
goreleaser-build: $(GORELEASER)
	DOCKER_HOST= DOCKER_TLS_VERIFY= $(GORELEASER) build $(GORELEASER_ARGS)

.PHONY: goreleaser-check
goreleaser-check: $(GORELEASER)
	DOCKER_HOST= DOCKER_TLS_VERIFY= $(GORELEASER) check $(GORELEASER_ARGS)

.PHONY: goreleaser-init
goreleaser-init: $(GORELEASER)
	DOCKER_HOST= DOCKER_TLS_VERIFY= $(GORELEASER) init $(GORELEASER_ARGS)

.PHONY: goreleaser-release
goreleaser-release: $(GORELEASER)
	DOCKER_HOST= DOCKER_TLS_VERIFY= $(GORELEASER) release $(GORELEASER_ARGS)
