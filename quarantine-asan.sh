#!/bin/bash
set -euo pipefail

clang quarantine.c -g3 -fsanitize=address -o quarantine-asan.exe

./quarantine-asan.exe