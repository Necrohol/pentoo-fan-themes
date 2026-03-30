#!/usr/bin/env bash
set -euo pipefail

THEME_NAME="${1:-}"
TOOLS_REPO="https://github.com/Necrohol/plymouth_pentoo_1"
RAW_BASE="${TOOLS_REPO}/raw/main"

if [[ -z "${THEME_NAME}" ]]; then
    echo "Usage: $0 <theme-name>"
    exit 1
fi

echo "🛠 Creating new Pentoo theme: ${THEME_NAME}"
mkdir -p "${THEME_NAME}"
cd "${THEME_NAME}"

# --- Layout ---
mkdir -p \
    plymouth/${THEME_NAME} \
    conf \
    docs \
    sources/preview \
    tools \
    reference \
    ebuild

# --- Fetch helper ---
fetch() {
    if command -v curl >/dev/null; then
        curl -fsSL "$1" -o "$2"
    else
        wget -q "$1" -O "$2"
    fi
}

echo "⬇ Pulling core scripts..."

fetch "${RAW_BASE}/install_plymouth_theme.sh" install_plymouth_theme.sh
fetch "${RAW_BASE}/create_release.sh" create_release.sh
fetch "${RAW_BASE}/package_plymouth_theme.py" package_plymouth_theme.py

chmod +x install_plymouth_theme.sh create_release.sh

# --- Plymouth base files ---
cat > plymouth/${THEME_NAME}/${THEME_NAME}.plymouth <<EOF
[Plymouth Theme]
Name=${THEME_NAME}
Description=Pentoo Plymouth Theme (${THEME_NAME})
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/${THEME_NAME}
ScriptFile=${THEME_NAME}.script
EOF

cat > plymouth/${THEME_NAME}/${THEME_NAME}.script <<EOF
// Basic fallback animation loop
for (i = 0; i < 60; i++) {
    image = Image("frame" + i + ".png");
    sprite = Sprite(image);
    sprite.SetPosition(0, 0, 0);
    Plymouth.Sleep(0.03);
}
EOF

# --- Configs ---
cat > conf/plymouthd.conf.example <<EOF
[Daemon]
Theme=${THEME_NAME}
ShowDelay=0
EOF

cat > conf/ugrd.toml.example <<EOF
[plymouth]
enabled = true
theme = "${THEME_NAME}"

include = [
  "/usr/share/plymouth/themes/${THEME_NAME}"
]
EOF

# --- Docs ---
cat > docs/README.md <<EOF
# ${THEME_NAME}

Pentoo Plymouth theme.

## Dev Flow
Edit assets in:
- plymouth/
- sources/
- tools/

## Build
python3 package_plymouth_theme.py

## Install
./install_plymouth_theme.sh ${THEME_NAME}

## Release
./create_release.sh ${THEME_NAME}
EOF

touch docs/LICENSE

# --- Reference Area ---
mkdir -p reference/assets

echo "⬇ Optional reference assets..."

fetch "https://raw.githubusercontent.com/wiki/pentoo/pentoo-overlay/images/pentoo2.png" \
    reference/assets/pentoo_logo.png || true

echo "ℹ You can also pull:"
echo "  https://dev.pentoo.org/~zero/distfiles/pentoo-grubtheme.tar.xz"

# --- Placeholder frame ---
if command -v convert >/dev/null; then
    convert -size 1920x1080 xc:black plymouth/${THEME_NAME}/frame0000.png
else
    echo "⚠ ImageMagick not found, skipping placeholder frame"
fi

# --- Tools placeholder ---
cat > tools/compositor.py <<EOF
#!/usr/bin/env python3
print("Add frame generation logic here")
EOF
chmod +x tools/compositor.py

# --- Git init ---
git init -q || true

echo ""
echo "✅ Done."
echo ""
echo "Next steps:"
echo "  cd ${THEME_NAME}"
echo "  edit assets"
echo "  python3 package_plymouth_theme.py"
echo "  ./install_plymouth_theme.sh ${THEME_NAME}"
