#!/bin/bash
set -euo pipefail

clang treap-conc.c -g3 -fsanitize=address -o treap-conc-kdasan.exe \
  -shared-libsan -Wl,-rpath,/kdalloc-asan/build/lib/linux/

KDALLOC_HEAP_START_ADDRESS=0x640000000000 \
  ./treap-conc-kdasan.exe