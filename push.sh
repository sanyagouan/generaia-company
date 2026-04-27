#!/bin/bash
cd "$(dirname "$0")"
git add -A
git commit -m "$(date '+%Y-%m-%d %H:%M') — update" 2>/dev/null || exit 0
git push origin main
