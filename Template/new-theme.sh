#!/bin/bash
# Step 1: Bootstrap the Project Skeleton

# Create Global Project Dirs
mkdir -p RESOURCES scripts templates fonts

# Create Theme Instance Dirs from TOML
THEME_NAME=$(grep "name =" new_theme.toml | cut -d'"' -f2)
mkdir -p "$THEME_NAME"/{conf,docs,sources/preview,assets/frames}

echo "📡 Fetching Helpers (No reinventing wheels)..."
# Pull the ebuild skeleton
curl -sSL $(grep "ebuild_skel" project.toml | cut -d'"' -f2) -o templates/ebuild.skel
# Pull the video slicer
curl -sSL $(grep "video_slicer" project.toml | cut -d'"' -f2) -o scripts/slice_mp4.py

echo "✅ Skeleton for $THEME_NAME is ready."
