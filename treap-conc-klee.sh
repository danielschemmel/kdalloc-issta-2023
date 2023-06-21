#!/bin/bash
set -euo pipefail

clang treap-conc.c -g3 -c -emit-llvm

klee --posix-runtime --libc=uclibc treap-conc.bc