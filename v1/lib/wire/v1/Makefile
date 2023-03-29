# AUTOWIRE_DEPS += autowire/container.go
# AUTOWIRE_DEPS += autowire/service.go
# AUTOWIRE_DEPS += wev/server.go

# AUTOWIRE_GEN += autowire/wire_gen.go

.DELETE_ON_ERROR:

WIRE_VERSION ?= 0.5.0

WIRE := artifacts/bin/$(WIRE_VERSION)/wire
artifacts/bin/%/wire:
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go install github.com/google/wire/cmd/wire@$(*)

$(AUTOWIRE_GEN): $(AUTOWIRE_DEPS) | $(WIRE)
	$(WIRE) "./$(@D)"

tools:: $(WIRE)
