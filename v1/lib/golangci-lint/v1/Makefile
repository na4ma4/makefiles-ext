.DELETE_ON_ERROR:

## Example Variables
# GOLANGCILINT_CHECK_DISABLE += exhaustivestruct
# GOLANGCILINT_CHECK_DISABLE += paralleltest

# GOLANGCILINT_ARGS += --verbose

# GOLANGCILINT_VERSION := v1.36.1

## All good below here.
GOLANGCILINT_VERSION ?= v1.45.2

# A literal space.
_golangcilint_space :=
_golangcilint_space +=

# A literal comma.
_golangcilint_comma := ,

GOLANGCILINT := artifacts/bin/$(GOLANGCILINT_VERSION)/golangci-lint
$(GOLANGCILINT):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(MF_PROJECT_ROOT)/$(@D)" $(GOLANGCILINT_VERSION)

artifacts/lint/golangci-lint: SHELL=/bin/bash -o pipefail
artifacts/lint/golangci-lint: $(GOLANGCILINT) $(GENERATED_FILES) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(eval GOLANGCILINT_ARGS += $(if $(GOLANGCILINT_CHECK_DISABLE),--disable '$(subst $(_golangcilint_space),$(_golangcilint_comma),$(GOLANGCILINT_CHECK_DISABLE))',))
	$(GOLANGCILINT) run --sort-results --max-same-issues 0 --max-issues-per-linter 0 $(GOLANGCILINT_ARGS) ./... | tee "$(@)"

lint:: artifacts/lint/golangci-lint

tools:: $(GOLANGCILINT)
