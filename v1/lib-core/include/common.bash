source "$MF_PROJECT_ROOT/.makefiles/lib/core/include/common.bash"

if [ -z "${NA4MA4_MF_ROOT:-}" ]; then
    NA4MA4_MF_ROOT="$MF_PROJECT_ROOT/.makefiles/ext/na4ma4"
fi

if [[ "$(which na4ma4-build-resource 2>/dev/null)" != "$NA4MA4_MF_ROOT/lib/core/bin/na4ma4-build-resource" ]]; then
    PATH="$NA4MA4_MF_ROOT/lib/core/bin:$PATH"
fi
