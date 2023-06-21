#!/bin/bash
set -euo pipefail

clang treap-conc.c -g3 -c -emit-llvm

klee --posix-runtime --libc=uclibc --kdalloc --kdalloc-quarantine=-1 \
  treap-conc.bc