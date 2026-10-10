#if defined(EG_3D_BREAKING_VARYING_LOCATION_0)
layout(location = EG_3D_BREAKING_VARYING_LOCATION_0) out vec3 pos;
#else
out vec3 pos;
#endif

#if defined(EG_3D_BREAKING_VARYING_LOCATION_1)
layout(location = EG_3D_BREAKING_VARYING_LOCATION_1) out vec4 posNear;
#else
out vec4 posNear;
#endif

void eg3dBreaking_setVaryings(vec3 Position, mat4 ProjMat, mat4 ModelViewMat, vec4 glPos) {
    pos = Position;
    posNear = inverse(ProjMat * ModelViewMat) * vec4(glPos.xy, -glPos.w, glPos.w);
}
