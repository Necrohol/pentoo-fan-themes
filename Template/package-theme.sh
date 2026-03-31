#!/bin/bash
# Pentoo Theme Packager v2026
# Purpose: Bundle assets, configs, and theme-specific tools.

# --- 1. CONFIGURATION ---
# Pulling name and version from your local TOMLs
T_NAME=$(grep "name =" new_theme.toml | cut -d'"' -f2)
T_VER=$(grep "version =" new_theme.toml | cut -d'"' -f2)
DIST_DIR="dist"

# Standard directories to include in the tarball
# conf: .plymouth / .script files
# docs: README / License
# sources/preview: thumb.png
# tools: theme-specific bash/py scripts
# RESOURCES: background.png / frames / branding
PAYLOAD=( "conf" "docs" "sources/preview" "tools" "RESOURCES" )

echo "📦 Packaging Theme: $T_NAME v$T_VER"

# --- 2. CLEANUP & PREP ---
mkdir -p "$DIST_DIR"
# Ensure the 'tools' dir exists even if empty to satisfy the structure
mkdir -p tools 

# --- 3. ARCHIVING ---
# We use --transform to prefix the folder name in the tarball for clean extraction
tar -cvJf "${DIST_DIR}/${T_NAME}-${T_VER}.tar.xz" \
    --exclude='*.pyc' \
    --exclude='__pycache__' \
    --exclude='.git*' \
    "${PAYLOAD[@]}"

echo "-------------------------------------------------------"
echo "✅ Package created: ${DIST_DIR}/${T_NAME}-${T_VER}.tar.xz"
echo "-------------------------------------------------------"

# --- 4. GIT INITIALIZATION PROMPT ---
if [ ! -d ".git" ]; then
    read -p "❓ Would you like to initialize a new Git repo for this theme? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git init
        # Create a standard .gitignore for Pentoo theme devs
        cat <<EOF > .gitignore
*.pyc
__pycache__/
dist/
scripts/pro-engine/
wallpaper.jpg
source.mp4
EOF
        git add .
        git commit -m "Initial commit: Pentoo Theme Skeleton for $T_NAME"
        echo "🚀 Git repository initialized and first commit created."
        echo "💡 Tip: git remote add origin <your_url> && git push -u origin main"
    fi
fi
