.DELETE_ON_ERROR:

GOVULNCHECK_VERSION ?= latest
GOVULNCHECK := artifacts/bin/$(GOVULNCHECK_VERSION)/govulncheck
$(GOVULNCHECK):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go install golang.org/x/vuln/cmd/govulncheck@$(GOVULNCHECK_VERSION)

artifacts/test/govulncheck: SHELL=/bin/bash -o pipefail
artifacts/test/govulncheck: $(GOVULNCHECK) $(GENERATED_FILES) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(GOVULNCHECK) ./... | tee "$(@)"

lint:: artifacts/test/govulncheck
