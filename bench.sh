#!/usr/bin/env bash

set -euxo pipefail

export REPO="${REPO:-"https://github.com/sgtest/megarepo.git"}"

export OLD_COMMIT="${OLD_COMMIT:-"0fd77499c2de329354134657bf53f7a8f4f9323b"}"
export NEW_COMMIT="${NEW_COMMIT:-"13af2da7b084bf609edfbc85eeda21200784fdf1"}"

OUTPUT=$(mktemp -d -t sgserver_XXXXXXX)
export OUTPUT
cleanup() {
	rm -rf "$OUTPUT"
}
trap cleanup EXIT

export GIT_DIR="$OUTPUT/.git"

function run_fetch() {
	git -c "protocol.version=2" fetch --depth=1 "$REPO" "$@"
}
export -f run_fetch

function fetch_separate() {
	run_fetch "$NEW_COMMIT"
	run_fetch "$OLD_COMMIT"
}
export -f fetch_separate

function fetch_together() {
	run_fetch "$NEW_COMMIT" "$OLD_COMMIT"
}
export -f fetch_together

function prepare_repo() {
	rm -rf "$GIT_DIR" || true
	git init --bare
}
export -f prepare_repo

hyperfine --shell=bash --prepare "prepare_repo" "fetch_separate" "fetch_together"
