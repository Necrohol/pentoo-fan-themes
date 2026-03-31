#!/bin/bash
# Step 2: Bridge local TOMLs to the Pro Engine

THEME_NAME=$(grep "name =" new_theme.toml | cut -d'"' -f2)

echo "🎨 Calling Pro Engine for rendering..."
# Assuming your Pro version in Git has a CLI-friendly entry point
python3 scripts/pro-engine/gen_assets.py \
    --header header.toml \
    --footer footer.toml \
    --output "RESOURCES/"

# Composite onto the final Mat using the Pro-generated PNGs
convert sources/wallpaper.jpg -resize 1920x1080^ -gravity center -extent 1920x1080 \
    RESOURCES/header_rendered.png -gravity north -geometry +0+150 -composite \
    RESOURCES/footer_rendered.png -gravity south -geometry +0+100 -composite \
    "RESOURCES/background.png"

# Generate the preview for GitHub/Docs
convert RESOURCES/background.png -resize 400x300 sources/preview/thumb.png

echo "✅ Branded assets baked into RESOURCES/ for $THEME_NAME"
