#!/bin/bash
set -euo pipefail

clang oob.c -g3 -fsanitize=address -o oob-kdasan.exe \
  -shared-libsan -Wl,-rpath,/kdalloc-asan/build/lib/linux/

KDALLOC_QUARANTINE=-1 \
  ./oob-kdasan.exe