.DELETE_ON_ERROR:

# GOLANGCILINT_CHECK_DISABLE += exhaustivestruct
# GOLANGCILINT_CHECK_DISABLE += interfacer
# GOLANGCILINT_CHECK_DISABLE += maligned
# GOLANGCILINT_CHECK_DISABLE += paralleltest

# A literal space.
_golangcilint_space :=
_golangcilint_space +=

# A literal comma.
_golangcilint_comma := ,

GOLANGCILINT_VERSION ?= v1.38.0
GOLANGCILINT := artifacts/bin/$(GOLANGCILINT_VERSION)/golangci-lint
$(GOLANGCILINT):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(MF_PROJECT_ROOT)/$(@D)" $(GOLANGCILINT_VERSION)

artifacts/lint/golangci-lint: SHELL=/bin/bash -o pipefail
artifacts/lint/golangci-lint: $(GOLANGCILINT) $(GENERATED_FILES) $(GO_TEST_REQ) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(GOLANGCILINT) run --sort-results --disable '$(subst $(_golangcilint_space),$(_golangcilint_comma),$(GOLANGCILINT_CHECK_DISABLE))' ./... | tee "$(@)"

lint:: artifacts/lint/golangci-lint

tools:: $(GOLANGCILINT)
