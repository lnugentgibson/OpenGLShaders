#define LMAP(t) float lmap(t v, t d) { return Dot(d, v); }
LMAP(vec2)
LMAP(vec3)
LMAP(vec4)
#define QMAP(tv, tm) float qmap(tv v, tm d) { return Dot(Dot(d, v), v); }
QMAP(vec2, mat2)
QMAP(vec3, mat3)
QMAP(vec4, mat4)
#define QLMAP(tv, tm) float qlmap(tv v, tm dm, tv dv) { return Dot(Dot(dm, v) + dv, v); }
QLMAP(vec2, mat2)
QLMAP(vec3, mat3)
QLMAP(vec4, mat4)
