#!/usr/bin/env bash
set -euo pipefail

# Paths
ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="$ROOT/build"
ZIP="$OUT/vuln-py39-layer.zip"

# Fresh build dir
rm -rf "$OUT"
mkdir -p "$OUT/python"

# 1) Build the image (Dockerfile is in the same folder)
docker build -t badlab-py39 "$ROOT"

# 2) Install locked deps into /opt/build/python inside the container
#    IMPORTANT: override Lambda image entrypoint (expects a handler otherwise)
docker run --rm \
  --entrypoint /bin/bash \
  -v "$ROOT":/opt \
  badlab-py39 -lc "
    python3 -m pip install --upgrade pip &&
    pip install -r /opt/requirements.lock.txt -t /opt/build/python
  "

# 3) Zip the layer
( cd "$OUT" && zip -r "$ZIP" python >/dev/null )

echo "Layer built: $ZIP"
