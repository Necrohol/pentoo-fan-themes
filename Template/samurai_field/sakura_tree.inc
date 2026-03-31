#include "colors.inc"
#include "textures.inc"

// --- THE BARK (Aged Wood) ---
#declare Bark_Texture = texture {
    pigment { color rgb<0.15, 0.1, 0.05> }
    normal { bumps 0.5 scale <0.1, 0.5, 0.1> }
    finish { diffuse 0.4 specular 0.1 }
}

// --- THE BLOSSOMS (Soft Pink) ---
#declare Blossom_Texture = texture {
    pigment { color rgbt<1, 0.7, 0.8, 0.2> } // 20% transparent
    finish { ambient 0.3 diffuse 0.6 }
}

// --- THE TREE STRUCTURE ---
#declare Sakura_Tree = union {
    // MAIN TRUNK (Gnarled)
    sphere_sweep {
        cubic_spline
        5,
        <0, 0, 0>, 0.5,
        <0.2, 1, 0>, 0.4,
        <-0.3, 2, 0.2>, 0.3,
        <0.5, 3, -0.1>, 0.2,
        <0, 4, 0>, 0.1
        texture { Bark_Texture }
    }

    // BRANCHES (Simplified for Rendering Speed)
    union {
        cylinder { <0.5, 3, -0.1>, <1.5, 3.5, 1>, 0.1 texture { Bark_Texture } }
        cylinder { <-0.3, 2, 0.2>, <-1.2, 2.8, -0.5>, 0.08 texture { Bark_Texture } }
        
        // BLOSSOM CLUSTERS (The "Pink Clouds")
        sphere { <1.5, 3.6, 1>, 0.8 texture { Blossom_Texture } }
        sphere { <-1.2, 2.9, -0.5>, 0.6 texture { Blossom_Texture } }
        sphere { <0, 4.2, 0>, 1.0 texture { Blossom_Texture } }
    }
}
