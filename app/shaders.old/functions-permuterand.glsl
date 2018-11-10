#define MOD289(t) t mod289(t x) { return MOD(x, 289.0); }
MOD289(float)
MOD289(vec2)
MOD289(vec3)
MOD289(vec4)
CASTFUNC(mod289, float, float, int)
CASTFUNC(mod289, vec2, vec2, ivec2)
CASTFUNC(mod289, vec3, vec3, ivec3)
CASTFUNC(mod289, vec4, vec4, ivec4)

#define PERMUTE(x) (mod289(((x*34.0)+1.0)*x))
#define PERMUTER(x, o, r) (mod289(((x*34.0)+1.0)*x)/289.0*r+o)
#define PERMUTEFUNC(t) t permute(t x) { return PERMUTE(x); }
#define PERMUTERFUNC(t) t permute(t x, float o, float r) { return PERMUTER(x, o, r); }
#define FSEEDEDPERMUTEFUNC(t1) t1 permute(t1 x, float seed) { x = PERMUTE(x); seed = PERMUTE(seed); t1 xseed = x * seed; return PERMUTE(xseed); }
#define FSEEDEDPERMUTERFUNC(t1) t1 permute(t1 x, float o, float r, float seed) { x = PERMUTE(x); seed = PERMUTE(seed); t1 xseed = x * seed; return PERMUTER(xseed, o, r); }
#define VSEEDEDPERMUTEFUNC(t1) t1 permute(t1 x, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); t1 xseed = mul(x, seed); return PERMUTE(xseed); }
#define VSEEDEDPERMUTERFUNC(t1) t1 permute(t1 x, float o, float r, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); t1 xseed = mul(x, seed); return PERMUTER(xseed, o, r); }
PERMUTEFUNC(float)
PERMUTEFUNC(vec2)
PERMUTEFUNC(vec3)
PERMUTEFUNC(vec4)
PERMUTERFUNC(float)
PERMUTERFUNC(vec2)
PERMUTERFUNC(vec3)
PERMUTERFUNC(vec4)
FSEEDEDPERMUTEFUNC(float)
FSEEDEDPERMUTEFUNC(vec2)
FSEEDEDPERMUTEFUNC(vec3)
FSEEDEDPERMUTEFUNC(vec4)
FSEEDEDPERMUTERFUNC(float)
FSEEDEDPERMUTERFUNC(vec2)
FSEEDEDPERMUTERFUNC(vec3)
FSEEDEDPERMUTERFUNC(vec4)
VSEEDEDPERMUTEFUNC(float)
VSEEDEDPERMUTEFUNC(vec2)
VSEEDEDPERMUTEFUNC(vec3)
VSEEDEDPERMUTEFUNC(vec4)
VSEEDEDPERMUTERFUNC(float)
VSEEDEDPERMUTERFUNC(vec2)
VSEEDEDPERMUTERFUNC(vec3)
VSEEDEDPERMUTERFUNC(vec4)
