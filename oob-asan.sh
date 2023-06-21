#!/bin/bash
set -euo pipefail

clang oob.c -g3 -fsanitize=address -o oob-asan.exe

./oob-asan.exe