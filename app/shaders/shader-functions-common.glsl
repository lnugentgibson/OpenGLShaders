#define PI  3.141592653589793238462643383279
#define PI2 6.283185307179586476925286766559

#define o2 vec2(0.0, 0.0)
#define i2 vec2(1.0, 0.0)
#define j2 vec2(0.0, 1.0)
#define o3 vec3(0.0, 0.0, 0.0)
#define i3 vec3(1.0, 0.0, 0.0)
#define j3 vec3(0.0, 1.0, 0.0)
#define k3 vec3(0.0, 0.0, 1.0)
#define o4 vec4(0.0, 0.0, 0.0, 0.0)
#define i4 vec4(1.0, 0.0, 0.0, 0.0)
#define j4 vec4(0.0, 1.0, 0.0, 0.0)
#define k4 vec4(0.0, 0.0, 1.0, 0.0)
#define l4 vec4(0.0, 0.0, 0.0, 1.0)

#define MaximumRaySteps 10
#define MaximumDistance 100.0
#define MinimumDistance 0.001
#define MaximumRadius 100.0
#define Center o3

#define DOT(t) \
float Dot(t v) { \
    return dot(v, v); \
}
#define DOT2(t) \
float Dot2(t a, t b) { \
    float d = dot(a, b); \
    return d * d; \
}
DOT(vec2)
DOT(vec3)
DOT(vec4)
DOT2(vec2)
DOT2(vec3)
DOT2(vec4)
float Triple(vec3 a, vec3 b, vec3 c) {
    return dot(a, cross(b, c));
}

#define REDE(t) float red_e(t v, float f) {return dot(v, t(f));}
REDE(vec2)
REDE(vec3)
REDE(vec4)
#define SUME(t) float sum_e(t v) {return red_e(v, 1.0);}
SUME(vec2)
SUME(vec3)
SUME(vec4)
float prod_e(vec2 v) {return v.x * v.y;}
float prod_e(vec3 v) {return v.x * v.y * v.z;}
float prod_e(vec4 v) {return v.x * v.y * v.z * v.w;}
#define MOD(a, b) (a - floor(a / b) * b)
#define MODFUNC(t) t Mod(t a, t b) {return MOD(a, b);}
MODFUNC(float)
MODFUNC(vec2)
MODFUNC(vec3)
MODFUNC(vec4)
#define MODFUNC2(t1, t2) t1 Mod(t1 a, t2 b) {return MOD(a, b);}
MODFUNC2(vec2, float)
MODFUNC2(vec3, float)
MODFUNC2(vec4, float)

#define CURVE3(a) (a * a * (3.0 - 2.0 * a))
#define CURVE3FUNC(t) t Mod(t a) {return CURVE3(a);}
CURVE3FUNC(float)
CURVE3FUNC(vec2)
CURVE3FUNC(vec3)
CURVE3FUNC(vec4)
#define CURVE5(a) (a * a * a * (10.0 + a * (6.0 * a - 15.0)))
#define CURVE5FUNC(t) t Mod(t a) {return CURVE5(a);}
CURVE5FUNC(float)
CURVE5FUNC(vec2)
CURVE5FUNC(vec3)
CURVE5FUNC(vec4)

float triangle(vec2 a, vec2 b, vec2 c) {
    vec2 B = b - a, C = c - a;
    return sqrt(Dot(B) * Dot(C) - Dot2(B, C)) / 2.0;
}
float tetrahedron(vec3 a, vec3 b, vec3 c, vec3 d) {
    vec3 B = b - a, C = c - a, D = d - a;
    return abs(triple(B, C, D)) / 6.0;
}
float pentachoron(vec4 a, vec4 b, vec4 c, vec4 d, vec4 e) {
    vec4 B = b - a, C = c - a, D = d - a, E = e - a;
    return (
        B.x * triple(C.yzw, D.yzw, E.yzw) -
        C.x * triple(B.yzw, D.yzw, E.yzw) +
        D.x * triple(B.yzw, C.yzw, E.yzw) -
        E.x * triple(B.yzw, C.yzw, D.yzw)
    ) / 24.0;
}

ivec3 sortD(vec3 v) {
    if(v.x >= v.y && v.x >= v.z && v.y >= v.z)
        return ivec3(1, 2, 3);
    if(v.x >= v.y && v.x >= v.z && v.z >= v.y)
        return ivec3(1, 3, 2);
    if(v.y >= v.z && v.y >= v.x && v.z >= v.x)
        return ivec3(2, 3, 1);
    if(v.y >= v.z && v.y >= v.x && v.x >= v.z)
        return ivec3(2, 1, 3);
    if(v.z >= v.x && v.z >= v.y && v.x >= v.y)
        return ivec3(3, 1, 2);
    if(v.z >= v.x && v.z >= v.y && v.y >= v.x)
        return ivec3(3, 2, 1);
}
ivec4 sortD(vec4 v) {
    float x = v.x, y = v.y, z = v.z, w = v.w;
    if(
        x >= y && x >= z && x >= w &&
        y >= z && y >= w &&
        z >= w
    )
        return ivec4(1, 2, 3, 4);
    if(
        x >= y && x >= z && x >= w &&
        y >= z && y >= w &&
        w >= z
    )
        return ivec4(1, 2, 4, 3);
    if(
        x >= y && x >= z && x >= w &&
        z >= y && z >= w &&
        y >= w
    )
        return ivec4(1, 3, 2, 4);
    if(
        x >= y && x >= z && x >= w &&
        z >= y && z >= w &&
        w >= y
    )
        return ivec4(1, 3, 4, 2);
    if(
        x >= y && x >= z && x >= w &&
        w >= y && w >= z &&
        y >= z
    )
        return ivec4(1, 4, 2, 3);
    if(
        x >= y && x >= z && x >= w &&
        w >= y && w >= z &&
        z >= y
    )
        return ivec4(1, 4, 3, 2);
    if(
        y >= x && y >= z && y >= w &&
        x >= z && x >= w &&
        z >= w
    )
        return ivec4(2, 1, 3, 4);
    if(
        y >= x && y >= z && y >= w &&
        x >= z && x >= w &&
        w >= z
    )
        return ivec4(2, 1, 4, 3);
    if(
        y >= x && y >= z && y >= w &&
        z >= x && z >= w &&
        x >= w
    )
        return ivec4(2, 3, 1, 4);
    if(
        y >= x && y >= z && y >= w &&
        z >= x && z >= w &&
        w >= x
    )
        return ivec4(2, 3, 4, 1);
    if(
        y >= x && y >= z && y >= w &&
        w >= x && w >= z &&
        x >= z
    )
        return ivec4(2, 4, 1, 3);
    if(
        y >= x && y >= z && y >= w &&
        w >= x && w >= z &&
        z >= x
    )
        return ivec4(2, 4, 3, 1);
    if(
        z >= x && z >= y && z >= w &&
        x >= y && x >= w &&
        y >= w
    )
        return ivec4(3, 1, 2, 4);
    if(
        z >= x && z >= y && z >= w &&
        x >= y && x >= w &&
        w >= y
    )
        return ivec4(3, 1, 4, 2);
    if(
        z >= x && z >= y && z >= w &&
        y >= x && y >= w &&
        x >= w
    )
        return ivec4(3, 2, 1, 4);
    if(
        z >= x && z >= y && z >= w &&
        y >= x && y >= w &&
        w >= x
    )
        return ivec4(3, 2, 4, 1);
    if(
        z >= x && z >= y && z >= w &&
        w >= x && w >= y &&
        x >= y
    )
        return ivec4(3, 4, 1, 2);
    if(
        z >= x && z >= y && z >= w &&
        w >= x && w >= y &&
        y >= x
    )
        return ivec4(3, 4, 2, 1);
    if(
        w >= x && w >= y && w >= z &&
        x >= y && x >= z &&
        y >= z
    )
        return ivec4(4, 1, 2, 3);
    if(
        w >= x && w >= y && w >= z &&
        x >= y && x >= z &&
        z >= y
    )
        return ivec4(4, 1, 3, 2);
    if(
        w >= x && w >= y && w >= z &&
        y >= x && y >= z &&
        x >= z
    )
        return ivec4(4, 2, 1, 3);
    if(
        w >= x && w >= y && w >= z &&
        y >= x && y >= z &&
        z >= x
    )
        return ivec4(4, 2, 3, 1);
    if(
        w >= x && w >= y && w >= z &&
        z >= x && z >= y &&
        x >= y
    )
        return ivec4(4, 3, 1, 2);
    if(
        w >= x && w >= y && w >= z &&
        z >= x && z >= y &&
        y >= x
    )
        return ivec4(4, 3, 2, 1);
}

#define MODEXP(x, y) x - floor(x * (1.0 / y)) * y
#define MOD289(t) \
t mod289(t x) {\
    return MODEXP(x, 289.0);\
}
#define PERMUTE(x) (mod289(((x*34.0)+1.0)*x))
#define PERMUTER(x, o, r) (mod289(((x*34.0)+1.0)*x)/289.0*r+o)
#define PERMUTEFUNC(t) \
t permute(t x) {\
    return PERMUTE(x);\
}
#define PERMUTERFUNC(t) \
t permute(t x, float o, float r) {\
    return PERMUTER(x, o, r);\
}
#define INTFUNC(f) \
float f(int x) {\
    return f(float(x));\
}
#define SEEDEDPERMUTEFUNC(t1, t2) \
t1 permute(t1 x, t2 seed){\
    x = PERMUTE(x);\
    seed = PERMUTE(seed);\
    t1 xseed = x * seed;\
    return PERMUTE(xseed);\
}
#define SEEDEDPERMUTERFUNC(t1, t2) \
t1 permute(t1 x, float o, float r, t2 seed){\
    x = PERMUTE(x);\
    seed = PERMUTE(seed);\
    t1 xseed = x * seed;\
    return PERMUTER(xseed, o, r);\
}
MOD289(float)
INTFUNC(mod289)
MOD289(vec2)
MOD289(vec3)
MOD289(vec4)
PERMUTEFUNC(float)
INTFUNC(permute)
PERMUTEFUNC(vec2)
PERMUTEFUNC(vec3)
PERMUTEFUNC(vec4)
PERMUTERFUNC(vec2)
PERMUTERFUNC(vec3)
PERMUTERFUNC(vec4)
SEEDEDPERMUTEFUNC(float, float)
SEEDEDPERMUTEFUNC(vec2, float)
SEEDEDPERMUTEFUNC(vec3, float)
SEEDEDPERMUTEFUNC(vec4, float)
SEEDEDPERMUTERFUNC(float, float)
SEEDEDPERMUTERFUNC(vec2, float)
SEEDEDPERMUTERFUNC(vec3, float)
SEEDEDPERMUTERFUNC(vec4, float)

#define RAND permute
vec2  rand2(float v, float o, float r, vec2 d, vec4 s) {return RAND( d * v, o, r, s);}
vec3  rand3(float v, float o, float r, vec3 d, vec4 s) {return RAND( d * v, o, r, s);}
vec4  rand4(float v, float o, float r, vec4 d, vec4 s) {return RAND( d * v, o, r, s);}

float rand1(vec2  v, float o, float r, vec2 d, float s) {return RAND( dot(d, RAND(v, 0.0, 1.0, s)), o, r, s);}
float rand1(vec3  v, float o, float r, vec3 d, float s) {return RAND( dot(d, RAND(v, 0.0, 1.0, s)), o, r, s);}
float rand1(vec4  v, float o, float r, vec4 d, float s) {return RAND( dot(d, RAND(v, 0.0, 1.0, s)), o, r, s);}

vec2  rand2(vec2  v, float o, float r, mat2 d, float s) {return RAND( d * RAND(v, 0.0, 1.0, s), o, r, s);}
vec3  rand3(vec3  v, float o, float r, mat3 d, float s) {return RAND( d * RAND(v, 0.0, 1.0, s), o, r, s);}
vec4  rand4(vec4  v, float o, float r, mat4 d, float s) {return RAND( d * RAND(v, 0.0, 1.0, s), o, r, s);}

vec2  rand2(vec3  v, float o, float r, mat3 d, vec4 s) {return RAND((d * v).xy, o, r, s);}
vec2  rand2(vec4  v, float o, float r, mat4 d, vec4 s) {return RAND((d * v).xy, o, r, s);}
vec3  rand3(vec4  v, float o, float r, mat4 d, vec4 s) {return RAND((d * v).xyz, o, r, s);}

vec3  rand3(vec2  v, float o, float r, mat3 d, vec4 s) {return RAND( d * vec3(v, 0.0), o, r, s);}
vec4  rand4(vec2  v, float o, float r, mat4 d, vec4 s) {return RAND( d * vec3(v, 0.0, 0.0), o, r, s);}
vec4  rand4(vec3  v, float o, float r, mat4 d, vec4 s) {return RAND( d * vec3(v, 0.0), o, r, s);}

#define ROT(t, n, i, j) \
t n(float a) {\
    float c = cos(a), s = sin(a);\
    t m = t(1.0);\
    m[i][i] = m[j][j] = c;\
    m[i][j] = s;\
    m[j][i] = -s;\
    return m;\
}
ROT(mat2, rot, 0, 1)
ROT(mat3, rotX, 1, 2)
ROT(mat3, rotY, 2, 0)
ROT(mat3, rotZ, 0, 1)
ROT(mat4, rotXY, 2, 3)
ROT(mat4, rotYZ, 3, 0)
ROT(mat4, rotZW, 0, 1)
ROT(mat4, rotWX, 1, 2)
ROT(mat4, rotYW, 2, 0)
ROT(mat4, rotZX, 3, 1)
mat3 euler_zyx(vec3 a) {return rotX(a.x) * rotY(a.y) * rotZ(a.z);}
mat4 rot(vec4 a) {return rotXY(a.x) * rotYZ(a.y) * rotZW(a.z) * rotWX(a.w);}

vec2  randRot2(float v, vec2 d, vec4 s) {return rot(rand1(v, 0.0, PI2, d, s)) * i2;}
vec3  randRot3(float v, vec3 d, vec4 s) {return euler_zyx(rand3(v, 0.0, PI2, d, s)) * i3;}
vec4  randRot4(float v, vec4 d, vec4 s) {return rot(rand4(v, 0.0, PI2, d, s)) * i4;}

vec2  randRot2(vec2  v, vec2 d, float s) {return rot(rand1(v, 0.0, PI2, d, s)) * i2;}
vec3  randRot3(vec3  v, mat3 d, float s) {return euler_zyx(rand3(v, 0.0, PI2, d, s)) * i3;}
vec4  randRot4(vec4  v, mat4 d, float s) {return rot(rand4(v, 0.0, PI2, d, s)) * i4;}

vec2  randRot2(vec3  v, vec3 d, vec4 s) {return rot(rand1(v, 0.0, PI2, d, s)) * i2;}
vec2  randRot2(vec4  v, vec4 d, vec4 s) {return rot(rand1(v, 0.0, PI2, d, s)) * i2;}
vec3  randRot3(vec4  v, mat4 d, vec4 s) {return euler_zyx(rand3(v, 0.0, PI2, d, s)) * i3;}

vec3  randRot3(vec2  v, mat3 d, vec4 s) {return euler_zyx(rand3(v, 0.0, PI2, d, s)) * i3;}
vec4  randRot4(vec2  v, mat4 d, vec4 s) {return rot(rand4(v, 0.0, PI2, d, s)) * i4;}
vec4  randRot4(vec3  v, mat4 d, vec4 s) {return rot(rand4(v, 0.0, PI2, d, s)) * i4;}

float perlinGradient(vec2 p, mat2 d, vec4 s) {
    vec2 r = floor(p);
    vec2 f = CURVE(fract(p)), F = 1.0 - f;
    float o = 0.0;
    for(float i = 0.0; i < 2.0; i++)
    for(float j = 0.0; j < 2.0; j++) {
        vec2 b = vec2(i, j);
        vec2 B = 1.0 - b;
        vec2 R = r + b;
        o += dot(randRot(R, d, s), p - R) * CURVE(prod_e(b * f + B * F));
    }
    return o;
}
float perlinGradient(vec3 p, mat3 d, vec4 s) {
    vec3 r = floor(p);
    vec3 f = CURVE(fract(p)), F = 1.0 - f;
    float o = 0.0;
    for(float i = 0.0; i < 2.0; i++)
    for(float j = 0.0; j < 2.0; j++)
    for(float k = 0.0; k < 2.0; k++) {
        vec3 b = vec3(i, j, k);
        vec3 B = 1.0 - b;
        vec3 R = r + b;
        o += dot(randRot(R, d, s), p - R) * CURVE(prod_e(b * f + B * F));
    }
    return o;
}
float perlinGradient(vec4 p, mat4 d, vec4 s) {
    vec4 r = floor(p);
    vec4 f = CURVE(fract(p)), F = 1.0 - f;
    float o = 0.0;
    for(float i = 0.0; i < 2.0; i++)
    for(float j = 0.0; j < 2.0; j++)
    for(float k = 0.0; k < 2.0; k++)
    for(float l = 0.0; l < 2.0; l++) {
        vec4 b = vec4(i, j, k, l);
        vec4 B = 1.0 - b;
        vec4 R = r + b;
        o += dot(randRot(R, d, s), p - R) * CURVE(prod_e(b * f + B * F));
    }
    return o;
}

float simplexGradient(vec2 p, mat2 d, vec4 s) {
    float skew = (sqrt(3.0) - 1.0) / 2.0, unskew = (1.0 - 1.0 / sqrt(3.0)) / 2.0;
    vec2 P = p + sum_e(p) * skew;
    vec2 L = floor(P);
    vec2 f = fract(P);
    vec2 c1 = L;
    vec2 c2 = c1 + (f.x >= f.y ? i2 : j2);
    vec2 c3 = L + 1.0;
    c1 -= sum_e(c1) * unskew;
    c2 -= sum_e(c2) * unskew;
    c3 -= sum_e(c3) * unskew;
    float A = triangle(c1, c2, c3);
    float w1 = CURVE(triangle(p, c2, c3) / A);
    float w2 = CURVE(triangle(c1, p, c3) / A);
    float w3 = CURVE(triangle(c1, c2, p) / A);
    //#define WEIGHT2
    #ifdef WEIGHT2
    return vec3(w1 + w2 + w3) * 0.5;
    #else
    #define GRADIENT2
    #ifdef GRADIENT2
    float v1 = dot(randRot(c1, d, s), p - c1);
    float v2 = dot(randRot(c2, d, s), p - c2);
    float v3 = dot(randRot(c3, d, s), p - c3);
    return (v1 * w1 + v2 * w2 + v3 * w3) / (w1 + w2 + w3);
    #else
    float v1 = rand(c1, 0.0, 1.0, d[0], s);
    float v2 = rand(c2, 0.0, 1.0, d[0], s);
    float v3 = rand(c3, 0.0, 1.0, d[0], s);
    return vec3(v1 * w1, v2 * w2, v3 * w3);
    return vec3(w1 > w2 && w1 > w3 ? v1 : w2 > w1 && w2 > w3 ? v2 : v3);
    #endif
    #endif
}
float simplexGradient(vec3 p, mat3 d, vec4 s) {
    //p.z = 0.0;
    float skew = 1.0 / 3.0, unskew = 1.0 / 6.0;
    #define SKEW
    #ifdef SKEW
    vec3 P = p + sum_e(p) * skew;
    #else
    vec3 P = p;
    #endif
    vec3 L = floor(P);
    vec3 f = fract(P);
    ivec3 o = sortD(f);
    vec3 c1 = L;
    vec3 c2 = c1 + (o.x == 1 ? i3 : o.x == 2 ? j3 : k3);
    vec3 c3 = c2 + (o.y == 1 ? i3 : o.y == 2 ? j3 : k3);
    vec3 c4 = L + 1.0;
    #ifdef SKEW
    c1 -= sum_e(c1) * unskew;
    c2 -= sum_e(c2) * unskew;
    c3 -= sum_e(c3) * unskew;
    c4 -= sum_e(c4) * unskew;
    #endif
    float V = tetrahedron(c1, c2, c3, c4);
    float w1 = CURVE(tetrahedron(p, c2, c3, c4) / V);
    float w2 = CURVE(tetrahedron(c1, p, c3, c4) / V);
    float w3 = CURVE(tetrahedron(c1, c2, p, c4) / V);
    float w4 = CURVE(tetrahedron(c1, c2, c3, p) / V);
    //#define WEIGHT3
    #ifdef WEIGHT3
    //if(o.x == 1)
    //    return o.y == 2 ? i3 : 1.0 - i3;
    //else if(o.x == 2)
    //    return o.y == 3 ? j3 : 1.0 - j3;
    //else if(o.x == 3)
    //    return o.y == 1 ? k3 : 1.0 - k3;
    return (w1 + w2 + w3 + w4) * 0.5;
    #else
    #define GRADIENT3
    #ifdef GRADIENT3
    vec3 g1 = randRot(c1, d, s);
    vec3 g2 = randRot(c2, d, s);
    vec3 g3 = randRot(c3, d, s);
    vec3 g4 = randRot(c4, d, s);
    vec3 d1 = p - c1;
    vec3 d2 = p - c2;
    vec3 d3 = p - c3;
    vec3 d4 = p - c4;
    float v1 = dot(g1, d1);
    float v2 = dot(g2, d2);
    float v3 = dot(g3, d3);
    float v4 = dot(g4, d4);
    //return (w1 > w2 && w1 > w3 && w1 > w4 ? d1 : w2 > w1 && w2 > w3 && w2 > w4 ? d2 : w3 > w1 && w3 > w2 && w3 > w4 ? d3 : d4) * 0.5 + 0.5;
    //return w1 > w2 && w1 > w3 && w1 > w4 ? g1 : w2 > w1 && w2 > w3 && w2 > w4 ? g2 : w3 > w1 && w3 > w2 && w3 > w4 ? g3 : g4;
    //return vec3(w1 > w2 && w1 > w3 && w1 > w4 ? v1 : w2 > w1 && w2 > w3 && w2 > w4 ? v2 : w3 > w1 && w3 > w2 && w3 > w4 ? v3 : v4);
    //return vec3(w1 > w2 && w1 > w3 && w1 > w4 ? v1 * w1 : w2 > w1 && w2 > w3 && w2 > w4 ? v2 * w2 : w3 > w1 && w3 > w2 && w3 > w4 ? v3 * w3 : v4 * w4);
    return (v1 * w1 + v2 * w2 + v3 * w3 + v4 * w4) / (w1 + w2 + w3 + w4);
    #else
    float v1 = rand(c1, 0.0, 1.0, d[0], s);
    float v2 = rand(c2, 0.0, 1.0, d[0], s);
    float v3 = rand(c3, 0.0, 1.0, d[0], s);
    float v4 = rand(c4, 0.0, 1.0, d[0], s);
    //return vec3(v1 * w1, v2 * w2, v3 * w3);
    return (w1 > w2 && w1 > w3 && w1 > w4 ? v1 : w2 > w1 && w2 > w3 && w2 > w4 ? v2 : w3 > w1 && w3 > w2 && w3 > w4 ? v3 : v4);
    #endif
    #endif
    //return vec3(w2, w3, w4);
}
float simplexGradient(vec4 p, mat4 d, vec4 s) {
    //p.z = 0.0;
    float skew = (sqrt(5.0) - 1.0) / 4.0, unskew = (1.0 - 1.0 / sqrt(5.0)) / 4.0;
    #define SKEW
    #ifdef SKEW
    vec4 P = p + sum_e(p) * skew;
    #else
    vec3 P = p;
    #endif
    vec4 L = floor(P);
    vec4 f = fract(P);
    ivec4 o = sortD(f);
    vec4 c1 = L;
    vec4 c2 = c1 + (o.x == 1 ? i4 : o.x == 2 ? j4 : o.x == 3 ? k4 : l4);
    vec4 c3 = c2 + (o.y == 1 ? i4 : o.y == 2 ? j4 : o.y == 3 ? k4 : l4);
    vec4 c4 = c3 + (o.z == 1 ? i4 : o.z == 2 ? j4 : o.z == 3 ? k4 : l4);
    vec4 c5 = L + 1.0;
    #ifdef SKEW
    c1 -= sum_e(c1) * unskew;
    c2 -= sum_e(c2) * unskew;
    c3 -= sum_e(c3) * unskew;
    c4 -= sum_e(c4) * unskew;
    c5 -= sum_e(c5) * unskew;
    #endif
    float V = pentachoron(c1, c2, c3, c4, c5);
    float w1 = CURVE(pentachoron(p, c2, c3, c4, c5) / V);
    float w2 = CURVE(pentachoron(c1, p, c3, c4, c5) / V);
    float w3 = CURVE(pentachoron(c1, c2, p, c4, c5) / V);
    float w4 = CURVE(pentachoron(c1, c2, c3, p, c5) / V);
    float w5 = CURVE(pentachoron(c1, c2, c3, c4, p) / V);
    //#define WEIGHT3
    #ifdef WEIGHT3
    if(o.x == 1)
        return o.y == 2 ? i3 : 1.0 - i3;
    else if(o.x == 2)
        return o.y == 3 ? j3 : 1.0 - j3;
    else if(o.x == 3)
        return o.y == 1 ? k3 : 1.0 - k3;
    return (w1 + w2 + w3 + w4 + w5) * 0.5;
    #else
    #define GRADIENT3
    #ifdef GRADIENT3
    vec4 g1 = randRot(c1, d, s);
    vec4 g2 = randRot(c2, d, s);
    vec4 g3 = randRot(c3, d, s);
    vec4 g4 = randRot(c4, d, s);
    vec4 g5 = randRot(c5, d, s);
    vec4 d1 = p - c1;
    vec4 d2 = p - c2;
    vec4 d3 = p - c3;
    vec4 d4 = p - c4;
    vec4 d5 = p - c5;
    float v1 = dot(g1, d1);
    float v2 = dot(g2, d2);
    float v3 = dot(g3, d3);
    float v4 = dot(g4, d4);
    float v5 = dot(g4, d5);
    //return (w1 > w2 && w1 > w3 && w1 > w4 ? d1 : w2 > w1 && w2 > w3 && w2 > w4 ? d2 : w3 > w1 && w3 > w2 && w3 > w4 ? d3 : d4) * 0.5 + 0.5;
    //return w1 > w2 && w1 > w3 && w1 > w4 ? g1 : w2 > w1 && w2 > w3 && w2 > w4 ? g2 : w3 > w1 && w3 > w2 && w3 > w4 ? g3 : g4;
    //return vec3(w1 > w2 && w1 > w3 && w1 > w4 ? v1 : w2 > w1 && w2 > w3 && w2 > w4 ? v2 : w3 > w1 && w3 > w2 && w3 > w4 ? v3 : v4);
    //return vec3(w1 > w2 && w1 > w3 && w1 > w4 ? v1 * w1 : w2 > w1 && w2 > w3 && w2 > w4 ? v2 * w2 : w3 > w1 && w3 > w2 && w3 > w4 ? v3 * w3 : v4 * w4);
    return (v1 * w1 + v2 * w2 + v3 * w3 + v4 * w4 + v5 * w5) / (w1 + w2 + w3 + w4 + w5);
    #else
    float v1 = rand(c1, 0.0, 1.0, d[0], s);
    float v2 = rand(c2, 0.0, 1.0, d[0], s);
    float v3 = rand(c3, 0.0, 1.0, d[0], s);
    float v4 = rand(c4, 0.0, 1.0, d[0], s);
    float v5 = rand(c5, 0.0, 1.0, d[0], s);
    //return vec3(v1 * w1, v2 * w2, v3 * w3);
    return (w1 > w2 && w1 > w3 && w1 > w4 ? v1 : w2 > w1 && w2 > w3 && w2 > w4 ? v2 : w3 > w1 && w3 > w2 && w3 > w4 ? v3 : v4);
    #endif
    #endif
    //return vec3(w2, w3, w4);
}

#define NOISE perlinGradient
//#undef  NOISE
//#define NOISE simplexGradient
#define NOISEITERATIONS 7
float fbm(vec2 p, mat2 ss, float as, mat2 d, vec4 s) {
    float o = 0.0, a = 1.0;
    vec4 cs = s;
    for(int i = 0; i < NOISEITERATIONS; i++) {
        o += NOISE(p, d, s) * a;
        p *= ss;
        a *= as;
        cs = (cs, 1234.5678, 5678.9012, s);
    }
    return o;
}
float fbm(vec3 p, mat3 ss, float as, mat3 d, vec4 s) {
    float o = 0.0, a = 1.0;
    vec4 cs = s;
    for(int i = 0; i < NOISEITERATIONS; i++) {
        o += NOISE(p, d, s) * a;
        p *= ss;
        a *= as;
        cs = (cs, 1234.5678, 5678.9012, s);
    }
    return o;
}
float fbm(vec4 p, mat4 ss, float as, mat4 d, vec4 s) {
    float o = 0.0, a = 1.0;
    vec4 cs = s;
    for(int i = 0; i < NOISEITERATIONS; i++) {
        o += NOISE(p, d, s) * a;
        p *= ss;
        a *= as;
        cs = (cs, 1234.5678, 5678.9012, s);
    }
    return o;
}

#define MMETH 1
float evoronoi( in vec2 x, vec4 c, mat2 d, vec4 s ) {
    float fallout = 64.0;
    ivec2 p = ivec2(floor( x ));
    vec2 f = fract( x );

    #if MMETH == 0
    float res = 1.0e20;
    #elif MMETH == 1
    float res = 0.0;
    #elif MMETH == 2
    vec4 res = vec4(1.0e20);
    #endif
    const int range = 1;
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        ivec2 b = ivec2( i, j );
        vec2 rv = rand( vec2(p + b), 0.0, 1.0, d, s );
        //vec2 r = b - f + RAND(p + b, 0.0, 1.0, s);
        vec2 r = vec2(b) - f + rv;
        float dis = length( r );

    	#if MMETH == 0
        res = min(res, dis);
    	#elif MMETH == 1
        res += exp( -fallout*dis );
        #elif MMETH == 2
        Min(res, dis);
        #endif
    }
    #if MMETH == 0
    return res;
    #elif MMETH == 1
    return -(1.0/fallout)*log( res );
    #elif MMETH == 2
    return dot(res, c);
    #endif
}
#define JUSTMIN
float evoronoi( in vec3 x, vec4 c, mat3 d, vec4 s ) {
    float fallout = 64.0;
    ivec3 p = ivec3(floor( x ));
    vec3 f = fract( x );

    #ifdef JUSTMIN
    float res = 1.0e20;
    #else
    vec4 res = vec4(1.0e20);
    #endif
    const int range = 1;
    for( int k=-range; k<=range; k++ )
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        ivec3 b = ivec3( i, j, k );
        vec3 r = vec3(b) - f + rand( vec3(p + b), 0.0, 1.0, d, s );
        float dis = length( r );

        #ifdef JUSTMIN
        res = min(res, dis);
        #else
        Min(res, dis);
        #endif
    }
    #ifdef JUSTMIN
    return res;
    #else
    return dot(res, c);
    #endif
}

struct camera {
    vec3 position;
    vec3 target;
    vec3 up;
    vec2 fieldofvision;
    float scale;
};
camera Camera() {
    return camera(
        o3,
        j3,
        k3,
        vec2(1.0),
        1.0
    );
}
camera Camera(vec3 position) {
    return camera(
        position,
        j3,
        k3,
        vec2(1.0),
        1.0
    );
}
camera Camera(vec3 position, vec3 target) {
    return camera(
        position,
        target,
        k3,
        vec2(1.0),
        1.0
    );
}
mat3 rayCaster(camera c) {
    vec3 z = normalize(c.position - c.target);
    vec3 x = normalize(cross(c.up, z));
    vec3 y = normalize(cross(z, x));
    return c.scale * mat3(
        c.fieldofvision.x,0.0,0.0,
        0.0,c.fieldofvision.y,0.0,
        0.0,0.0,1.0
    ) * mat3(x, y, -z);
}

#define LAMBERT_DIFFUSE   0
#define ORENNAYAR_DIFFUSE 1
#define PHONG_SPECULAR 0
struct material {
    float roughness;
    vec3 ambientalbedo;
    int diffusetype;
    vec3 diffusealbedo;
    int speculartype;
    vec3 specularalbedo;
};

struct distanceestimation {
    vec3 source;
    vec3 surface;
    vec3 direction;
    float difference;
    vec3 normal;
};
void de(inout distanceestimation d) {
    vec2 uv = d.source.xy * 0.125;
    d.surface = vec3(d.source.xy, 0.0);
    d.difference = d.source.z;
    d.normal = k3;
}

struct tracer {
    vec3 source;
    vec3 direction;
    vec3 position;
    vec3 normal;
    float marchlength;
    int iterations;
};
tracer Tracer() {
    return tracer(
        o3,
        j3,
        o3,
        o3,
        0.0,
        0
    );
}
tracer Tracer(vec3 source) {
    return tracer(
        source,
        j3,
        o3,
        o3,
        0.0,
        0
    );
}
tracer Tracer(vec3 source, vec3 direction) {
    return tracer(
        source,
        direction,
        o3,
        o3,
        0.0,
        0
    );
}

vec3 normal(vec3 p) {
    float diff = 0.00001;
    distanceestimation d = distanceestimation(
        vec3(0.0),
        vec3(0.0),
        vec3(0.0),
        0.0,
        vec3(0.0)
    );
    d.source = p - diff * i3; de(d); float nx = d.difference;
    d.source = p + diff * i3; de(d); float px = d.difference;
    d.source = p - diff * j3; de(d); float ny = d.difference;
    d.source = p + diff * j3; de(d); float py = d.difference;
    d.source = p - diff * k3; de(d); float nz = d.difference;
    d.source = p + diff * k3; de(d); float pz = d.difference;
    return normalize(vec3(
        px - nx,
        py - ny,
        pz - nz
    ));
}
void trace(inout tracer t) {
    t.direction = normalize(t.direction);
    t.iterations = 0;
    distanceestimation d = distanceestimation(
        o3,
        o3,
        t.direction,
        0.0,
        o3
    );
	for (int steps = 0; steps < MaximumRaySteps; steps++) {
        if(
            t.iterations == 0
            || abs(d.difference) > MinimumDistance
            && t.marchlength < MaximumDistance
            && length(Center - t.position) < MaximumRadius
        ) {
            t.position = t.source + t.marchlength * t.direction;
            d.source = t.position;
            de(d);
            t.normal = d.normal;
            t.marchlength += d.difference;
            t.iterations++;
        }
	}
    if(length(Center - t.position) > MaximumRadius || t.marchlength > MaximumDistance) {
        t.position = vec3(0.0);
        t.iterations = MaximumRaySteps;
    }
}

struct ambientlight {
    vec3 color;
};
struct standardlight {
    int type;
    vec3 position;
    vec3 color;
    float falloff;
    vec3 direction;
    float spread;
    float taper;
};
    
struct lightpath {
    vec3 normal;
    float ilength;
    vec3 iray;
    vec3 vray;
    vec3 rray;
    vec2 incident;
    vec2 view;
    vec2 reflected;
    vec3 color;
};
lightpath pointlightpath(vec3 p, vec3 d, standardlight l, vec3 n) {
    vec3 i = l.position - p;
    float il = length(i);
    i = normalize(i);
    vec3 v = -d;
    vec3 r = 2.0 * dot(i, n) * n - i;
    vec3 t = normalize(cross(cross(n, i), n));
    vec3 tv = normalize(cross(cross(n, v), n));
    vec3 tr = normalize(cross(cross(n, r), n));
    vec3 color = l.color / pow(il, l.falloff);
    return lightpath(
        n,
        il,
        i,
        v,
        r,
        vec2(dot(n, i), 0.0), // incident
        vec2(dot(n, v), dot(t, tv)), // view
        vec2(dot(n, r), dot(t, tr)), // reflected
        color
    );
}
lightpath conelightpath(vec3 p, vec3 d, standardlight l, vec3 n) {
    vec3 i = l.position - p;
    float il = length(i);
    i = normalize(i);
    vec3 v = -d;
    vec3 r = 2.0 * dot(i, n) * n - i;
    vec3 t = normalize(cross(cross(n, i), n));
    vec3 tv = normalize(cross(cross(n, v), n));
    vec3 tr = normalize(cross(cross(n, r), n));
    vec3 color = l.color / pow(il, l.falloff);
    color *= pow((l.spread - acos(dot(-i, l.direction))) / l.spread, l.taper);
    return lightpath(
        n,
        il,
        i,
        v,
        r,
        vec2(dot(n, i), 0.0), // incident
        vec2(dot(n, v), dot(t, tv)), // view
        vec2(dot(n, r), dot(t, tr)), // reflected
        color
    );
}
lightpath directionlightpath(vec3 p, vec3 d, standardlight l, vec3 n) {
    vec3 i = -l.direction;
    float il = 0.0;
    vec3 v = -d;
    vec3 r = 2.0 * dot(i, n) * n - i;
    vec3 t = normalize(cross(cross(n, i), n));
    vec3 tv = normalize(cross(cross(n, v), n));
    vec3 tr = normalize(cross(cross(n, r), n));
    vec3 color = l.color;
    return lightpath(
        n,
        il,
        i,
        v,
        r,
        vec2(dot(n, i), 0.0), // incident
        vec2(dot(n, v), dot(t, tv)), // view
        vec2(dot(n, r), dot(t, tr)), // reflected
        color
    );
}

vec3 lambert(material m, lightpath lp) {
    return m.diffusealbedo / PI * lp.color * lp.incident.x;
}
vec3 orennayar(material m, lightpath lp) {
    float roughness = tan(0.999 * m.roughness * PI / 2.0);
    float A = 1.0 - 0.5 * m.roughness / (m.roughness + 0.33);
    float B = 0.45 * m.roughness / (m.roughness + 0.09);
    float ca = max(lp.incident.x, lp.view.x);
    float cb = min(lp.incident.x, lp.view.x);
    float sa = sqrt(1.0 - ca * ca);
    float tb = sqrt(1.0 / (cb * cb) - 1.0);
    return m.diffusealbedo / PI * lp.color * lp.incident.x * (A + (B * max(0.0, lp.view.y) * sa * tb));
}
vec3 phong(material m, lightpath lp) {
    float shininess = tan(0.999 * (1.0 - m.roughness) * PI / 2.0);
    return m.specularalbedo / PI * lp.color * lp.incident.x * pow(dot(lp.rray, lp.vray), shininess);
}
vec3 lighting(material m, standardlight l, tracer p) {
    lightpath lp =  pointlightpath(p.position, p.direction, l, p.normal);
    vec3 L = vec3(0.0);
    if(m.diffusetype == LAMBERT_DIFFUSE)
        L = lambert(m, lp);
    else if(m.diffusetype == ORENNAYAR_DIFFUSE)
        L = orennayar(m, lp);
        vec3 S;
    if(m.speculartype == PHONG_SPECULAR)
        L += phong(m, lp);
    return L;
}