_GO_GTE_1_14 := $(shell expr `go version | cut -d' ' -f 3 | tr -d 'a-z' | cut -d'.' -f2` \>= 14)
ifeq "$(_GO_GTE_1_14)" "1"
_MODFILEARG := -modfile tools.mod
endif

MISSPELL := artifacts/bin/misspell
$(MISSPELL):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go get $(_MODFILEARG) github.com/client9/misspell/cmd/misspell

artifacts/lint/misspell: SHELL=/bin/bash -o pipefail
artifacts/lint/misspell: $(MISSPELL) $(GENERATED_FILES) $(GO_TEST_REQ) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(MISSPELL) -w -error -locale UK ./... | tee "$(@)"

lint:: artifacts/lint/misspell

tools:: $(MISSPELL)
