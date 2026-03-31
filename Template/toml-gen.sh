#!/bin/bash
# Pentoo Multi-Asset Orchestrator

# Dependency Check
command -v python3 >/dev/null 2>&1 || exit 1

# Helper to grab TOML values from specific files
get_val() { grep "$2 =" "$1" | cut -d'"' -f2; }

# --- 1. EXTRACT DATA ---
H_TEXT=$(get_val "header.toml" "text")
H_SIZE=$(get_val "header.toml" "size")
H_Y=$(get_val "header.toml" "y_offset")

F_P_TEXT=$(get_val "footer.toml" "primary_text")
F_S_TEXT=$(get_val "footer.toml" "secondary_text")
F_SIZE=$(get_val "footer.toml" "size")
F_Y=$(get_val "footer.toml" "y_offset")
F_SPACE=$(get_val "footer.toml" "spacing")

# --- 2. PYTHON ASSET GENERATOR ---
python3 - <<EOF
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os

def render_text(text, size, out_name, is_footer=False):
    f_path = "fonts/brand_font.ttf"
    font = ImageFont.truetype(f_path, int(size)) if os.path.exists(f_path) else ImageFont.load_default()
    
    # Large transparent canvas
    img = Image.new("RGBA", (2000, 600), (0,0,0,0))
    draw = ImageDraw.Draw(img)
    
    # Handle multi-line for footer
    full_text = text if not is_footer else f"{text[0]}\n{text[1]}"
    
    # Draw Glow
    glow = Image.new("RGBA", img.size, (0,0,0,0))
    ImageDraw.Draw(glow).text((1000, 300), full_text, font=font, fill="#004400", anchor="mm", align="center")
    img.alpha_composite(glow.filter(ImageFilter.GaussianBlur(12)))
    
    # Draw Sharp Text
    draw.text((1000, 300), full_text, font=font, fill="#00FF00", anchor="mm", align="center")
    
    # Crop to content and save
    img.crop(img.getbbox()).save(out_name)

# Render Header
render_text("$H_TEXT", "$H_SIZE", "header_rendered.png")

# Render Footer (Combining primary and secondary)
render_text(["$F_P_TEXT", "$F_S_TEXT"], "$F_SIZE", "footer_rendered.png", is_footer=True)
EOF

# --- 3. FINAL COMPOSITE ---
echo "🖼️  Baking Theme Components..."
convert wallpaper.jpg -resize 1920x1080^ -gravity center -extent 1920x1080 \
    header_rendered.png -gravity north -geometry "+0+$H_Y" -composite \
    footer_rendered.png -gravity south -geometry "+0+$F_Y" -composite \
    RESOURCES/background.png

echo "✅ Generated: RESOURCES/background.png"
