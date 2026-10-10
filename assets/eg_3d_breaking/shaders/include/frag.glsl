#if defined(EG_3D_BREAKING_VARYING_LOCATION_0)
layout(location = EG_3D_BREAKING_VARYING_LOCATION_0) in vec3 pos;
#else
in vec3 pos;
#endif

#if defined(EG_3D_BREAKING_VARYING_LOCATION_1)
layout(location = EG_3D_BREAKING_VARYING_LOCATION_1) in vec4 posNear;
#else
in vec4 posNear;
#endif

bool eg3dBreaking_shouldDiscard(vec4 colour) {
    // discard pixels lighter than 0.5 grayscale so the bright bits of the texture dont get rendered
    float grayscale = (colour.r + colour.g + colour.b) / 3.0;
    return colour.a < 0.1 || grayscale > 0.5;
}

mat3 eg3dBreaking_tbnMat(vec3 normal, vec3 pos, vec2 uv) {
    // based on http://www.thetenthplanet.de/archives/1180
    vec3 dp1 = dFdx(pos);
    vec3 dp2 = dFdy(pos);
    vec2 duv1 = dFdx(texCoord0);
    vec2 duv2 = dFdy(texCoord0);
    vec3 dp2perp = cross(dp2, normal);
    vec3 dp1perp = cross(normal, dp1);
    vec3 T = dp2perp * duv1.x + dp1perp * duv2.x;
    vec3 B = dp2perp * duv1.y + dp1perp * duv2.y;
    float invmax = inversesqrt(max(dot(T,T), dot(B,B)));
    return mat3(T * invmax, B * invmax, normal);
}

vec4 eg3dBreaking_drawParallaxBreaking(
    sampler2D Sampler0,
    vec2 texCoord0,
    vec4 vertexColor
) {
    vec4 rawTexture = texture(Sampler0, texCoord0) * vertexColor;
    if (eg3dBreaking_shouldDiscard(rawTexture)) {
        discard;
    }

    // ray stuff
    vec2 texSize = textureSize(Sampler0, 0);
    
    vec3 normal = normalize(cross(dFdx(pos), dFdy(pos)));
    mat3 TBN = transpose(eg3dBreaking_tbnMat(normal, pos, texCoord0));

    vec3 cam = (posNear.xyz) / posNear.w;
    vec3 viewDirection = (TBN * pos.xyz) - (TBN * cam);

    vec2 offs = viewDirection.xy / -viewDirection.z / texSize.x * DEPTH;

    vec4 colour = texture(Sampler0, texCoord0 + offs);
    vec4 rayColour;

    // parallax
    float i;
    for (i = 1; i <= PARALLAX_LAYERS; i++) {
        // edges of the cracking texture
        rayColour = texture(Sampler0, texCoord0 + offs / float(PARALLAX_LAYERS) * i);

        if (eg3dBreaking_shouldDiscard(rayColour)) {
            float depth = 1 - (i / float(PARALLAX_LAYERS));
            colour = vec4(mix(EDGE_GRADIENT_BOTTOM, EDGE_GRADIENT_TOP, depth), 1);
            break;
        }
    }
    
    // 'bottom' of the cracking texture
    if (i > PARALLAX_LAYERS) {
        #ifdef BOTTOM_COLOUR
            colour.rgb = BOTTOM_COLOUR;
        #else
            colour *= BOTTOM_MULTIPLIER;
        #endif
    }

    return colour;
}
