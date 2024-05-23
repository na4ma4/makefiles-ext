_DEEPCOPY_GEN_FILENAME := zz_generated.deepcopy.go

DEEPCOPY_FILES += $(shell find . -type f -name '*.go' -exec grep -H '+k8s:deepcopy-gen' '{}' \; | sed -e 's/:.*//' | uniq)

DEEPCOPY_GEN_FILES += $(foreach file,$(DEEPCOPY_FILES),$(dir $(file))$(_DEEPCOPY_GEN_FILENAME))

DEEPCOPY_GEN_VERSION ?= latest
DEEPCOPY_GEN := artifacts/bin/$(DEEPCOPY_GEN_VERSION)/deepcopy-gen
$(DEEPCOPY_GEN):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go install k8s.io/code-generator/cmd/deepcopy-gen@$(DEEPCOPY_GEN_VERSION)

.PHONY: info
info::
	$(info DEEPCOPY_FILES: $(DEEPCOPY_FILES))
	$(info DEEPCOPY_GEN_FILES: $(DEEPCOPY_GEN_FILES))

$(DEEPCOPY_GEN_FILES): $(DEEPCOPY_FILES)
	$(DEEPCOPY_GEN) ./... --output-file "$(_DEEPCOPY_GEN_FILENAME)"

.PHONY: deepcopy
deepcopy::
	$(DEEPCOPY_GEN) ./... --output-file "$(_DEEPCOPY_GEN_FILENAME)"
