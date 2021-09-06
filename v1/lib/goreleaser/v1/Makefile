.DELETE_ON_ERROR:

GORELEASER_VERSION ?= v0.177.0
GORELEASER := artifacts/bin/$(GORELEASER_VERSION)/goreleaser
$(GORELEASER):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	curl -sSfL https://install.goreleaser.com/github.com/goreleaser/goreleaser.sh | sh -s -- -b "$(MF_PROJECT_ROOT)/$(@D)" $(GORELEASER_VERSION)

artifacts/test/goreleaser: SHELL=/bin/bash -o pipefail
artifacts/test/goreleaser: $(GORELEASER) .goreleaser.yml $(GENERATED_FILES) $(GO_TEST_REQ) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(GORELEASER) check | tee "$(@)"

lint:: artifacts/test/goreleaser

tools:: $(GORELEASER)

.PHONY: goreleaser-build
goreleaser-build: $(GORELEASER)
	$(GORELEASER) build $(GORELEASER_ARGS)

.PHONY: goreleaser-check
goreleaser-check: $(GORELEASER)
	$(GORELEASER) check $(GORELEASER_ARGS)

.PHONY: goreleaser-init
goreleaser-init: $(GORELEASER)
	$(GORELEASER) init $(GORELEASER_ARGS)

.PHONY: goreleaser-release
goreleaser-release: $(GORELEASER)
	$(GORELEASER) release $(GORELEASER_ARGS)
