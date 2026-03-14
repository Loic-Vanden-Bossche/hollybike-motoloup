#!/usr/bin/env bash
set -euo pipefail

IMAGE_REF="${1:?Image ref is required, e.g. ghcr.io/org/name:tag}"
NOTES_FILE="${2:?Notes file path is required}"

if [ ! -f "$NOTES_FILE" ]; then
  echo "Notes file not found: $NOTES_FILE" >&2
  exit 1
fi

# OCI description should be concise and single-line.
description="$(tr '\n' ' ' < "$NOTES_FILE" | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//')"
max_len=900
if [ "${#description}" -gt "$max_len" ]; then
  description="${description:0:$max_len}..."
fi

docker buildx imagetools create \
  --tag "$IMAGE_REF" \
  --annotation "index:org.opencontainers.image.description=$description" \
  "$IMAGE_REF"

