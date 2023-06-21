#!/bin/bash
set -euo pipefail

clang oob.c -g3 -o oob.exe

./oob.exe