.DELETE_ON_ERROR:

OAPICODEGEN_VERSION ?= latest
OAPICODEGEN := artifacts/bin/$(OAPICODEGEN_VERSION)/oapi-codegen
$(OAPICODEGEN):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@$(OAPICODEGEN_VERSION)

%.oapi.go: %.oapi.yaml
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(OAPICODEGEN) --package=$(basename $(@D)) --generate types,client -o="$(@)" "$(<)"

# OAPICODEGEN_SOURCES ?= $(shell find . -type f -name '*.oapi.yaml')
# OAPICODEGEN_TARGETS ?= $(foreach)

# .PHONY: openapi-gen
# openapi-gen: $(OAPICODEGEN_SOURCES)

tools:: $(OAPICODEGEN)
