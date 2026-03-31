#include "colors.inc"
#include "textures.inc"
#include "metals.inc"

// --- THE PENGUIN BASE (Hardened Tux) ---
union {
  // Body (Hardened Poly)
  sphere { <0, 1.5, 0>, 0.6 texture { pigment { color Black } finish { phong 0.2 } } }
  // Head
  sphere { <0, 2.2, 0>, 0.4 texture { pigment { color Black } } }
  // Beak (Yellow/Orange)
  cone { <0, 2.2, 0.3>, 0.1, <0, 2.15, 0.6>, 0 texture { pigment { color rgb<1, 0.8, 0> } } }

  // --- SAMURAI ARMOR (Do) ---
  // Matte Black 'Laced' Plates
  torus { 0.5, 0.1 translate <0, 1.4, 0> texture { pigment { color rgb<0.05, 0.05, 0.05> } } }
  torus { 0.4, 0.1 translate <0, 1.6, 0> texture { pigment { color rgb<0.05, 0.05, 0.05> } } }
  
  // Shoulder Pauldrons (Sode)
  box { <-0.7, 1.7, -0.3>, <0.7, 2.0, 0.3> 
    texture { pigment { color Black } finish { phong 0.9 } }
    rotate y*20 // Dynamic angle
  }

  // --- THE "REAPER" SCYTHE-KATANA (The Hybrid) ---
  union {
    // The Staff (Weathered Wood)
    cylinder { <0, 0, 0>, <0, 3, 0>, 0.05 texture { T_Wood_1A scale 0.1 } }
    
    // THE BLADE: Katana curve, Scythe angle
    box { <-0.01, 3, 0>, <0.8, 3.1, 0.05> 
      texture { 
        pigment { color White } 
        finish { 
          ambient 1.5           // The Glowing hamon
          reflection { 0.8 metallic } // 
        }
      }
      interior { media { emission <0, 1.5, 0> } } // Pentoo Green Glow
    }
    
    rotate x*-30 // Hold it at a threatening angle
    translate <0.5, 1.5, -0.3>
  }
}
