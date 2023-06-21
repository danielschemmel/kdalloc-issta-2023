#!/bin/bash
set -euo pipefail

clang treap-sym.c -g3 -c -emit-llvm

klee --posix-runtime --libc=uclibc --emit-all-errors --kdalloc --kdalloc-quarantine=0 \
  treap-sym.bc --sym-stdin 2