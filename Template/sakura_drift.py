import numpy as np
from PIL import Image, ImageOps
import os

# --- CONFIGURATION ---
#BG_IMAGE = "sources/dallas_skyline_4k.jpg" # or feudal_battlefield.png
PETAL_ASSET = "RESOURCES/sakura_petal.png" 
OUTPUT_DIR = "RESOURCES/frames/sakura_rain/"
TOTAL_FRAMES = 60
PETAL_COUNT = 50

# Ensure output directory exists
os.makedirs(OUTPUT_DIR, exist_ok=True)

def calculate_petal_drift(frame, petal_id, wind_strength=0.5):
    # Unique seed per petal so they don't sync up
    seed = petal_id * 1.5 
    
    # Sinusoidal 'Breeze' path + individual sway
    x_offset = np.sin((frame * 0.1) + seed) * (20 * wind_strength)
    
    # Constant descent with slight speed variety
    y_fall = frame * (4 + (petal_id % 3)) 
    
    # Rotation for 'flutter'
    z_rot = frame * (10 + (petal_id % 5))
    
    return x_offset, y_fall, z_rot

def generate_rain():
    bg = Image.open(BG_IMAGE).convert("RGBA")
    petal_src = Image.open(PETAL_ASSET).convert("RGBA")
    W, H = bg.size

    # Random starting positions for petals
    start_pos = [(np.random.randint(0, W), np.random.randint(-H, 0)) for _ in range(PETAL_COUNT)]

    print(f"🌸 Generating {TOTAL_FRAMES} frames of Sakura drift...")

    for f in range(TOTAL_FRAMES):
        # Create a fresh transparent layer for this frame's petals
        canvas = Image.new("RGBA", (W, H), (0, 0, 0, 0))
        
        for i in range(PETAL_COUNT):
            x_off, y_off, rot = calculate_petal_drift(f, i)
            
            # Update position
            curr_x = int((start_pos[i][0] + x_off) % W) # Wrap around screen
            curr_y = int(start_pos[i][1] + y_off)
            
            if curr_y < H: # Only draw if still on screen
                p = petal_src.rotate(rot, expand=True)
                canvas.paste(p, (curr_x, curr_y), p)

        # Composite: Background -> Petals
        final_frame = Image.alpha_composite(bg, canvas)
        final_frame.save(f"{OUTPUT_DIR}frame_{f:03d}.png")

if __name__ == "__main__":
    generate_rain()
