#include "colors.inc"
#include "textures.inc"
#include "metals.inc"

// --- THE LEATHER TEXTURE (Weathered & Tough) ---
#declare Biker_Leather = texture {
    pigment { color rgb <0.02, 0.02, 0.02> }
    normal { granite 0.4 scale 0.05 } // Gives it that "Grainy" leather look
    finish { 
        specular 0.3 
        roughness 0.1 
        reflection { 0.02 } // Slight oily sheen
    }
}

// --- THE "REAPER" HOG (Mad Max Style) ---
union {
    // Over-extended Front Forks (The Chopper look)
    cylinder { <0,0,0>, <0,1.8,1.2>, 0.12 texture { T_Chrome_4A } }
    
    // Fat Rear Tire (Wasteland ready)
    torus { 0.8, 0.3 rotate x*90 translate <0,0.8,-1.8> 
        texture { pigment { color Black } normal { dents 0.5 scale 0.1 } } 
    }

    // TUX IN THE LEATHER COAT
    union {
        // Body (The Coat)
        sphere { <0, 1.5, 0>, 0.65 texture { Biker_Leather } }
        // The Collar (Popped)
        torus { 0.4, 0.15 rotate x*15 translate <0, 2.1, -0.1> texture { Biker_Leather } }
        
        // The Reaper Scythe (Strapped to his back)
        cylinder { <-0.5, 0.5, 0.5>, <0.5, 2.8, 0.5>, 0.06 texture { T_Chrome_5B } }
        // The Blade (Jagged/Rusted edge)
        prism { linear_sweep cubic_spline 0, 0.1, 5, 
            <0,0>, <0.8, 0.2>, <1.2, 1.0>, <0.5, 0.8>, <0,0> 
            rotate z*-20 translate <0.5, 2.7, 0.5>
            texture { pigment { color rgb<0.4, 0.3, 0.2> } normal { ripples 0.8 } } // Rusted Steel
        }
    }
    
    // The Engine (V-Twin Block)
    box { <-0.3, 0.5, -0.5>, <0.3, 1.2, 0.5> texture { T_Chrome_2B } }
}
