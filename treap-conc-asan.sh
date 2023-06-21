#!/bin/bash
set -euo pipefail

clang treap-conc.c -g3 -fsanitize=address -o treap-conc-asan.exe

./treap-conc-asan.exe