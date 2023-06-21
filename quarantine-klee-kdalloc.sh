#!/bin/bash
set -euo pipefail

clang quarantine.c -g3 -c -emit-llvm

klee --posix-runtime --libc=uclibc --kdalloc quarantine.bc