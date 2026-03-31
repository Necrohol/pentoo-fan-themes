#!/bin/bash
# Pentoo Theme Packager v2026 - Master Cleaner

# --- 1. CONFIGURATION ---
T_NAME=$(grep "name =" new_theme.toml | cut -d'"' -f2)
T_VER=$(grep "version =" new_theme.toml | cut -d'"' -f2)
DIST_DIR="dist"

# T-10 Logic: Read from tools.toml
COUNTDOWN=$(grep "countdown =" tools.toml | cut -d' ' -f3 || echo "10")

# --- 2. THE SHIPPING MANIFEST (The "Binary" Release) ---
# conf:    Essential Plymouth configs/scripts
# docs:    README / ebuild skeleton
# tools:   Theme-specific custom scripts (Python, Bash, JS, etc.)
# sources: Previews (.png) and optional MP4
PAYLOAD=( "conf" "docs" "tools" "sources" )

echo "📦 Packaging Theme: $T_NAME v$T_VER"
echo "⏳ T-Minus: $COUNTDOWN"

# --- 3. MP4 & WORKSPACE LOGIC ---
# We NEVER ship RESOURCES/. We only check if we ship the MP4 in /sources.
if [ "$COUNTDOWN" -gt 0 ]; then
    echo "🚀 Status: YES (Shipping MP4 sources for future 8K/12K AI Muxing)."
    EXCLUDE_FILTER=""
else
    echo "🛑 Status: NO (Stripping MP4 sources. Shipping Previews & Tools Only)."
    EXCLUDE_FILTER="--exclude=sources/*.mp4 --exclude=sources/*.mkv"
fi

# --- 4. ARCHIVING ---
mkdir -p "$DIST_DIR"

# Note: RESOURCES/ is intentionally left out of the payload array.
tar -cvJf "${DIST_DIR}/${T_NAME}-${T_VER}.tar.xz" \
    --exclude='*.pyc' \
    --exclude='__pycache__' \
    --exclude='.git*' \
    $EXCLUDE_FILTER \
    "${PAYLOAD[@]}"

echo "-------------------------------------------------------"
echo "✅ Done! Workspace (RESOURCES/) excluded from build."
echo "📦 Final Tarball: ${DIST_DIR}/${T_NAME}-${T_VER}.tar.xz"



# --- 4. GIT SYNC ---
if [ ! -d ".git" ]; then
    read -p "❓ Init Git for $T_NAME? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git init
        cat <<EOF > .gitignore
*.pyc
__pycache__/
dist/
EOF
        git add .
        git commit -m "Initial commit: $T_NAME [T-$COUNTDOWN]"
    fi
fi
