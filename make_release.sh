#!/usr/bin/env bash
set -euo pipefail

VERSION="v0.1.2"
TITLE="Azerbaijani Stanza models v0.1.2"
PRETRAIN="models/pretrain/az_tuecl.pretrain.pt"
SPLIT_PREFIX="models/pretrain/az_tuecl.pretrain.pt.part"
SPLIT_SIZE="1900m"

if [[ ! -f "$PRETRAIN" ]]; then
  echo "Missing pretrain file: $PRETRAIN" >&2
  exit 1
fi

if [[ ! -f "${SPLIT_PREFIX}00" ]]; then
  echo "Splitting $PRETRAIN into <2GB parts..."
  split -b "$SPLIT_SIZE" -d -a 2 "$PRETRAIN" "$SPLIT_PREFIX"
fi

SPLIT_PARTS=("${SPLIT_PREFIX}"*)

gh release create "$VERSION" \
  models/az/az_tuecl_nocharlm_tokenizer.pt \
  models/az/az_tuecl_nocharlm_tagger.pt \
  models/az/az_tuecl_nocharlm_lemmatizer.pt \
  models/az/az_tuecl_nocharlm_parser.pt \
  "${SPLIT_PARTS[@]}" \
  -t "$TITLE" \
  -n "Azerbaijani Stanza models and pretrain vectors.

Pretrain is split into parts (<2GB each). Reassemble with:
  cat az_tuecl.pretrain.pt.part* > az_tuecl.pretrain.pt"
