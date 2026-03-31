#!/bin/bash
# Pentoo Universal Muxer: The "Director" Script

# 1. Base Image + Side Panels
# (Runs your procedural-sidepanels.py based on [side_panels] section)

# 2. Check for Custom VFX "Append" Bits
# We use a simple loop to check the TOML for any 'true' scripts
VFX_LIST=$(grep -E "sakura_rain|samurai_slash|glass_shatter" screen.toml | grep "true" | cut -d' ' -f1)

for vfx in $VFX_LIST; do
    echo "🎬 Activating VFX: $vfx"
    # Execute the specific py script from the tools/vfx directory
    python3 "tools/vfx/${vfx//_/-}.py" --input RESOURCES/current_frame.png --out RESOURCES/current_frame.png
done

# 3. Final Branding (Logo/Text)
# (Drops the Lock Logo and Header/Footer text on top of the VFX)
