#!/bin/bash
set -euo pipefail

# Run KLEE with one of the `treap-conc-klee*.sh` scripts

clang treap-conc.c -g3 -o treap-conc.exe

klee-replay klee-last/test000001.ktest ./treap-conc.exe