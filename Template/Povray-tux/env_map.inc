#declare Dallas_Reflections = texture {
    pigment { color rgb<0.1, 0.1, 0.1> }
    finish {
        reflection { 0.8 metallic }
        phong 1
        fresnel on
    }
}
// This makes the chrome 'pop' against the dark blue 4K sky
