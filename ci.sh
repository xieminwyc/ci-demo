#!/bin/bash
set -e
echo "== CI START =="

echo "1️⃣ Install dependencies"
npm install

echo "2️⃣ Run linting"
# npm run lint

echo "3️⃣ Run tests"
npm test

echo "4️⃣ Run build"
npm run build

echo "5️⃣ Check build result"
test -f dist/index.html

echo "== CI SUCCESS ==="
