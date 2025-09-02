#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="$ROOT/build"; ZIP="$OUT/vuln-py39-layer.zip"
rm -rf "$OUT" && mkdir -p "$OUT/python"

docker build -t badlab-py39 "$ROOT" >/dev/null
docker run --rm -v "$ROOT":/opt badlab-py39 bash -lc \
  "python3 -m pip install --upgrade pip && \
   pip install -r /opt/requirements.lock.txt -t /opt/build/python"

( cd "$OUT" && zip -r "$ZIP" python >/dev/null )
echo "Layer built: $ZIP"
