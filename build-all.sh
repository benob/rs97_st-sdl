#!/usr/bin/env bash

set -xeuo pipefail

TOOLCHAIN=/opt/gcw0-toolchain ./build.sh rg350
TOOLCHAIN=/opt/lepus-toolchain ./build.sh lepus
TOOLCHAIN=/opt/rs90-toolchain ./build.sh rg99
TOOLCHAIN=/opt/retrofw-toolchain ./build.sh retrofw
