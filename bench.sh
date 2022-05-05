#!/usr/bin/env bash 

set -euxo pipefail 

export REPO="${REPO:-"https://github.com/sourcegraph/sourcegraph.git"}"

export OLD_COMMIT="${OLD_COMMIT:-"e858f4337537604bac0dc30915c674d6b1072ac8"}"
export NEW_COMMIT="${NEW_COMMIT:-"cc3010911fb4093c71236a78cd72f7767630e92d"}"

OUTPUT=$(mktemp -d -t sgserver_XXXXXXX)
export OUTPUT
cleanup() {
  rm -rf "$OUTPUT"
}
trap cleanup EXIT

export GIT_DIR="$OUTPUT/.git"

function fetch_separate() {
  git fetch origin "$NEW_COMMIT"
  git fetch origin "$OLD_COMMIT"
}
export -f fetch_separate

function fetch_together() {
  git fetch origin "$NEW_COMMIT" "$OLD_COMMIT"
}
export -f fetch_together

function fetch_separate_depth() {
    git fetch origin --depth=1 "$NEW_COMMIT"
    git fetch origin --depth=1 "$OLD_COMMIT"
}
export -f fetch_separate_depth

function fetch_together_depth() {
    git fetch origin --depth=1 "$NEW_COMMIT" "$OLD_COMMIT"
}
export -f fetch_together_depth


function prepare_repo() {
  rm -rf "$GIT_DIR" || true 
  git init
  git remote add origin "$REPO"
}
export -f prepare_repo

hyperfine --prepare "prepare_repo" "fetch_separate" "fetch_together" "fetch_separate_depth" "fetch_together_depth"