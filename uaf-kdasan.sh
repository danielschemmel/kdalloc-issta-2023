#!/bin/bash
set -euo pipefail

clang uaf.c -g3 -fsanitize=address -o uaf-kdasan.exe \
  -shared-libsan -Wl,-rpath,/kdalloc-asan/build/lib/linux/

./uaf-kdasan.exe