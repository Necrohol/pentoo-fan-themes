#include "colors.inc"
#include "textures.inc"
#include "shapes.inc"

// --- THE TERRAIN (Hilly Japan) ---
height_field {
  png "sources/heightmap_hills.png" // Simple grayscale hills
  smooth
  texture { 
    pigment { color rgb<0.1, 0.2, 0.05> } // Deep mossy green
    finish { diffuse 0.4 }
  }
  scale <100, 10, 100>
  translate <-50, 0, -50>
}

// --- THE ATMOSPHERE ---
fog {
  distance 40
  color rgbe<0.5, 0.5, 0.5, 0.1>
  fog_type 2
  fog_offset 1
  fog_alt 2
}

// --- THE ANCIENT SAKURA (Right Foreground) ---
#include "Template/Povray-tux/sakura_tree.inc"
object { 
  Sakura_Tree 
  scale 2 
  rotate y*45 
  translate <5, 0, -5> // Anchored in the foreground
}
