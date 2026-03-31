import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

# --- CONFIGURATION BOX ---
TEXT_HEADER = "PENTOO LINUX"
TEXT_FOOTER = "WWW.PENTOO.CH"

# Colors: https://www.color-hex.com/color-palettes/popular.php
TEXT_COLOR  = "#00FF00"  # Pentoo Green
GLOW_COLOR  = "#004400"  # Deep Green Bleed
BACK_COLOR  = None       # Use None for "clear" (transparent) or "black"

# Effects: "none", "neon", "glow", "outline"
EFFECT_TYPE = "neon" 

# Asset Toggle
MAKE_HEADER = True
MAKE_FOOTER = True

# Paths
FONT_DIR = "./fonts"
FONT_FILE = "Deaths Hallows.ttf" # Or "DroidSansMono.ttf"
# --------------------------

def get_font(size):
    path = os.path.join(FONT_DIR, FONT_FILE)
    if os.path.exists(path):
        return ImageFont.truetype(path, size)
    return ImageFont.load_default()

def create_element(text, size, filename):
    font = get_font(size)
    
    # Calculate dimensions
    dummy = Image.new("RGBA", (1, 1))
    draw = ImageDraw.Draw(dummy)
    bbox = draw.textbbox((0, 0), text, font=font)
    w, h = bbox[2] - bbox[0], bbox[3] - bbox[1]
    
    # Padding for effects (explosions/glows need room to bleed)
    pad = 60 
    img = Image.new("RGBA", (w + pad, h + pad), (0,0,0,0) if not BACK_COLOR else BACK_COLOR)
    canvas = Image.new("RGBA", img.size, (0,0,0,0))
    draw = ImageDraw.Draw(canvas)
    pos = (pad//2, pad//2)

    # --- EFFECT ENGINE ---
    if EFFECT_TYPE == "neon":
        # Layered blurs for high-end neon
        glow = Image.new("RGBA", img.size, (0,0,0,0))
        g_draw = ImageDraw.Draw(glow)
        g_draw.text(pos, text, font=font, fill=GLOW_COLOR)
        glow = glow.filter(ImageFilter.GaussianBlur(radius=7))
        img.alpha_composite(glow)
        
    elif EFFECT_TYPE == "glow":
        # Subtle outer radiance
        glow = Image.new("RGBA", img.size, (0,0,0,0))
        g_draw = ImageDraw.Draw(glow)
        g_draw.text(pos, text, font=font, fill=TEXT_COLOR)
        img.alpha_composite(glow.filter(ImageFilter.GaussianBlur(radius=3)))

    # Draw Main Text on top
    draw.text(pos, text, font=font, fill=TEXT_COLOR)
    img.alpha_composite(canvas)
    
    img.save(filename)
    print(f"-> Generated: {filename} ({EFFECT_TYPE})")

if __name__ == "__main__":
    if MAKE_HEADER:
        create_element(TEXT_HEADER, 80, "header.png")
    if MAKE_FOOTER:
        create_element(TEXT_FOOTER, 35, "footer.png")
