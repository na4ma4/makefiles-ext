#!/bin/sh
set -e

# ------------------------------------------------------------------------
# https://github.com/client9/shlib - portable posix shell functions
# Public domain - http://unlicense.org
# https://github.com/client9/shlib/blob/master/LICENSE.md
# but credit (and pull requests) appreciated.
# ------------------------------------------------------------------------

is_command() (
  command -v "$1" >/dev/null
)

echo_stderr() (
  echo "$@" 1>&2
)

_logp=2
log_set_priority() {
  _logp="$1"
}

log_priority() (
  if test -z "$1"; then
    echo "$_logp"
    return
  fi
  [ "$1" -le "$_logp" ]
)

init_colors() {
  RED=''
  BLUE=''
  PURPLE=''
  BOLD=''
  RESET=''
  # check if stdout is a terminal
  if test -t 1 && is_command tput; then
      # see if it supports colors
      ncolors=$(tput colors)
      if test -n "$ncolors" && test $ncolors -ge 8; then
        RED='\033[0;31m'
        BLUE='\033[0;34m'
        PURPLE='\033[0;35m'
        BOLD='\033[1m'
        RESET='\033[0m'
      fi
  fi
}

init_colors

log_tag() (
  case $1 in
    0) echo "${RED}${BOLD}[error]${RESET}" ;;
    1) echo "${RED}[warn]${RESET}" ;;
    2) echo "[info]${RESET}" ;;
    3) echo "${BLUE}[debug]${RESET}" ;;
    4) echo "${PURPLE}[trace]${RESET}" ;;
    *) echo "[$1]" ;;
  esac
)


log_trace_priority=4
log_trace() (
  priority=$log_trace_priority
  log_priority "$priority" || return 0
  echo_stderr "$(log_tag $priority)" "${@}" "${RESET}"
)

log_debug_priority=3
log_debug() (
  priority=$log_debug_priority
  log_priority "$priority" || return 0
  echo_stderr "$(log_tag $priority)" "${@}" "${RESET}"
)

log_info_priority=2
log_info() (
  priority=$log_info_priority
  log_priority "$priority" || return 0
  echo_stderr "$(log_tag $priority)" "${@}" "${RESET}"
)

log_warn_priority=1
log_warn() (
  priority=$log_warn_priority
  log_priority "$priority" || return 0
  echo_stderr "$(log_tag $priority)" "${@}" "${RESET}"
)

log_err_priority=0
log_err() (
  priority=$log_err_priority
  log_priority "$priority" || return 0
  echo_stderr "$(log_tag $priority)" "${@}" "${RESET}"
)

http_download_curl() (
  local_file=$1
  source_url=$2
  header=$3

  log_trace "http_download_curl(local_file=$local_file, source_url=$source_url, header=$header)"

  if [ -z "$header" ]; then
    code=$(curl -w '%{http_code}' -sL -o "$local_file" "$source_url")
  else
    code=$(curl -w '%{http_code}' -sL -H "$header" -o "$local_file" "$source_url")
  fi

  if [ "$code" != "200" ]; then
    log_err "received HTTP status=$code for url='$source_url'"
    return 1
  fi
  return 0
)

http_download_wget() (
  local_file=$1
  source_url=$2
  header=$3

  log_trace "http_download_wget(local_file=$local_file, source_url=$source_url, header=$header)"

  if [ -z "$header" ]; then
    wget -q -O "$local_file" "$source_url"
  else
    wget -q --header "$header" -O "$local_file" "$source_url"
  fi
)

http_download() (
  log_debug "http_download(local_file=$1, url=$2)"
  if [ -s "${1}" ]; then
    log_debug "file exists, skipping"
    return
  fi
  if is_command curl; then
    http_download_curl "$@"
    return
  elif is_command wget; then
    http_download_wget "$@"
    return
  fi
  log_err "http_download unable to find wget or curl"
  return 1
)

http_copy() (
  # tmp=$(mktemp)
  tmp="/tmp/$(echo "${1}" | base64)"
  http_download "${tmp}" "$1" "$2" || return 1
  body=$(cat "$tmp")
  # rm -f "${tmp}"
  echo "$body"
)


# github_release_json [owner] [repo] [version]
#
# outputs release json string
#
github_release_json() (
  owner=$1
  repo=$2
  version=$3
  test -z "$version" && version="latest"
  giturl="https://github.com/${owner}/${repo}/releases/${version}"
  json=$(http_copy "$giturl" "Accept:application/json")

  log_trace "github_release_json(owner=${owner}, repo=${repo}, version=${version}) returned '${json}'"

  test -z "$json" && return 1
  echo "${json}"
)

# extract_value [key-value-pair]
#
# outputs value from a colon delimited key-value pair
#
extract_value() (
  key_value="$1"
  IFS=':' read -r _ value << EOF
${key_value}
EOF
  echo "$value"
)

# extract_json_value [json] [key]
#
# outputs value of the key from the given json string
#
extract_json_value() (
  json="$1"
  key="$2"
  key_value=$(echo "${json}" | grep  -o "\"$key\":[^,]*[,}]" | tr -d '",}')

  extract_value "$key_value"
)

# github_release_tag [release-json]
#
# outputs release tag string
#
github_release_tag() (
  json="$1"
  tag=$(extract_json_value "${json}" "tag_name")
  test -z "$tag" && return 1
  echo "$tag"
)

# get_release_tag [owner] [repo] [tag]
#
# outputs tag string
#
get_release_tag() (
  owner="$1"
  repo="$2"
  tag="$3"

  log_trace "get_release_tag(owner=${owner}, repo=${repo}, tag=${tag})"

  json=$(github_release_json "${owner}" "${repo}" "${tag}")
  real_tag=$(github_release_tag "${json}")
  if test -z "${real_tag}"; then
    return 1
  fi

  log_trace "get_release_tag() returned '${real_tag}'"

  echo "${real_tag}"
)

hash_sha256() (
  TARGET=${1:-/dev/stdin}
  if is_command gsha256sum; then
    hash=$(gsha256sum "$TARGET") || return 1
    echo "$hash" | cut -d ' ' -f 1
  elif is_command sha256sum; then
    hash=$(sha256sum "$TARGET") || return 1
    echo "$hash" | cut -d ' ' -f 1
  elif is_command shasum; then
    hash=$(shasum -a 256 "$TARGET" 2>/dev/null) || return 1
    echo "$hash" | cut -d ' ' -f 1
  elif is_command openssl; then
    hash=$(openssl -dst openssl dgst -sha256 "$TARGET") || return 1
    echo "$hash" | cut -d ' ' -f a
  else
    log_err "hash_sha256 unable to find command to compute sha-256 hash"
    return 1
  fi
)

hash_sha256_verify() (
  TARGET=$1
  checksums=$2
  if [ -z "$checksums" ]; then
    log_err "hash_sha256_verify checksum file not specified in arg2"
    return 1
  fi
  BASENAME=${TARGET##*/}
  want=$(grep "${BASENAME}$" "${checksums}" 2>/dev/null | tr '\t' ' ' | cut -d ' ' -f 1)
  if [ -z "$want" ]; then
    log_err "hash_sha256_verify unable to find checksum for '${TARGET}' in '${checksums}'"
    return 1
  fi
  got=$(hash_sha256 "$TARGET")
  if [ "$want" != "$got" ]; then
    log_err "hash_sha256_verify checksum for '$TARGET' did not verify ${want} vs $got"
    return 1
  fi
)

if test "$DISTRIBUTION" = "pro"; then
	echo "Using Pro distribution..."
	RELEASES_URL="https://github.com/goreleaser/goreleaser-pro/releases"
	FILE_BASENAME="goreleaser-pro"
else
	echo "Using the OSS distribution..."
	RELEASES_URL="https://github.com/goreleaser/goreleaser/releases"
	FILE_BASENAME="goreleaser"
fi

test -z "$VERSION" && VERSION="$(get_release_tag goreleaser goreleaser latest)"

test -z "$VERSION" && {
	echo "Unable to get goreleaser version." >&2
	exit 1
}

GOBIN="${GOBIN:-.}"
test -z "$TMPDIR" && TMPDIR="$(mktemp -d)"
export TAR_FILE="$TMPDIR/${FILE_BASENAME}_$(uname -s)_$(uname -m).tar.gz"

# note: never change the program flags or arguments (this must always be backwards compatible)
while getopts "b:v:dh?x" arg; do
case "$arg" in
    b) GOBIN="$OPTARG" ;;
    v) VERSION="${OPTARG}" ;;
    d)
    if [ "$_logp" = "$log_info_priority" ]; then
        # -d == debug
        log_set_priority $log_debug_priority
    else
        # -dd (or -ddd...) == trace
        log_set_priority $log_trace_priority
    fi
    ;;
    h | \?) usage "$0" ;;
    x) set -x ;;
esac
done
shift $((OPTIND - 1))

(
	cd "$TMPDIR"
	echo "Downloading GoReleaser $VERSION..."
    http_download "${TAR_FILE}" "$RELEASES_URL/download/$VERSION/${FILE_BASENAME}_$(uname -s)_$(uname -m).tar.gz"
    http_download "checksums.txt" "$RELEASES_URL/download/$VERSION/checksums.txt"
    http_download "checksums.txt.sig" "$RELEASES_URL/download/$VERSION/checksums.txt.sig"
	# curl -sfLo "$TAR_FILE" \
	# 	"$RELEASES_URL/download/$VERSION/${FILE_BASENAME}_$(uname -s)_$(uname -m).tar.gz"
	# curl -sfLo "checksums.txt" "$RELEASES_URL/download/$VERSION/checksums.txt"
	# curl -sfLo "checksums.txt.sig" "$RELEASES_URL/download/$VERSION/checksums.txt.sig"
	echo "Verifying checksums..."
    hash_sha256_verify "${TAR_FILE}" checksums.txt
	# sha256sum --ignore-missing --quiet --check checksums.txt
	if command -v cosign >/dev/null 2>&1; then
		echo "Verifying signatures..."
		COSIGN_EXPERIMENTAL=1 cosign verify-blob \
			--signature checksums.txt.sig \
			checksums.txt
	else
		echo "Could not verify signatures, cosign is not installed."
	fi
)

mkdir -p "${GOBIN}"
tar -xf "$TAR_FILE" -C "${GOBIN}" goreleaser
