#define SINFRACT(x, s) fract(sin(x * s.x + s.y) * s.z + s.w)
#define SINFRACTFUNC(t) t sinfract(t x, vec4 s) { return SINFRACT(x, s); }
#define SINFRACTRFUNC(t) t sinfract(t x, float o, float r, vec4 s) { return SINFRACT(x, s) * r + o; }
SINFRACTFUNC(float)
SINFRACTFUNC(vec2)
SINFRACTFUNC(vec3)
SINFRACTFUNC(vec4)
SINFRACTRFUNC(float)
SINFRACTRFUNC(vec2)
SINFRACTRFUNC(vec3)
SINFRACTRFUNC(vec4)
