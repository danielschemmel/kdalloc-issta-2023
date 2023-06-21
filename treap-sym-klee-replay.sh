#!/bin/bash
set -euo pipefail

# Run KLEE with one of the `treap-sym-klee*.sh` scripts

clang treap-sym.c -g3 -o treap-sym.exe

klee-replay klee-last/test000002.ktest ./treap-sym.exe