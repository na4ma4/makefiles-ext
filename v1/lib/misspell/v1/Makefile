.DELETE_ON_ERROR:

MISSPELL := artifacts/bin/misspell
$(MISSPELL):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go install github.com/client9/misspell/cmd/misspell@latest

artifacts/lint/misspell: SHELL=/bin/bash -o pipefail
artifacts/lint/misspell: $(MISSPELL) $(GENERATED_FILES) $(GO_TEST_REQ) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(MISSPELL) -w -error -locale UK ./... | tee "$(@)"

lint:: artifacts/lint/misspell

tools:: $(MISSPELL)
