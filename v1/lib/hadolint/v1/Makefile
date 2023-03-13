# List of Hadolint rules to ignore.
HADOLINT_IGNORE ?=

.DELETE_ON_ERROR:

HADOLINT_OS ?= $(shell uname -s)
HADOLINT_ARCH ?= $(shell uname -m)

HADOLINT_VERSION ?= v2.12.0
# HADOLINT := artifacts/bin/$(HADOLINT_VERSION)/hadolint
# $(HADOLINT):
# 	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
# 	curl -sSfL -o "$(@)" https://github.com/hadolint/hadolint/releases/download/$(HADOLINT_VERSION)/hadolint-$(HADOLINT_OS)-$(HADOLINT_ARCH)
# 	chmod 'a+x' "$(@)"

HADOLINT_TARGET ?= Dockerfile

artifacts/lint/hadolint/%: SHELL=/bin/bash -o pipefail
artifacts/lint/hadolint/%: % $(HADOLINT)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	docker run --rm -v "$(MF_PROJECT_ROOT):$(MF_PROJECT_ROOT):ro" --workdir "$(MF_PROJECT_ROOT)" hadolint/hadolint:$(HADOLINT_VERSION) hadolint Dockerfile
#	$(HADOLINT) $(addprefix --ignore , $(HADOLINT_IGNORE)) "$(<)" | tee "$(@)"

lint:: $(foreach TARGET,$(HADOLINT_TARGET),artifacts/lint/hadolint/$(TARGET))

tools:: $(HADOLINT)
