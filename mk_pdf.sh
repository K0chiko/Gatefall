#!/usr/bin/env bash

set -o pipefail
set -eux

rm -r /tmp/pdf || true
mkdir -p /tmp/pdf

for f in *.md
do
    title=$(basename -s .md "$f")
    echo -e "# $title\n" > "/tmp/pdf/$f"
    cat "$f" >> "/tmp/pdf/$f"
done

pandoc --pdf-engine xelatex -V mainfont='DejaVu Serif' -f markdown+emoji /tmp/pdf/*.md -o ~/Downloads/Gatefall.pdf
