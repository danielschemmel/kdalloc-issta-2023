#!/bin/bash
set -euo pipefail

clang quarantine.c -g3 -o quarantine.exe

./quarantine.exe