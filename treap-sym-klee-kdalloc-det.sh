#!/bin/bash
set -euo pipefail

clang treap-sym.c -g3 -c -emit-llvm

klee --posix-runtime --libc=uclibc --emit-all-errors --kdalloc \
  --kdalloc-constants-start-address=0x610000000000 \
  --kdalloc-globals-start-address=0x620000000000   \
  --kdalloc-heap-start-address=0x640000000000      \
  --kdalloc-stack-start-address=0x630000000000     \
  treap-sym.bc --sym-stdin 2