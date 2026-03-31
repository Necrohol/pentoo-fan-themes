import numpy as np
from scipy.spatial import Voronoi
from PIL import Image, ImageDraw, ImageTransform

def render_frame(frame_num, total_frames=60):
    city = Image.open("sources/dallas_skyline_4k.jpg").convert("RGBA")
    tux = Image.open("RESOURCES/ronin_tux_hog.png").convert("RGBA")
    W, H = city.size

    # 1. SHATTER LOGIC (Voronoi)
    # We only start the shatter after frame 10 for 'tension'
    if frame_num > 10:
        # Move shards away from impact point (x=W*0.22, y=H*0.40)
        # Apply gravity and rotation to each polygon
        pass 

    # 2. THE "PUSH" (Z-Axis Scaling)
    # Tux starts small and 'pushes' through the gap
    scale = 0.1 + (frame_num / total_frames) * 1.2
    tux_w, tux_h = int(W * scale), int(H * scale)
    tux_resized = tux.resize((tux_w, tux_h), Image.Resampling.LANCZOS)
    
    # 3. COMPOSITE
    # Layer 1: The Dallas City (Shattering)
    # Layer 2: Sakura Petals (Procedural)
    # Layer 3: The Pushing Tux (Scaled)
    
    final_frame = Image.alpha_composite(city, tux_resized_centered)
    final_frame.save(f"dist/frame_{frame_num:03d}.png")
