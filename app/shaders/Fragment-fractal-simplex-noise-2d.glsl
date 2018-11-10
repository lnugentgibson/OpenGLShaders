precision mediump float;

uniform vec2 u_resolution;
uniform float u_granularity;
uniform float u_scale;
uniform int u_iterations;
uniform mat2 u_qseed;
uniform vec2 u_lseed;
uniform vec4 u_rseed;

#define MOD(a, b) (a - floor(a / b) * b)

#define MOD289(x) MOD(x, 289.0)

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
vec4 mul(vec4 a, vec2 b) { return a * vec4(b, b); }
vec4 mul(vec4 a, vec3 b) { return a * vec4(b, 1.0); }

#define PERMUTE(x) (MOD289(((x*34.0)+1.0)*x)/289.0)

#define SINFRACT(x, s) fract(sin(x * s.x + s.y) * s.z + s.w)

float Dot(vec2 a, vec2 b) { return dot(a, b); }

float Dot(vec3 a, vec3 b) { return dot(a, b); }

float Dot(vec4 a, vec4 b) { return dot(a, b); }

float permute(float x, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); float xseed = mul(x, seed); return PERMUTE(xseed); }

vec2 permute(vec2 x, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec2 xseed = mul(x, seed); return PERMUTE(xseed); }

vec3 permute(vec3 x, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec3 xseed = mul(x, seed); return PERMUTE(xseed); }

vec4 permute(vec4 x, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec4 xseed = mul(x, seed); return PERMUTE(xseed); }

float sinfract(float x, vec4 s) { return SINFRACT(x, s); }

vec2 sinfract(vec2 x, vec4 s) { return SINFRACT(x, s); }

vec3 sinfract(vec3 x, vec4 s) { return SINFRACT(x, s); }

vec4 sinfract(vec4 x, vec4 s) { return SINFRACT(x, s); }

vec2 Dot(mat2 m, vec2 v) { return m * v; }

vec3 Dot(mat3 m, vec3 v) { return m * v; }

vec4 Dot(mat4 m, vec4 v) { return m * v; }

#define rand sinfract

float qlmap(vec2 v, mat2 dm, vec2 dv) { return Dot(Dot(dm, v) + dv, v); }

float qlmap(vec3 v, mat3 dm, vec3 dv) { return Dot(Dot(dm, v) + dv, v); }

float qlmap(vec4 v, mat4 dm, vec4 dv) { return Dot(Dot(dm, v) + dv, v); }

float red_e(vec2 v, float f) {return Dot(v, vec2(f));}

float red_e(vec3 v, float f) {return Dot(v, vec3(f));}

float red_e(vec4 v, float f) {return Dot(v, vec4(f));}

float Triple(vec3 a, vec3 b, vec3 c) {
    return dot(a, cross(b, c));
}

#define CURVE3(a) (a * a * (3.0 - 2.0 * a))

#define CURVE1(a) (a)

#define CURVE5(a) (a * a * a * (10.0 + a * (6.0 * a - 15.0)))

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

#define CURVE CURVE3

vec2 rand2(vec2 uv, mat2 dm, vec2 dv, vec2 delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); return rand(sin(2.0 * pow(vec2(p1, p2), vec2(6.0 / 11.0))), s); }

vec2 rand2(vec3 uv, mat3 dm, vec3 dv, vec3 delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); return rand(sin(2.0 * pow(vec2(p1, p2), vec2(6.0 / 11.0))), s); }

vec2 rand2(vec4 uv, mat4 dm, vec4 dv, vec4 delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); return rand(sin(2.0 * pow(vec2(p1, p2), vec2(6.0 / 11.0))), s); }

vec3 rand3(vec2 uv, mat2 dm, vec2 dv, vec2 delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); float p3 = qlmap(uv + 2.0 * delta, dm, dv); return rand(sin(2.0 * pow(vec3(p1, p2, p3), vec3(6.0 / 11.0))), s); }

vec3 rand3(vec3 uv, mat3 dm, vec3 dv, vec3 delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); float p3 = qlmap(uv + 2.0 * delta, dm, dv); return rand(sin(2.0 * pow(vec3(p1, p2, p3), vec3(6.0 / 11.0))), s); }

vec3 rand3(vec4 uv, mat4 dm, vec4 dv, vec4 delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); float p3 = qlmap(uv + 2.0 * delta, dm, dv); return rand(sin(2.0 * pow(vec3(p1, p2, p3), vec3(6.0 / 11.0))), s); }

vec4 rand4(vec2 uv, mat2 dm, vec2 dv, vec2 delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); float p3 = qlmap(uv + 2.0 * delta, dm, dv); float p4 = qlmap(uv + 3.0 * delta, dm, dv); return rand(sin(2.0 * pow(vec4(p1, p2, p3, p4), vec4(6.0 / 11.0))), s); }

vec4 rand4(vec3 uv, mat3 dm, vec3 dv, vec3 delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); float p3 = qlmap(uv + 2.0 * delta, dm, dv); float p4 = qlmap(uv + 3.0 * delta, dm, dv); return rand(sin(2.0 * pow(vec4(p1, p2, p3, p4), vec4(6.0 / 11.0))), s); }

vec4 rand4(vec4 uv, mat4 dm, vec4 dv, vec4 delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); float p3 = qlmap(uv + 2.0 * delta, dm, dv); float p4 = qlmap(uv + 3.0 * delta, dm, dv); return rand(sin(2.0 * pow(vec4(p1, p2, p3, p4), vec4(6.0 / 11.0))), s); }

float prod_e(vec2 v) {return v.x * v.y;}
float prod_e(vec3 v) {return v.x * v.y * v.z;}
float prod_e(vec4 v) {return v.x * v.y * v.z * v.w;}

float sum_e(vec2 v) {return red_e(v, 1.0);}

float sum_e(vec3 v) {return red_e(v, 1.0);}

float sum_e(vec4 v) {return red_e(v, 1.0);}

float triangle(vec2 a, vec2 b, vec2 c) {
    vec2 B = b - a, C = c - a;
    vec3 B3 = vec3(B, 0.0), C3 = vec3(C, 0.0);
    //return sqrt(Dot(B) * Dot(C) - Dot2(B, C)) / 2.0;
    return 0.5 * length(cross(B3, C3));
}

float tetrahedron(vec3 a, vec3 b, vec3 c, vec3 d) {
    vec3 B = b - a, C = c - a, D = d - a;
    return abs(Triple(B, C, D)) / 6.0;
}

float pentachoron(vec4 a, vec4 b, vec4 c, vec4 d, vec4 e) {
    vec4 B = b - a, C = c - a, D = d - a, E = e - a;
    return (
        B.x * Triple(C.yzw, D.yzw, E.yzw) -
        C.x * Triple(B.yzw, D.yzw, E.yzw) +
        D.x * Triple(B.yzw, C.yzw, E.yzw) -
        E.x * Triple(B.yzw, C.yzw, D.yzw)
    ) / 24.0;
}

#define o2 vec2(0.0)
#define i2 vec2(1.0, 0.0)
#define j2 vec2(0.0, 1.0)
#define o3 vec3(0.0)
#define i3 vec3(1.0, 0.0, 0.0)
#define j3 vec3(0.0, 1.0, 0.0)
#define k3 vec3(0.0, 0.0, 1.0)
#define o4 vec4(0.0)
#define i4 vec4(1.0, 0.0, 0.0, 0.0)
#define j4 vec4(0.0, 1.0, 0.0, 0.0)
#define k4 vec4(0.0, 0.0, 1.0, 0.0)
#define l4 vec4(0.0, 0.0, 0.0, 1.0)

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
    vec3 w = vec3(
      triangle( p, c2, c3) / A,
      triangle(c1,  p, c3) / A,
      triangle(c1, c2,  p) / A
    );
    w = CURVE(w);
    vec3 v = vec3(
      dot(normalize(rand2(c1, dm, dv, delta, s) * 2.0 - 1.0), p - c1),
      dot(normalize(rand2(c2, dm, dv, delta, s) * 2.0 - 1.0), p - c2),
      dot(normalize(rand2(c3, dm, dv, delta, s) * 2.0 - 1.0), p - c3)
    );
    return dot(w, v) / (w.x + w.y + w.z) / 0.5329;
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
    vec4 w = vec4(
      tetrahedron( p, c2, c3, c4) / V,
      tetrahedron(c1,  p, c3, c4) / V,
	  tetrahedron(c1, c2,  p, c4) / V,
	  tetrahedron(c1, c2, c3,  p) / V
    );
    w = CURVE(w);
    vec4 v = vec4(
      dot(normalize(rand3(c1, dm, dv, delta, s) * 2.0 - 1.0), p - c1),
      dot(normalize(rand3(c2, dm, dv, delta, s) * 2.0 - 1.0), p - c2),
      dot(normalize(rand3(c3, dm, dv, delta, s) * 2.0 - 1.0), p - c3),
      dot(normalize(rand3(c4, dm, dv, delta, s) * 2.0 - 1.0), p - c4)
    );
    return dot(w, v) / (w.x + w.y + w.z + w.w);
}
float simplexGradient(vec4 p, mat4 dm, vec4 dv, vec4 delta, vec4 s) {
    float skew = 1.0 / 3.0, unskew = 1.0 / 6.0;
    vec4 P = p + sum_e(p) * skew;
    vec4 L = floor(P);
    vec4 f = fract(P);
    ivec4 o = sortD(f);
    vec4 c1 = L;
    vec4 c2 = c1 + (o.x == 1 ? i4 : o.y == 1 ? j4 : o.z == 1 ? k4 : l4);
    vec4 c3 = c2 + (o.x == 2 ? i4 : o.y == 2 ? j4 : o.z == 2 ? k4 : l4);
    vec4 c4 = c2 + (o.x == 3 ? i4 : o.y == 3 ? j4 : o.z == 3 ? k4 : l4);
    vec4 c5 = L + 1.0;
    c1 -= sum_e(c1) * unskew;
    c2 -= sum_e(c2) * unskew;
    c3 -= sum_e(c3) * unskew;
    c4 -= sum_e(c4) * unskew;
    c5 -= sum_e(c5) * unskew;
    float H = pentachoron(c1, c2, c3, c4, c5);
    vec3 w1 = vec3(
      pentachoron( p, c2, c3, c4, c5) / H,
      pentachoron(c1,  p, c3, c4, c5) / H,
      pentachoron(c1, c2,  p, c4, c5) / H
    );
    vec2 w2 = vec2(
      pentachoron(c1, c2, c3,  p, c5) / H,
      pentachoron(c1, c2, c3, c4,  p) / H
    );
    w1 = CURVE(w1);
    w2 = CURVE(w2);
    vec3 v1 = vec3(
      dot(normalize(rand4(c1, dm, dv, delta, s) * 2.0 - 1.0), p - c1),
      dot(normalize(rand4(c2, dm, dv, delta, s) * 2.0 - 1.0), p - c2),
      dot(normalize(rand4(c3, dm, dv, delta, s) * 2.0 - 1.0), p - c3)
    );
    vec2 v2 = vec2(
      dot(normalize(rand4(c4, dm, dv, delta, s) * 2.0 - 1.0), p - c4),
      dot(normalize(rand4(c5, dm, dv, delta, s) * 2.0 - 1.0), p - c5)
    );
    return (dot(w1, v1) + dot(w2, v2)) / (w1.x + w1.y + w1.z + w2.x + w2.y);
}

float perlinGradient(vec2 p, mat2 dm, vec2 dv, vec2 delta, vec4 s) {
  vec2 r = floor(p);
  vec2 f = CURVE(fract(p)), F = 1.0 - f;
  float o = 0.0;
  for(float ind0 = 0.0; ind0 < 2.0; ind0++)
  for(float ind1 = 0.0; ind1 < 2.0; ind1++)
  {
    vec2 b = vec2(ind0, ind1);
    vec2 B = 1.0 - b;
    vec2 R = r + b;
    vec2 v = rand2(R, dm, dv, delta, s) * 2.0 - 1.0;
    v /= length(v);
    o += dot(v, p - R) * CURVE(prod_e(b * f + B * F));
  }
  return o / 0.5625;
}

float perlinGradient(vec3 p, mat3 dm, vec3 dv, vec3 delta, vec4 s) {
  vec3 r = floor(p);
  vec3 f = CURVE(fract(p)), F = 1.0 - f;
  float o = 0.0;
  for(float ind0 = 0.0; ind0 < 2.0; ind0++)
  for(float ind1 = 0.0; ind1 < 2.0; ind1++)
  for(float ind2 = 0.0; ind2 < 2.0; ind2++)
  {
    vec3 b = vec3(ind0, ind1, ind2);
    vec3 B = 1.0 - b;
    vec3 R = r + b;
    vec3 v = rand3(R, dm, dv, delta, s) * 2.0 - 1.0;
    v /= length(v);
    o += dot(v, p - R) * CURVE(prod_e(b * f + B * F));
  }
  return o / 0.5625;
}

float perlinGradient(vec4 p, mat4 dm, vec4 dv, vec4 delta, vec4 s) {
  vec4 r = floor(p);
  vec4 f = CURVE(fract(p)), F = 1.0 - f;
  float o = 0.0;
  for(float ind0 = 0.0; ind0 < 2.0; ind0++)
  for(float ind1 = 0.0; ind1 < 2.0; ind1++)
  for(float ind2 = 0.0; ind2 < 2.0; ind2++)
  for(float ind3 = 0.0; ind3 < 2.0; ind3++)
  {
    vec4 b = vec4(ind0, ind1, ind2, ind3);
    vec4 B = 1.0 - b;
    vec4 R = r + b;
    vec4 v = rand4(R, dm, dv, delta, s) * 2.0 - 1.0;
    v /= length(v);
    o += dot(v, p - R) * CURVE(prod_e(b * f + B * F));
  }
  return o / 0.5625;
}

#define NOISE simplexGradient

#define NOISEITERATIONS 10

#define NOISEGET(x) x

float fbm(vec2 p, int iterations, mat2 ss, float as, mat2 dm, vec2 dv, vec2 d1, vec2 d2, vec4 s) {
    float o = 0.0, a = 1.0;
    for(int i = 0; i < NOISEITERATIONS; i++) {
      if(i < iterations) {
        o += NOISEGET(NOISE(p + float(i) * d2, dm, dv, d1, s)) * a;
        p *= ss;
        a *= as;
      }
    }
    return o;
}

float fbm(vec3 p, int iterations, mat3 ss, float as, mat3 dm, vec3 dv, vec3 d1, vec3 d2, vec4 s) {
    float o = 0.0, a = 1.0;
    for(int i = 0; i < NOISEITERATIONS; i++) {
      if(i < iterations) {
        o += NOISEGET(NOISE(p + float(i) * d2, dm, dv, d1, s)) * a;
        p *= ss;
        a *= as;
      }
    }
    return o;
}

float fbm(vec4 p, int iterations, mat4 ss, float as, mat4 dm, vec4 dv, vec4 d1, vec4 d2, vec4 s) {
    float o = 0.0, a = 1.0;
    for(int i = 0; i < NOISEITERATIONS; i++) {
      if(i < iterations) {
        o += NOISEGET(NOISE(p + float(i) * d2, dm, dv, d1, s)) * a;
        p *= ss;
        a *= as;
      }
    }
    return o;
}

float dither(float g, vec2 uv) {
  uv = uv * 2.0;
  float x, y, z, l;
  
  x = 3.0 * uv.x;
  y = 3.0 * uv.y;
  z = 3.0 * (1.0 - uv.x - uv.y);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g);
  
  x = 3.0 * (uv.x - 1.0);
  y = 3.0 * uv.y;
  z = 3.0 * (2.0 - uv.x - uv.y);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 1.0);
  
  x = 3.0 * uv.x;
  y = 3.0 * (uv.y - 1.0);
  z = 3.0 * (2.0 - uv.x - uv.y);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 2.0);
  
  x = 3.0 * (uv.x - 1.0);
  y = 3.0 * (uv.y - 1.0);
  z = 3.0 * (3.0 - uv.x - uv.y);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 3.0);
  
  x = 3.0 * (1.0 - uv.x);
  y = 3.0 * (1.0 - uv.y);
  z = 3.0 * (uv.x + uv.y - 1.0);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 4.0);
  
  x = 3.0 * (2.0 - uv.x);
  y = 3.0 * (1.0 - uv.y);
  z = 3.0 * (uv.x + uv.y - 2.0);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 5.0);
  
  x = 3.0 * (1.0 - uv.x);
  y = 3.0 * (2.0 - uv.y);
  z = 3.0 * (uv.x + uv.y - 2.0);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 6.0);
  
  x = 3.0 * (2.0 - uv.x);
  y = 3.0 * (2.0 - uv.y);
  z = 3.0 * (uv.x + uv.y - 3.0);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 7.0);
  
  return g / 8.0;
}

void main() {
  vec2 UV = gl_FragCoord.xy, uv = UV, uvi;
  if(u_granularity > 1.0) {
    uv = floor(UV / u_granularity) * u_granularity;
    uvi = (UV - uv) / u_granularity;
  }
  uv /= u_resolution;
  uv *= u_scale;
  mat2 ss = mat2(2.0, 0.0, 0.0, 2.0) * mat2(cos(0.2), sin(0.2), -sin(0.2), cos(0.2));
  vec2 d1 = vec2(10.0, 10.0);
  vec2 d2 = vec2(-5.0, -5.0);
  float g = fbm(uv, u_iterations, ss, 0.5, u_qseed, u_lseed, d1, d2, u_rseed) * 1.4 * 0.5 + 0.5 + 0.05;
  float G = g * 8.0;
  gl_FragColor = vec4(vec3(u_granularity > 1.0 ? dither(G, uvi) : g), 1.0);
}
