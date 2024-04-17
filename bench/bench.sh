#!/usr/bin/env bash

set -ex
set -o pipefail

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "${SCRIPT_PATH}")
REPO_ROOT=$(realpath "${SCRIPT_DIR}/..")

BEFORE_COMMIT='8590a45a'
AFTER_COMMIT='a02f0199'

BENCH_COUNT=10
BENCH_TIME='10s'
# BENCH_TIME='2s'


cd "${REPO_ROOT}"
find . -name '*.log' -delete
git checkout "${BEFORE_COMMIT}"
go test -cpu=4 -run=none -bench=. -benchtime="${BENCH_TIME}" -benchmem -count="${BENCH_COUNT}" | tee "${SCRIPT_DIR}/before.txt"
find . -name '*.log' -delete
git checkout "${AFTER_COMMIT}"
go test -cpu=4 -run=none -bench=. -benchtime="${BENCH_TIME}" -benchmem -count="${BENCH_COUNT}" | tee "${SCRIPT_DIR}/after.txt"
benchstat "${SCRIPT_DIR}/before.txt" "${SCRIPT_DIR}/after.txt" | tee "${SCRIPT_DIR}/compare.txt"
