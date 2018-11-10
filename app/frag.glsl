precision mediump float;

uniform vec2 u_resolution;
uniform float u_scale;
uniform float u_granularity;
uniform float u_time;
uniform float u_time_scale;
uniform int u_samples;

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

#define CASTFUNC(f, t1, t2) t1 f(t2 x) { return f(t1(x)); }

#define DOT(tm, tv) float Dot(tv a, tv b) { return dot(a, b); } float Dot(tv v) { return dot(v, v); } tv Dot(tm a, tv b) { return a * b; } tv Dot(tv b, tm a) { return a * b; }
DOT(mat2, vec2)
DOT(mat3, vec3)
DOT(mat4, vec4)
#define DOT2(t) float Dot2(t a, t b) { float d = dot(a, b); return d * d; }
DOT2(vec2)
DOT2(vec3)
DOT2(vec4)
float Triple(vec3 a, vec3 b, vec3 c) {
    return dot(a, cross(b, c));
}

#define REDE(t) float red_e(t v, float f) {return Dot(v, t(f));}
REDE(vec2)
REDE(vec3)
REDE(vec4)
#define SUME(t) float sum_e(t v) {return red_e(v, 1.0);}
SUME(vec2)
SUME(vec3)
SUME(vec4)
CASTFUNC(red_e, vec2, ivec2)
CASTFUNC(red_e, vec3, ivec3)
CASTFUNC(red_e, vec4, ivec4)
float prod_e(vec2 v) {return v.x * v.y;}
float prod_e(vec3 v) {return v.x * v.y * v.z;}
float prod_e(vec4 v) {return v.x * v.y * v.z * v.w;}

#define MOD(a, b) (a - floor(a / b) * b)
#define MODFUNC(t1, t2) t Mod(t1 a, t2 b) {return MOD(a, b);}
MODFUNC(float, float)
MODFUNC(vec2, float)
MODFUNC(vec2, vec2)
MODFUNC(vec3, float)
MODFUNC(vec3, vec3)
MODFUNC(vec4, float)
MODFUNC(vec4, vec4)

#define MOD289(t) t mod289(t x) { return MOD(x, 289.0); }
MOD289(float)
MOD289(vec2)
MOD289(vec3)
MOD289(vec4)
CASTFUNC(mod289, float, int)
CASTFUNC(mod289, vec2, ivec2)
CASTFUNC(mod289, vec3, ivec3)
CASTFUNC(mod289, vec4, ivec4)

#define CURVE1(a) (a)
#define CURVE3(a) (a < 0.0 ? 0.0 : (a > 1.0 ? 1.0 : (a * a * (3.0 - 2.0 * a))))
#define CURVE3FUNC(t) t curve3(t a) {return CURVE3(a);}
CURVE3FUNC(float)
CURVE3FUNC(vec2)
CURVE3FUNC(vec3)
CURVE3FUNC(vec4)
#define CURVE5(a) (a < 0.0 ? 0.0 : (a > 1.0 ? 1.0 : (a * a * a * (10.0 + a * (6.0 * a - 15.0)))))
#define CURVE5FUNC(t) t curve5(t a) {return CURVE5(a);}
CURVE5FUNC(float)
CURVE5FUNC(vec2)
CURVE5FUNC(vec3)
CURVE5FUNC(vec4)

#define CURVE CURVE3

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

#define MUL(t) t mul(t a, t b) { return a * b; }
MUL(float)
MUL(vec2)
MUL(vec3)
MUL(vec4)
#define MULTF(t) t mul(t a, float b) { return a * b; }
MULTF(vec2)
MULTF(vec3)
MULTF(vec4)
#define MULF(t) float mul(float a, t b) { return a * b.x; }
MULF(vec2)
MULF(vec3)
MULF(vec4)
#define MUL2(t) vec2 mul(vec2 a, t b) { return a * b.xy; }
MUL2(vec3)
MUL2(vec4)
vec3 mul(vec3 a, vec4 b) { return a * b.xyz; }
vec3 mul(vec3 a, vec2 b) { return a * vec3(b, 1.0); }
vec3 mul(vec4 a, vec2 b) { return a * vec4(b, b); }
vec3 mul(vec4 a, vec3 b) { return a * vec4(b, 1.0); }

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

#define SINFRACT(x, s) fract(sin(f * s.x + s.y) * s.z + s.w)
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

#define rand sinfract

#define LMAP(t) float lmap(t v, t d) { return Dot(d, v); }
LMAP(vec2)
LMAP(vec3)
LMAP(vec4)
#define QMAP(tv, tm) float qmap(tv v, tm d) { return Dot(Dot(d, v), v); }
QMAP(vec2, mat2)
QMAP(vec3, mat3)
QMAP(vec4, mat4)
#define QLMAP(tv, tm) float qlmap(tv v, tm dm, tv dv) { return Dot(Dot(d, v) + dv, v); }
QLMAP(vec2, mat2)
QLMAP(vec3, mat3)
QLMAP(vec4, mat4)
#define RAND1(tv, tm) float rand1(tv uv, tm dm, tv dv, vec4 s) { return rand(sin(2.0 * pow(qlmap(uv, dm, dv), 6.0 / 11.0)), s); }
RAND1(vec2, mat2)
RAND1(vec3, mat3)
RAND1(vec4, mat4)
#define RAND2(tv, tm) float rand2(tv uv, tm dm, tv dv, tv delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); return rand(sin(2.0 * pow(vec2(p1, p2), vec2(6.0 / 11.0))), s); }
RAND2(vec2, mat2)
RAND2(vec3, mat3)
RAND2(vec4, mat4)
#define RAND3(tv, tm) float rand3(tv uv, tm dm, tv dv, tv delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); float p3 = qlmap(uv + 2.0 * delta, dm, dv); return rand(sin(2.0 * pow(vec3(p1, p2, p3), vec3(6.0 / 11.0))), s); }
RAND3(vec2, mat2)
RAND3(vec3, mat3)
RAND3(vec4, mat4)
#define RAND4(tv, tm) float rand3(tv uv, tm dm, tv dv, tv delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); float p3 = qlmap(uv + 2.0 * delta, dm, dv); float p4 = qlmap(uv + 3.0 * delta, dm, dv); return rand(sin(2.0 * pow(vec4(p1, p2, p3, p4), vec4(6.0 / 11.0))), s); }
RAND4(vec2, mat2)
RAND4(vec3, mat3)
RAND4(vec4, mat4)

#define PERLININNER(rf, p, r, f, F, b, o) vec2 B = 1.0 - b; vec2 R = r + b; vec2 v = rf(R, dm, dv, delta, s); v /= length(v); o += dot(v, p - R) * CURVE(prod_e(b * f + B * F));
float perlinGradient(vec2 p, mat2 dm, vec2 dv, vec2 delta, vec4 s) {
    vec2 r = floor(p);
    vec2 f = CURVE(fract(p)), F = 1.0 - f;
    float o = 0.0;
    for(float i = 0.0; i < 2.0; i++)
    for(float j = 0.0; j < 2.0; j++) {
        vec2 b = vec2(i, j);
        PERLININNER(rand2, p, r, f, F, b, o)
    }
    return o;
}
float perlinGradient(vec3 p, mat3 dm, vec3 dv, vec3 delta, vec4 s) {
    vec3 r = floor(p);
    vec3 f = CURVE(fract(p)), F = 1.0 - f;
    float o = 0.0;
    for(float i = 0.0; i < 2.0; i++)
    for(float j = 0.0; j < 2.0; j++)
    for(float k = 0.0; k < 2.0; k++) {
        vec3 b = vec3(i, j, k);
        PERLININNER(rand3, p, r, f, F, b, o)
    }
    return o;
}
float perlinGradient(vec4 p, mat4 dm, vec4 dv, vec4 delta, vec4 s) {
    vec4 r = floor(p);
    vec4 f = CURVE(fract(p)), F = 1.0 - f;
    float o = 0.0;
    for(float i = 0.0; i < 2.0; i++)
    for(float j = 0.0; j < 2.0; j++)
    for(float k = 0.0; k < 2.0; k++)
    for(float l = 0.0; l < 2.0; l++) {
        vec4 b = vec4(i, j, k, l);
        PERLININNER(rand4, p, r, f, F, b, o)
    }
    return o;
}

float simplexGradient(vec2 p, mat2 dm, vec2 dv, vec2 delta, vec4 s) {
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
    float v1 = dot(rand2(c1, dm, dv, delta, s), p - c1);
    float v2 = dot(rand2(c2, dm, dv, delta, s), p - c2);
    float v3 = dot(rand2(c3, dm, dv, delta, s), p - c3);
    return (v1 * w1 + v2 * w2 + v3 * w3) / (w1 + w2 + w3);
}
float simplexGradient(vec3 p, mat3 dm, vec3 dv, vec3 delta, vec4 s) {
    float skew = 1.0 / 3.0, unskew = 1.0 / 6.0;
    vec3 P = p + sum_e(p) * skew;
    vec3 L = floor(P);
    vec3 f = fract(P);
    ivec3 o = sortD(f);
    vec3 c1 = L;
    vec3 c2 = c1 + (o.x == 1 ? i3 : o.x == 2 ? j3 : k3);
    vec3 c3 = c2 + (o.y == 1 ? i3 : o.y == 2 ? j3 : k3);
    vec3 c4 = L + 1.0;
    c1 -= sum_e(c1) * unskew;
    c2 -= sum_e(c2) * unskew;
    c3 -= sum_e(c3) * unskew;
    c4 -= sum_e(c4) * unskew;
    float V = tetrahedron(c1, c2, c3, c4);
    float w1 = CURVE(tetrahedron(p, c2, c3, c4) / V);
    float w2 = CURVE(tetrahedron(c1, p, c3, c4) / V);
    float w3 = CURVE(tetrahedron(c1, c2, p, c4) / V);
    float w4 = CURVE(tetrahedron(c1, c2, c3, p) / V);
    vec3 g1 = rand3(c1, dm, dv, delta, s);
    vec3 g2 = rand3(c2, dm, dv, delta, s);
    vec3 g3 = rand3(c3, dm, dv, delta, s);
    vec3 g4 = rand3(c4, dm, dv, delta, s);
    vec3 d1 = p - c1;
    vec3 d2 = p - c2;
    vec3 d3 = p - c3;
    vec3 d4 = p - c4;
    float v1 = dot(g1, d1);
    float v2 = dot(g2, d2);
    float v3 = dot(g3, d3);
    float v4 = dot(g4, d4);
    return (v1 * w1 + v2 * w2 + v3 * w3 + v4 * w4) / (w1 + w2 + w3 + w4);
}

struct voro2 {
	float dis;
	float blend;
	float edge;
	vec2 gen;
	vec3 color;
};

voro2 voronoi( in vec2 x, float fallout, mat2 dm, vec2 dv, vec2 delta, vec4 s ) {
    ivec2 p = ivec2(floor( x ));
    vec2 f = fract( x );

    float res = 1.0e20;
    float res2 = 1.0e20;
    float eres = 0.0;
    ivec2 center;
    vec2 ray;
    const int range = 2;
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        //ivec2 b = ivec2( i, j );
        //ivec2 c = b + p;
        ivec2 c = ivec2( i, j ) + p;
        vec2 v = rand2( vec2(c), dm, dv, delta, s );
        vec2 r = vec2(c) + v;
        vec2 d = r - x;
        float dis = length( d );

		if(dis < res) {
			center = c;
			ray = r;
		}
		res2 = min(max(res, dis), res2);
        res = min(res, dis);
        eres += exp( -fallout*dis );
    }
    float edge = 1.0e20;
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        //ivec2 b = ivec2( i, j );
        //ivec2 c = b + center;
        ivec2 c = ivec2( i, j ) + center;
        vec2 v = rand2( vec2(c), dm, dv, delta, s );
        vec2 r = vec2(c) + v;
        float dis = abs(dot(0.5 * (r + ray) - x, normalize(r - ray) ));

        edge = min(edge, dis);
    }
    vec3 c = rand3(vec2(center), dm, dv, delta, s);
    c /= max(c.x, max(c.y, c.z));
    return voro2(
    	res,
		1.0 +(1.0/fallout)*log( res ),
		edge,
		ray,
		c
	);
}
vec2 voronoi( in vec3 x, float fallout, vec4 c, mat3 dm, vec3 dv, vec3 delta, vec4 s ) {
    ivec3 p = ivec3(floor( x ));
    vec3 f = fract( x );

    float res = 1.0e20;
    float eres = 0.0;
    const int range = 1;
    for( int k=-range; k<=range; k++ )
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        ivec3 b = ivec3( i, j, k );
        vec3 rv = rand3( vec3(p + b), dm, dv, delta, s );
        vec3 r = vec3(b) - f + rv;
        float dis = length( r );

        res = min(res, dis);
        eres += exp( -fallout*dis );
    }
    return vec2(res, 1.0 + (1.0/fallout)*log( res ));
}

void position(inout vec2 coord, vec2 res, float scale, float time, float timescale, float granularity, float radius, out vec3 coord3, out vec4 coord4) {
  coord /= res;
  coord *= scale;
  float t = time * timescale;
  coord3 = vec3(coord, t);
  coord4 = vec4(coord, radius * cos(t), radius * sin(t));
  //coord = floor(granularity * coord) / granularity;
  //coord3 = floor(granularity * coord3) / granularity;
  //coord4 = floor(granularity * coord4) / granularity;
}
vec3 pixel(vec2 uv, mat2 dm2, vec2 dv2, vec4 s) {
  vec3 c;
  //float v1 = rand1(uv3, dm3, dv3, s);
  //float v1 = perlinGradient(uv2, dm2, dv2, vec2(10.0, 10.0), s);
  //float v1 = perlinGradient(uv3, dm3, dv3, vec3(0.0, 0.0, 10.0), s);
  //float v1 = perlinGradient(uv4, dm4, dv4, vec4(0.0, 0.0, 10.0, 10.0), s);
  //float v1 = simplexGradient(uv, dm2, dv2, vec2(10.0, 10.0), s);
  //float v1 = simplexGradient(uv3, dm3, dv3, vec3(0.0, 0.0, 10.0), s);
  //float v1 = simplexGradient(uv4, dm4, dv4, vec4(0.0, 0.0, 10.0, 10.0), s);
  voro2 voro = voronoi(uv, 1.0, dm2, dv2, vec2(10.0, 10.0), s);
  float b = smoothstep(0.0125, 0.05, voro.edge);
  c = mix(vec3(1.0, 0.8, 0.0), voro.color * smoothstep(0.0, 1.0, 1.5 * voro.edge * cos(75.0 * voro.edge)), b);
  float g = smoothstep(0.0, 0.2, voro.dis);
  c = mix(mix(vec3(1.0, 0.75, 0.0), vec3(1.0, 0.5, 0.0), voro.dis * 5.0), c, g);
  float l = smoothstep(0.0375, 0.05, voro.dis);
  c = mix(mix(vec3(1.0, 1.0, 0.0), vec3(1.0, 0.5, 0.0), CURVE5(voro.dis * 20.0)), c, l);
  //c = vec3(voro.dis);
  //c = c * 0.5 + 0.5;
  //vec2 v2 = rand2(uv3, dm3, dv3, vec3(0.0, 0.0, 1.0), s);
  //c = vec3(v2 * 2.0 - 1.0, 0.5);
  return c;
}
void main() {
  vec2 uv = gl_FragCoord.xy;
  vec3 uv3;
  vec4 uv4;
  position(uv, u_resolution, u_scale, 0.0, u_time_scale, u_granularity, 1.0, uv3, uv4);
  //mat2 dm2 = mat2(sqrt(5.0) * 13.0, sqrt(3.0) * 12.0, sqrt(2.0) * 10.0, sqrt(7.0) * 11.0);
  mat2 dm2 = mat2(sqrt(5.0) / 3.0, sqrt(2.0) / 1.5, sqrt(7.0) / 2.0, sqrt(3.0) / 1.8);
  mat3 dm3 = mat3(
    sqrt(5.0) / 3.0, sqrt(2.0) / 1.5, sqrt(63.0) / 8.2,
    sqrt(7.0) / 2.0, sqrt(3.0) / 1.8, sqrt(137.0) / 11.8,
    //sqrt(19.0) / 4.2, sqrt(123.0) / 11.1, sqrt(23.0) / 4.9
    0.0, 0.0, 0.0
  );
  mat4 dm4 = mat4(
    sqrt(5.0) / 3.0, sqrt(2.0) / 1.5, sqrt(63.0) / 8.2, 0.0,
    sqrt(7.0) / 2.0, sqrt(3.0) / 1.8, sqrt(137.0) / 11.8, 0.0,
    //sqrt(19.0) / 4.2, sqrt(123.0) / 11.1, sqrt(23.0) / 4.9
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0
  );
  //vec2 dv2 = vec2(35.5215, 43.6436)
  vec2 dv2 = vec2(sqrt(11.0) / 2.2, sqrt(15.0) / 4.0);
  vec3 dv3 = vec3(sqrt(11.0) / 3.2, sqrt(15.0) / 4.0, /*sqrt(17.0) / 4.1*/ 1.0);
  vec4 dv4 = vec4(sqrt(11.0) / 3.2, sqrt(15.0) / 4.0, /*sqrt(17.0) / 4.1*/ 1.0, 0.5976);
  vec4 s = vec4(1518.367, 34.347, 184.536, 363.5773);
  vec3 c = vec3(0.0);
  float factor = 1.0 / float(u_samples);
  for(int i = 0; i < 20; i++)
  	if(i < u_samples)
      c += pixel(uv + rand2(uv3 + vec3(0.0, 0.0, float(i)), dm3, dv3, vec3(0.0, 0.0, 0.5), s) * u_scale / u_resolution, dm2, dv2, s) * factor;
  gl_FragColor = vec4(pixel(uv, dm2, dv2, s), 1.0);
}
/*
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
*/
