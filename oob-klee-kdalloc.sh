#!/bin/bash
set -euo pipefail

clang oob.c -g3 -c -emit-llvm

klee --posix-runtime --libc=uclibc --kdalloc oob.bc