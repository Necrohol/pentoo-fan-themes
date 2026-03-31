#!/bin/bash
# Step 2: Render Branding and Composite

# 1. Generate Header/Footer PNGs from their respective TOMLs
python3 gen_assets.py --header header.toml --footer footer.toml

# 2. Composite onto the Mat
# Uses offsets defined in the TOMLs (H_Y and F_Y)
convert sources/wallpaper.jpg -resize 1920x1080^ -gravity center -extent 1920x1080 \
    header_rendered.png -gravity north -geometry +0+150 -composite \
    footer_rendered.png -gravity south -geometry +0+100 -composite \
    "$THEME_NAME/RESOURCES/background.png"

echo "🖼️  Branded background baked to $THEME_NAME/RESOURCES/"
