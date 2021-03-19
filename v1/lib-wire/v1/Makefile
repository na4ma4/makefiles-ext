# AUTOWIRE_DEPS += autowire/container.go
# AUTOWIRE_DEPS += autowire/service.go
# AUTOWIRE_DEPS += wev/server.go

# AUTOWIRE_GEN += autowire/wire_gen.go

_GO_GTE_1_14 := $(shell expr `go version | cut -d' ' -f 3 | tr -d 'a-z' | cut -d'.' -f2` \>= 14)
ifeq "$(_GO_GTE_1_14)" "1"
_MODFILEARG := -modfile tools.mod
endif

WIRE := artifacts/bin/wire
$(WIRE):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go get $(_MODFILEARG) github.com/google/wire/cmd/wire

$(AUTOWIRE_GEN): $(AUTOWIRE_DEPS) | $(WIRE)
	$(WIRE) "./$(@D)"
