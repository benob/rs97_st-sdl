#!/usr/bin/env bash

set -euo pipefail

usage() {
	echo "Usage: build.sh [target]"
	echo "	target: target platform: rg350, lepus, rg99, or retrofw"
}

if [[ $# -ne 1 ]]; then
	echo "Error: target is missing"
	usage
	exit 1
fi

if [[ $1 != rg350 ]] && [[ $1 != lepus ]] && [[ $1 != rg99 ]] && [[ $1 != retrofw ]]; then
	echo "Error: invalid target"
	usage
	exit 1
fi

declare -r TARGET="${1}"

check_buildroot() {
  if [[ -n ${TOOLCHAIN:-} ]] && [[ -d $TOOLCHAIN ]]; then
    return
  elif ! [[ -d $BUILDROOT ]]; then
    echo "Please set the BUILDROOT or TOOLCHAIN environment variable"
    exit 1
  fi
  TOOLCHAIN="${BUILDROOT}/output/host"
}

make_buildroot() {
  if [[ -z ${BUILDROOT:-} ]]; then
    return
  fi
  cd "$BUILDROOT"
  make toolchain sdl BR2_JLEVEL=0
  cd -
}

build() {
  mkdir -p "build-$TARGET"
  cd "build-$TARGET"
  cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DTARGET_PLATFORM="$TARGET" \
    -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN}/usr/share/buildroot/toolchainfile.cmake"
  cmake --build . -j $(getconf _NPROCESSORS_ONLN)
  cd -
}

package_opk() {
  ./package-opk.sh "$TARGET"
}

main() {
  check_buildroot
  set -x
  make_buildroot
  build
  package_opk
}

main
