.DELETE_ON_ERROR:

-include .makefiles/ext/na4ma4/lib/force/v1/Makefile

## Example Variables
# GOLANGCILINT_CHECK_DISABLE += exhaustivestruct
# GOLANGCILINT_CHECK_DISABLE += paralleltest

# GOLANGCILINT_ARGS += --verbose

# GOLANGCILINT_VERSION := v1.36.1

## All good below here.
GOLANGCILINT_VERSION ?= v1.57.1

# A literal space.
_golangcilint_space :=
_golangcilint_space +=

# A literal comma.
_golangcilint_comma := ,

GOLANGCILINT := artifacts/bin/$(GOLANGCILINT_VERSION)/golangci-lint
artifacts/bin/%/golangci-lint:
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(MF_PROJECT_ROOT)/$(@D)" "$(*)"

artifacts/lint/golangci-lint: SHELL=/bin/bash -o pipefail
artifacts/lint/golangci-lint: $(GOLANGCILINT) .golangci.yml $(GENERATED_FILES) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(eval GOLANGCILINT_ARGS += $(if $(GOLANGCILINT_CHECK_DISABLE),--disable '$(subst $(_golangcilint_space),$(_golangcilint_comma),$(GOLANGCILINT_CHECK_DISABLE))',))
	$(GOLANGCILINT) run --sort-results --max-same-issues 0 --max-issues-per-linter 0 $(GOLANGCILINT_ARGS) ./... | tee "$(@)"

lint:: artifacts/lint/golangci-lint

tools:: $(GOLANGCILINT)

# _clean --- Clears the golangci-lint cache. Invoked by the "clean" target from the
# common makefile before the makefiles themselves are removed.
.PHONY: _clean
_clean:: $(GOLANGCILINT)
	$(GOLANGCILINT) cache clean

update-deps:: 
	make FORCE_DEPS=.golangci.yml .golangci.yml

.golangci.yml:
	curl -sSL -o .golangci.yml https://gist.githubusercontent.com/na4ma4/f165f6c9af35cda6b330efdcc07a9e26/raw/.golangci.yml
