.DELETE_ON_ERROR:

GOLINT := artifacts/bin/golint
$(GOLINT):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go install golang.org/x/lint/golint@latest

artifacts/lint/golint: SHELL=/bin/bash -o pipefail
artifacts/lint/golint: $(GOLINT) $(GENERATED_FILES) $(GO_TEST_REQ) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(GOLINT) -set_exit_status ./... | tee "$(@)"

lint:: artifacts/lint/golint

tools:: $(GOLINT)
