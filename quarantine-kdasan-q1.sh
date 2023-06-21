#!/bin/bash
set -euo pipefail

clang quarantine.c -g3 -fsanitize=address -o quarantine.exe \
  -shared-libsan -Wl,-rpath,/kdalloc-asan/build/lib/linux/

KDALLOC_QUARANTINE=1 \
  ./quarantine.exe