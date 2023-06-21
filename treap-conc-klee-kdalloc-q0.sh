#!/bin/bash
set -euo pipefail

clang treap-conc.c -g3 -c -emit-llvm

klee --posix-runtime --libc=uclibc --kdalloc --kdalloc-quarantine=0 \
  treap-conc.bc