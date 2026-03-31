#include "colors.inc"
#include "textures.inc"
#include "metals.inc"

// --- THE CAMERA (Wide Angle for 4K) ---
camera {
  location <0, 2, -5>
  look_at  <0, 1, 0>
  right x*image_width/image_height
}

// --- THE LIGHTING (Pentoo Green Accent) ---
light_source { <10, 10, -10> color White }
light_source { <-5, 2, -2> color rgb<0, 1, 0> shadowless } // The 'Cyber' Glow

// --- THE HOG (Motorcycle Base) ---
union {
  // Front Fork & Frame
  cylinder { <0,0,0>, <0,1.5,1>, 0.1 texture { T_Chrome_3A } }
  // Tires (Matte Rubber)
  torus { 0.8, 0.2 rotate x*90 translate <0,0.8,1.5> texture { Pigment { color Black } } }
  torus { 0.8, 0.2 rotate x*90 translate <0,0.8,-1.5> texture { Pigment { color Black } } }
  
  // THE TUX REAPER (Placeholder for your Mascot)
  sphere { <0, 1.5, 0>, 0.6 
    texture { 
      pigment { color Black } 
      finish { reflection 0.1 phong 0.5 } // Leather armor vibe
    } 
  }
  
  // THE KATANA (Glowing Edge)
  box { <-0.01, 0, 0>, <0.01, 2, 0.1>
    rotate z*45
    translate <0.5, 1.8, 0.2>
    texture { pigment { color White } finish { ambient 1 } } // The Blade
    interior { media { emission <0, 2, 0> } } // The Green Plasma Glow
  }
}
// Add this to your tux_hog.pov
texture {
  T_Chrome_3B
  finish {
    reflection {
      0.6
      metallic
    }
  }
}
// Reflection Map: Uses your uploaded DFW image
sky_sphere {
  pigment {
    image_map {
      jpeg "sources/dallas_night_skyline.jpg"
      map_type 1 // Spherical mapping
      interpolate 2
    }
  }
}
