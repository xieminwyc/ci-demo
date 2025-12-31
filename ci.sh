#!/bin/bash
set -e

echo "== CI START =="

echo "1️⃣ Install dependencies"
npm install

echo "2️⃣ Run build"
npm run build

echo "3️⃣ Check build result"
test -f dist/index.html

echo "== CI SUCCESS =="
