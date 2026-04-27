#!/usr/bin/env bash
# Render a Quarto reveal.js deck to both HTML and PDF.
#
# Usage:  slides/render.sh path/to/deck.qmd
# Output: <deck>.html  +  <deck>.pdf  (next to the .qmd)
#
# Strategy:
#   1. quarto render --to revealjs  → produces the embedded HTML
#   2. headless Chrome on the HTML's ?print-pdf URL → produces paginated PDF
#      (reveal.js's built-in print stylesheet handles slide sizing)

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <file.qmd>" >&2
  exit 1
fi

QMD="$1"
if [[ ! -f "$QMD" ]]; then
  echo "Error: file not found: $QMD" >&2
  exit 1
fi

DIR="$(cd "$(dirname "$QMD")" && pwd)"
BASE="$(basename "$QMD" .qmd)"
HTML="$DIR/$BASE.html"
PDF="$DIR/$BASE.pdf"

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [[ ! -x "$CHROME" ]]; then
  echo "Error: Google Chrome not found at $CHROME" >&2
  exit 1
fi

echo "→ [1/2] quarto render $QMD"
quarto render "$QMD" --to revealjs

echo "→ [2/2] printing PDF via Chrome headless"
"$CHROME" \
  --headless=new \
  --disable-gpu \
  --no-sandbox \
  --hide-scrollbars \
  --virtual-time-budget=15000 \
  --run-all-compositor-stages-before-draw \
  --print-to-pdf="$PDF" \
  --no-pdf-header-footer \
  "file://${HTML}?print-pdf" 2> >(grep -vE '^\[' >&2 || true)

echo ""
echo "✓ HTML : $HTML"
echo "✓ PDF  : $PDF"
ls -lh "$HTML" "$PDF"
