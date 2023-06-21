#!/bin/bash
set -euo pipefail

clang oob.c -g3 -c -emit-llvm

klee --posix-runtime --libc=uclibc --kdalloc --kdalloc-quarantine=0 \
  oob.bc