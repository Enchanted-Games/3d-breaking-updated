#ifndef EG_3D_BREAKING_CONFIG_INCLUDE
#define EG_3D_BREAKING_CONFIG_INCLUDE

// ----- Config starts here -----

// Total depth in pixels for the breaking effect
#define DEPTH 0.75

// How many parallax layers should be drawn. More = higher quality but less performant
#define PARALLAX_LAYERS 32

// Inner edge colour near the surface
#define EDGE_GRADIENT_TOP vec3(0.35)

// Inner edge bottom near the bottom
#define EDGE_GRADIENT_BOTTOM vec3(0.15)

// Uncomment the line below to set a custom colour for the bottom face. If left commented
//    out, the breaking animation texture is used and multiplied with BOTTOM_MULTIPLIER
// #define BOTTOM_COLOUR vec3(1, 0, 1)
#define BOTTOM_MULTIPLIER 0.5

// ----- Config ends here -----

#endif
