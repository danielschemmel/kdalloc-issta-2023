#!/bin/bash
set -euo pipefail

clang uaf.c -g3 -o uaf.exe

./uaf.exe