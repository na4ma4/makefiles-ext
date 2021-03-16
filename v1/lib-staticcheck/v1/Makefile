_GO_GTE_1_14 := $(shell expr `go version | cut -d' ' -f 3 | tr -d 'a-z' | cut -d'.' -f2` \>= 14)
ifeq "$(_GO_GTE_1_14)" "1"
_MODFILEARG := -modfile tools.mod
endif

STATICCHECK := artifacts/bin/staticcheck
$(STATICCHECK):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go get $(_MODFILEARG) honnef.co/go/tools/cmd/staticcheck

artifacts/cover/staticheck/unused-graph.txt: $(STATICCHECK) $(GO_SOURCE_FILES)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(STATICCHECK) -debug.unused-graph "$(@)" ./...

artifacts/lint/staticcheck: $(STATICCHECK)
	$(STATICCHECK) -fail "all,-U1001" ./...

lint:: artifacts/lint/staticcheck
