GORELEASER_VERSION ?= v0.159.0
GORELEASER := artifacts/bin/$(GORELEASER_VERSION)/goreleaser
$(GORELEASER):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	curl -sSfL https://install.goreleaser.com/github.com/goreleaser/goreleaser.sh | sh -s -- -b "$(MF_PROJECT_ROOT)/$(@D)" $(GORELEASER_VERSION)

artifacts/test/goreleaser: $(GORELEASER) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(GORELEASER) check | tee "$(@)"

test:: artifacts/test/goreleaser

tools:: $(GORELEASER)

.PHONY: goreleaser-%
goreleaser-%: $(GORELEASER)
	$(GORELEASER) $(*) $(GORELEASER_ARGS)
