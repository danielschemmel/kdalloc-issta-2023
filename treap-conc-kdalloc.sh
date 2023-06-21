#!/bin/bash
set -euo pipefail

clang treap-conc.c -g3 -o treap-conc.exe

LD_PRELOAD=/klee-build/lib/libKDAlloc.so ./treap-conc.exe