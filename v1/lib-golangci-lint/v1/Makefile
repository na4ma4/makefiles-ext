GOLANGCILINT_VERSION ?= v1.38.0

GOLANGCILINT := artifacts/bin/$(GOLANGCILINT_VERSION)/golangci-lint
$(GOLANGCILINT):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(MF_PROJECT_ROOT)/$(@D)" $(GOLANGCILINT_VERSION)

artifacts/lint/golangci-lint: $(GOLANGCILINT)
	$(GOLANGCILINT) run --enable-all --disable 'exhaustivestruct,interfacer,maligned,paralleltest' ./...

lint:: artifacts/lint/golangci-lint
