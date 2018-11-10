#define RAND1(tv, tm) float rand1(tv uv, tm dm, tv dv, vec4 s) { return rand(sin(2.0 * pow(qlmap(uv, dm, dv), 6.0 / 11.0)), s); }
RAND1(vec2, mat2)
RAND1(vec3, mat3)
RAND1(vec4, mat4)
#define RAND2(tv, tm) vec2 rand2(tv uv, tm dm, tv dv, tv delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); return rand(sin(2.0 * pow(vec2(p1, p2), vec2(6.0 / 11.0))), s); }
RAND2(vec2, mat2)
RAND2(vec3, mat3)
RAND2(vec4, mat4)
#define RAND3(tv, tm) vec3 rand3(tv uv, tm dm, tv dv, tv delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); float p3 = qlmap(uv + 2.0 * delta, dm, dv); return rand(sin(2.0 * pow(vec3(p1, p2, p3), vec3(6.0 / 11.0))), s); }
RAND3(vec2, mat2)
RAND3(vec3, mat3)
RAND3(vec4, mat4)
#define RAND4(tv, tm) vec4 rand4(tv uv, tm dm, tv dv, tv delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); float p3 = qlmap(uv + 2.0 * delta, dm, dv); float p4 = qlmap(uv + 3.0 * delta, dm, dv); return rand(sin(2.0 * pow(vec4(p1, p2, p3, p4), vec4(6.0 / 11.0))), s); }
RAND4(vec2, mat2)
RAND4(vec3, mat3)
RAND4(vec4, mat4)
