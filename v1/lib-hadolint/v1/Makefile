# List of Hadolint rules to ignore.
HADOLINT_IGNORE ?=

.DELETE_ON_ERROR:

HADOLINT_OS ?= $(shell uname -s)
HADOLINT_ARCH ?= $(shell uname -m)

HADOLINT_VERSION ?= v2.0.0
HADOLINT := artifacts/bin/$(HADOLINT_VERSION)/hadolint
$(HADOLINT):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	curl -sSfL -o "$(@)" https://github.com/hadolint/hadolint/releases/download/$(HADOLINT_VERSION)/hadolint-$(HADOLINT_OS)-$(HADOLINT_ARCH)
	chmod 'a+x' "$(@)"

artifacts/lint/hadolint: SHELL=/bin/bash -o pipefail
artifacts/lint/hadolint: Dockerfile $(HADOLINT)
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	$(HADOLINT) $(addprefix --ignore , $(HADOLINT_IGNORE)) "$(<)" | tee "$(@)"

lint:: artifacts/lint/hadolint

tools:: $(HADOLINT)
