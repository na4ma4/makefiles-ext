GOLANGCILINT_VERSION ?= v1.38.0
GOLANGCILINT := artifacts/bin/$(GOLANGCILINT_VERSION)/golangci-lint
$(GOLANGCILINT):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(MF_PROJECT_ROOT)/$(@D)" $(GOLANGCILINT_VERSION)

artifacts/lint/golangci-lint: $(GOLANGCILINT) $(GENERATED_FILES) $(GO_TEST_REQ) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(GOLANGCILINT) run --enable-all --disable 'exhaustivestruct,interfacer,maligned,paralleltest' ./... | tee "$(@)"

lint:: artifacts/lint/golangci-lint

tools:: $(GOLANGCILINT)
