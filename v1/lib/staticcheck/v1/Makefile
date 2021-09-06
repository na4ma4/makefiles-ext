.DELETE_ON_ERROR:

STATICCHECK := artifacts/bin/staticcheck
$(STATICCHECK):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go install honnef.co/go/tools/cmd/staticcheck@latest

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
