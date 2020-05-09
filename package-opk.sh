#!/usr/bin/env bash

set -euo pipefail

usage() {
	echo "Usage: package-opk.sh <target> [build dir] [output OPK path]"
	echo "	target: target platform: rg350 or retrofw"
}

if [[ $# -eq 0 ]]; then
	echo "Error: target is missing"
	usage
	exit 1
fi

if [[ $1 != rg350 ]] && [[ $1 != retrofw ]]; then
	echo "Error: invalid target"
	usage
	exit 1
fi

declare -r TARGET="${1}"
declare -r BUILD_DIR="${2:-"build-${TARGET}"}"
declare -r OUT="${3:-"$BUILD_DIR/st-${TARGET}.opk"}"

main() {
  local ext=gcw0
  if [[ $TARGET == retrofw ]]; then
    ext=retrofw
  fi
  set -x
  mksquashfs \
    "opkg/default.$ext.desktop" \
    "opkg/readme.$ext.txt" \
    opkg/st.sh \
    st.png \
    "$BUILD_DIR/st" \
    "$BUILD_DIR/libst-preload.so" \
    "$OUT" \
    -all-root -no-xattrs -noappend -no-exports
}

main
