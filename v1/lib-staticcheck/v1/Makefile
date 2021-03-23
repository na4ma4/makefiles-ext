_GO_GTE_1_14 := $(shell expr `go version | cut -d' ' -f 3 | tr -d 'a-z' | cut -d'.' -f2` \>= 14)
ifeq "$(_GO_GTE_1_14)" "1"
_MODFILEARG := -modfile tools.mod
endif

.DELETE_ON_ERROR:

STATICCHECK := artifacts/bin/staticcheck
$(STATICCHECK):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go get $(_MODFILEARG) honnef.co/go/tools/cmd/staticcheck

artifacts/cover/staticheck/unused-graph.txt: SHELL=/bin/bash -o pipefail
artifacts/cover/staticheck/unused-graph.txt: $(STATICCHECK) $(GENERATED_FILES) $(GO_TEST_REQ) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(STATICCHECK) -debug.unused-graph "$(@)" ./...

artifacts/lint/staticcheck: SHELL=/bin/bash -o pipefail
artifacts/lint/staticcheck: $(STATICCHECK) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(STATICCHECK) -fail "all,-U1001" ./... | tee "$(@)"

lint:: artifacts/lint/staticcheck

tools:: $(STATICCHECK)
