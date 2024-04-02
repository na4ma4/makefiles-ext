.DELETE_ON_ERROR:

BUF_VERSION ?= v1.30.0
CONNECT_PROTOC_VERSION ?= v1.16.0
GRPCURL_VERSION ?= v1.8.9

# PROTO_CONNECT_FILES += $(foreach f,$(PROTO_FILES),$(if $(findstring /_,/$f),,$(dir $(f))$(notdir $(patsubst %/,%,$(dir $(f))))connect/$(notdir $(f:.proto=.connect.go))))

GENERATED_FILES += $(PROTO_CONNECT_FILES)

# BUF_COMMAND := artifacts/bin/$(BUF_VERSION)/buf
# artifacts/bin/%/buf:
# 	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
# 	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go install github.com/bufbuild/buf/cmd/buf@$(*)

# GRPCURL_COMMAND := artifacts/bin/$(GRPCURL_VERSION)/grpcurl
# artifacts/bin/%/grpcurl: $(BUF_COMMAND)
# 	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
# 	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go install github.com/fullstorydev/grpcurl/cmd/grpcurl@$(*)

CONNECT_PROTOC_COMMAND := artifacts/bin/$(CONNECT_PROTOC_VERSION)/protoc-gen-connect-go
artifacts/bin/%/protoc-gen-connect-go:
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go install connectrpc.com/connect/cmd/protoc-gen-connect-go@$(*)

define connect_go_target
$1: SHELL=/bin/bash -o pipefail
$1: $2 $(PROTOC_COMMAND) $(CONNECT_PROTOC_COMMAND) artifacts/protobuf/bin/protoc-gen-go artifacts/protobuf/args/common artifacts/protobuf/args/go
	-@mkdir -p "$(MF_PROJECT_ROOT)/$$(@D)"
	PATH="$(dir $(MF_PROJECT_ROOT)/$(CONNECT_PROTOC_COMMAND)):$(MF_PROJECT_ROOT)/artifacts/protobuf/bin:$$$$PATH" $(PROTOC_COMMAND) \
		--proto_path="$(dir $(PROTOC_COMMAND))../include" \
		--connect-go_opt=module=$$$$(go list -m) \
		--connect-go_out=. \
		$$$$(cat artifacts/protobuf/args/common artifacts/protobuf/args/go) \
		$(MF_PROJECT_ROOT)/$$(<D)/*.proto
endef

$(foreach i, $(PROTO_CONNECT_FILES), $(eval $(call connect_go_target,$i,$(dir $(patsubst %/,%,$(dir $i)))$(notdir $(i:.connect.go=.proto)))))

tools:: $(CONNECT_PROTOC_COMMAND) $(GRPCURL_COMMAND) $(BUF_COMMAND)
