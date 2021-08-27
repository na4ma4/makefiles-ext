# AUTOWIRE_DEPS += autowire/container.go
# AUTOWIRE_DEPS += autowire/service.go
# AUTOWIRE_DEPS += wev/server.go

# AUTOWIRE_GEN += autowire/wire_gen.go

.DELETE_ON_ERROR:

WIRE := artifacts/bin/wire
$(WIRE):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go install github.com/google/wire/cmd/wire@latest

$(AUTOWIRE_GEN): $(AUTOWIRE_DEPS) | $(WIRE)
	$(WIRE) "./$(@D)"
