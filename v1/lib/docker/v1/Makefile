## Copied from config written by https://github.com/ezzatron/

# Automatically populate DOCKER_TAGS where possible
ifeq ($(CI_TRIGGER),pr)
# pull requests
SEMVER_DEV_BUILD := pr-$(CI_PR).$(GIT_HEAD_HASH)
DOCKER_TAGS ?= pr-$(CI_PR)
else ifneq ($(GIT_HEAD_SEMVER_IS_STABLE),)
# stable semver tags
DOCKER_TAGS ?= $(GIT_HEAD_SEMVER) $(GIT_HEAD_SEMVER_MAJOR)
else ifneq ($(GIT_HEAD_TAG),)
# other tags
DOCKER_TAGS ?= $(GIT_HEAD_TAG)
else ifneq ($(SEMVER_DEV_BUILD),$(GIT_HEAD_HASH))
# SEMVER_DEV_BUILD has been overridden
DOCKER_TAGS ?= $(SEMVER_DEV_BUILD)
else
# catch-all
DOCKER_TAGS ?= dev
endif

-include .makefiles/pkg/docker/v1/Makefile

.makefiles/%:
	@curl -sfL https://makefiles.dev/v1 | bash /dev/stdin "$@"
