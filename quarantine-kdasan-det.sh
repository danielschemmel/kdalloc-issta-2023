#!/bin/bash
set -euo pipefail

clang quarantine.c -g3 -fsanitize=address -o quarantine.exe \
  -shared-libsan -Wl,-rpath,/kdalloc-asan/build/lib/linux/

KDALLOC_HEAP_START_ADDRESS=0x640000000000 \
  ./quarantine.exe