import toml
import numpy as np
from scipy.spatial import Voronoi
from PIL import Image, ImageDraw, ImageOps

# 1. LOAD CONFIG
config = toml.load("break-glass.toml")
img = Image.open(f"sources/{config['source']['image']}").convert("RGBA")
W, H = img.size

# 2. GENERATE SHARDS (Voronoi Math)
impact_x = W * config['impact']['x_percent']
impact_y = H * config['impact']['y_percent']

# Create points: Denser near the impact for that 'crushed' glass look
pts = np.random.normal([impact_x, impact_y], [W/3, H/3], (config['physics']['shard_count'], 2))
pts = np.clip(pts, [0, 0], [W, H])
vor = Voronoi(pts)

# 3. THE "SUNDER" LOOP
for frame in range(config['source']['output_frames']):
    canvas = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    
    for region_index in vor.point_region:
        vertices = vor.regions[region_index]
        if not vertices or -1 in vertices: continue # Skip infinite regions
        
        polygon = [tuple(vor.vertices[v]) for v in vertices]
        
        # Create a mask for this specific shard
        mask = Image.new("L", (W, H), 0)
        ImageDraw.Draw(mask).polygon(polygon, fill=255)
        
        # Crop the shard from the original DFW image
        shard = Image.composite(img, Image.new("RGBA", (W,H)), mask)
        
        # PHYSICS: Move and Rotate based on frame
        # (Shards fly OUT from impact_x/y and scale UP to simulate 3D)
        dist_x = (pts[region_index][0] - impact_x) * (frame * 0.05)
        dist_y = (pts[region_index][1] - impact_y) * (frame * 0.05)
        
        canvas.paste(shard.offset(int(dist_x), int(dist_y)), (0,0), shard)

    canvas.save(f"RESOURCES/frames/shatter_{frame:03d}.png")
