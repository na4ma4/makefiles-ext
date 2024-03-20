.DELETE_ON_ERROR:

TWIRP_PROTOC_VERSION ?= v8.1.3

GENERATED_FILES += $(foreach f,$(PROTO_FILES:.proto=.twirp.go),$(if $(findstring /_,/$f),,$f))

TWIRP_PROTOC_COMMAND := artifacts/bin/$(TWIRP_PROTOC_VERSION)/protoc-gen-twirp
artifacts/bin/%/protoc-gen-twirp:
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go install github.com/twitchtv/twirp/protoc-gen-twirp@$(*)

%.twirp.go: SHELL=/bin/bash -o pipefail
%.twirp.go: %.proto $(PROTOC_COMMAND) $(TWIRP_PROTOC_COMMAND) artifacts/protobuf/bin/protoc-gen-go artifacts/protobuf/args/common artifacts/protobuf/args/go
	PATH="$(dir $(MF_PROJECT_ROOT)/$(TWIRP_PROTOC_COMMAND)):$(MF_PROJECT_ROOT)/artifacts/protobuf/bin:$$PATH" $(PROTOC_COMMAND) \
		--proto_path="$(dir $(PROTOC_COMMAND))../include" \
		--twirp_opt=module=$$(go list -m) \
		--twirp_out=. \
		$$(cat artifacts/protobuf/args/common artifacts/protobuf/args/go) \
		$(MF_PROJECT_ROOT)/$(@D)/*.proto

tools:: $(TWIRP_PROTOC_COMMAND)
