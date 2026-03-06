#!/bin/bash
set -e

APP_NAME=${APP_NAME:-"CanvEx.App"}
SAFE_NAME=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

echo ">>> CanvEX: Building '$APP_NAME'..."

# Copy scaffold to working directory
cp -r /canvex/scaffold/. /build/app
cd /build/app
mkdir -p src

# Inject App.jsx
cp /input/App.jsx src/App.jsx

# Replace placeholders with app name
sed -i "s/canvex-test/$SAFE_NAME/g" package.json
sed -i "s/canvex-test/$APP_NAME/g" index.html

# Also replace productName separately to keep it human-readable
sed -i "s/\"productName\": \"$SAFE_NAME\"/\"productName\": \"$APP_NAME\"/" package.json

########################
echo ">>> Copying cached node_modules..."
cp -r /canvex/scaffold/node_modules /build/app/node_modules

#########################

# Install dependencies
echo ">>> Installing dependencies..."
npm install

########################
# Detect and install any missing deps from App.jsx imports
echo ">>> Detecting dependencies from App.jsx..."
npm run detect-deps
#########################

# Init tailwind config
npx tailwindcss init -p

# Build React app
echo ">>> Building React app..."
npm run build

# Package to exe
echo ">>> Packaging to .exe..."
npm run dist


# Copy entire release/dist output to /output
if [ -d "/build/app/release" ]; then
  cp -r /build/app/release/. /output/
elif [ -d "/build/app/dist" ]; then
  cp -r /build/app/dist/. /output/
else
  echo ">>> ERROR: No release or dist folder found."
  exit 1
fi

echo ">>> Done! Output is in your output folder."