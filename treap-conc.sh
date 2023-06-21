#!/bin/bash
set -euo pipefail

clang treap-conc.c -g3 -o treap-conc.exe

./treap-conc.exe