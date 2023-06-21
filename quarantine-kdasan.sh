#!/bin/bash
set -euo pipefail

clang quarantine.c -g3 -fsanitize=address -o quarantine-kdasan.exe \
  -shared-libsan -Wl,-rpath,/kdalloc-asan/build/lib/linux/

./quarantine-kdasan.exe