#!/bin/bash
set -euo pipefail

clang uaf.c -g3 -c -emit-llvm

klee --posix-runtime --libc=uclibc uaf.bc