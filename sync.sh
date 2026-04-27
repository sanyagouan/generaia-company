#!/bin/bash
cd "$(dirname "$0")"
git pull origin main
echo "--- Status ---"
git status
