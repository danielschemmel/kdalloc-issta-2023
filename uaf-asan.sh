#!/bin/bash
set -euo pipefail

clang uaf.c -g3 -fsanitize=address -o uaf-asan.exe

./uaf-asan.exe