from PIL import Image, ImageDraw, ImageFont

def generate_bsod(width, height, error_msg):
    # Standard Windows Blue: #0078D7
    img = Image.new("RGB", (width, height), "#0078D7")
    draw = ImageDraw.Draw(img)
    
    # Render the classic ":(" and the error text
    # (Using a standard sans-serif font from /usr/share/fonts)
    draw.text((100, 100), ":(", fill="white", font=large_font)
    draw.text((100, 300), "Your PC ran into a problem...", fill="white", font=med_font)
    draw.text((100, 500), f"Stop Code: {error_msg}", fill="white", font=small_font)
    
    img.save("RESOURCES/temp/crash_screen.png")

# Run it once at the start of the build
