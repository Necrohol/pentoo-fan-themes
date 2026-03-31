#!/bin/bash
# Pentoo Theme Packager v2026
# T-10 Logic: Countdown to "No MP4"

# --- 1. CONFIGURATION ---
T_NAME=$(grep "name =" new_theme.toml | cut -d'"' -f2)
T_VER=$(grep "version =" new_theme.toml | cut -d'"' -f2)
DIST_DIR="dist"

# User-defined Countdown (Set to 0 to auto-strip MP4s)
COUNTDOWN=$(grep "countdown =" tools.toml | cut -d' ' -f3 || echo "10")

echo "📦 Packaging Theme: $T_NAME v$T_VER"
echo "⏳ T-Minus: $COUNTDOWN"

# --- 2. THE T-10 FILTER ---
# If Countdown > 0, we ship the MP4 sources. If 0, we say "No".
if [ "$COUNTDOWN" -gt 0 ]; then
    echo "🚀 Status: YES (Shipping MP4 sources for AI Upscaling/Muxing)."
    EXCLUDE_MP4=""
else
    echo "🛑 Status: NO (Stripping MP4 sources. Shipping Frames Only)."
    EXCLUDE_MP4="--exclude=sources/*.mp4 --exclude=sources/*.mkv"
fi

# --- 3. ARCHIVING ---
mkdir -p "$DIST_DIR"

# Payload follows the pentoo-terminator skeleton
tar -cvJf "${DIST_DIR}/${T_NAME}-${T_VER}.tar.xz" \
    --exclude='*.pyc' \
    --exclude='__pycache__' \
    --exclude='.git*' \
    $EXCLUDE_MP4 \
    "conf" "docs" "sources" "tools" "RESOURCES"

echo "-------------------------------------------------------"
echo "✅ Package created: ${DIST_DIR}/${T_NAME}-${T_VER}.tar.xz"
echo "-------------------------------------------------------"

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
