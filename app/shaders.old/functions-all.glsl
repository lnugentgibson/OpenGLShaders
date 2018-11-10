#define MOD(a, b) (a - floor(a / b) * b)

#define MOD289(x) MOD(x, 289.0)

#define SINFRACT(x, s) fract(sin(x * s.x + s.y) * s.z + s.w)

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

float sinfract(float x, vec4 s) { return SINFRACT(x, s); }

vec2 sinfract(vec2 x, vec4 s) { return SINFRACT(x, s); }

vec3 sinfract(vec3 x, vec4 s) { return SINFRACT(x, s); }

vec4 sinfract(vec4 x, vec4 s) { return SINFRACT(x, s); }

float permute(float x, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); float xseed = mul(x, seed); return PERMUTE(xseed); }

vec2 permute(vec2 x, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec2 xseed = mul(x, seed); return PERMUTE(xseed); }

vec3 permute(vec3 x, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec3 xseed = mul(x, seed); return PERMUTE(xseed); }

vec4 permute(vec4 x, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec4 xseed = mul(x, seed); return PERMUTE(xseed); }

vec2 Dot(mat2 m, vec2 v) { return m * v; }

vec3 Dot(mat3 m, vec3 v) { return m * v; }

vec4 Dot(mat4 m, vec4 v) { return m * v; }

float Dot(vec2 a, vec2 b) { return dot(a, b); }

float Dot(vec3 a, vec3 b) { return dot(a, b); }

float Dot(vec4 a, vec4 b) { return dot(a, b); }

#define CURVE1(a) (a)

mat2 transpose(mat2 m) {
	return mat2(
		m[0][0], m[1][0],
		m[0][1], m[1][1]
	);
}
mat3 transpose(mat3 m) {
	return mat3(
		m[0][0], m[1][0], m[2][0],
		m[0][1], m[1][1], m[2][1],
		m[0][2], m[1][2], m[2][2]
	);
}
mat4 transpose(mat4 m) {
	return mat4(
		m[0][0], m[1][0], m[2][0], m[3][0],
		m[0][1], m[1][1], m[2][1], m[3][1],
		m[0][2], m[1][2], m[2][2], m[3][2],
		m[0][3], m[1][3], m[2][3], m[3][3]
	);
}

float qlmap(vec2 v, mat2 dm, vec2 dv) { return Dot(Dot(dm, v) + dv, v); }

float qlmap(vec3 v, mat3 dm, vec3 dv) { return Dot(Dot(dm, v) + dv, v); }

float qlmap(vec4 v, mat4 dm, vec4 dv) { return Dot(Dot(dm, v) + dv, v); }

mat3 colExclusion(mat3 m, int c) {
	return mat3(c == 0 ? m[1] : m[0], c == 2 ? m[1] : m[2], o3);
}
mat4 colExclusion(mat4 m, int c) {
	return mat4(c == 0 ? m[1] : m[0], c > 1 ? m[1] : m[2], c == 3 ? m[2] : m[3], o4);
}

float red_e(vec2 v, float f) {return Dot(v, vec2(f));}

float red_e(vec3 v, float f) {return Dot(v, vec3(f));}

float red_e(vec4 v, float f) {return Dot(v, vec4(f));}

#define rand sinfract

#define CURVE5(a) (a * a * a * (10.0 + a * (6.0 * a - 15.0)))

float Triple(vec3 a, vec3 b, vec3 c) {
    return dot(a, cross(b, c));
}

#define CURVE3(a) (a * a * (3.0 - 2.0 * a))

float tetrahedron(vec3 a, vec3 b, vec3 c, vec3 d) {
    vec3 B = b - a, C = c - a, D = d - a;
    return abs(Triple(B, C, D)) / 6.0;
}

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

float sum_e(vec2 v) {return red_e(v, 1.0);}

float sum_e(vec3 v) {return red_e(v, 1.0);}

float sum_e(vec4 v) {return red_e(v, 1.0);}

mat2 exclusionTranspose(mat3 m, int r, int c) {
	return demote2(colExclusion(transpose(colExclusion(m, c)), r));
}
mat3 exclusionTranspose(mat4 m, int r, int c) {
	return demote3(colExclusion(transpose(colExclusion(m, c)), r));
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

float triangle(vec2 a, vec2 b, vec2 c) {
    vec2 B = b - a, C = c - a;
    vec3 B3 = vec3(B, 0.0), C3 = vec3(C, 0.0);
    //return sqrt(Dot(B) * Dot(C) - Dot2(B, C)) / 2.0;
    return 0.5 * length(cross(B3, C3));
}

#define CURVE CURVE3

struct parallelogram2d {
	vec2 base;
	float majorLength;
	float minorLength;
	float diagonalLength;
	vec2 majorRay;
	vec2 minorRay;
	vec2 diagonalRay;
	vec2 majorVector;
	vec2 minorVector;
	vec2 majorCorner;
	vec2 minorCorner;
	vec2 diagonalCorner;
	vec2 centerPoint;
};

struct circle2d {
	vec2 center;
	float radius;
};

struct line2d {
	vec2 base;
	vec2 target;
	vec2 midpoint;
	vec2 vector;
	vec2 ray;
	float length;
	vec2 normal;
};

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

float determinant(mat2 m) {
	return m[0][0] * m[1][1] - m[0][1] * m[1][0];
}
float determinant(mat3 m) {
	return m[0][0] * determinant(exclusionTranspose(m, 0, 0)) - m[1][0] * determinant(exclusionTranspose(m, 0, 1)) + m[2][0] * determinant(exclusionTranspose(m, 0, 2));
}
float determinant(mat4 m) {
	return m[0][0] * determinant(exclusionTranspose(m, 0, 0)) - m[1][0] * determinant(exclusionTranspose(m, 0, 1)) + m[2][0] * determinant(exclusionTranspose(m, 0, 2)) + m[3][0] * determinant(exclusionTranspose(m, 0, 3));
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

struct triangle2d {
	vec2 base;
	line2d leg0;
	line2d leg1;
	line2d leg2;
	line2d median0;
	line2d median1;
	line2d median2;
	line2d pbisector0;
	line2d pbisector1;
	line2d pbisector2;
	line2d altitude0;
	line2d altitude1;
	line2d altitude2;
	line2d abisector0;
	line2d abisector1;
	line2d abisector2;
	vec2 orthocenter;
	vec2 centroid;
	circle2d incircle;
	circle2d circumcircle;
};

parallelogram2d Square_corner_size_angle(vec2 base, float size, float angle) {
	vec2 x = vec2(cos(angle), sin(angle));
	vec2 y = vec2(-sin(angle), cos(angle));
	vec2 xy = x + y;
	return parallelogram2d(
		base, // base
		size, // majorLength
		size, // minorLength
		size * sqrt(2.0), //diagonalLength
		x, // majorRay
		y, // minorRay
		vec2(size), // diagonalRay
		x * size, // majorVector
		y * size, // minorVector
		base + size * x, // majorCorner
		base + size * y, // minorCorner
		base + size * xy, // diagonalCorner
		base + size * xy * 0.5 // centerPoint
	);
}

struct parallelogram2dPoint {
	parallelogram2d rect;
	vec2 point;
	vec2 vector;
	vec2 ray;
	vec2 coord;
	float distance;
	float majorDistance;
	float minorDistance;
	float diagonalDistance;
	float radius;
	int inside;
	ivec2 placement;
};

float pulse(float n, float x, float a) {
	return step(n, a) - step(x, a);
}

float drawlinesegment(vec2 p, line2d line, float thickness) {
	vec2 vector = p - line.base;
	//return smoothpulse(-thickness * 0.5, 0.0, 0.0, thickness * 0.5, dot(line.normal, vector)) * pulse(0.0, line.length, dot(vector, line.ray));
	return pulse(-thickness * 0.5, thickness * 0.5, dot(line.normal, vector)) * pulse(0.0, line.length, dot(vector, line.ray));
}

float max_e(vec2 v) { return max(v.x, v.y); }
float max_e(vec3 v) { return max(v.x, max(v.y, v.z)); }
float max_e(vec4 v) { return max(max(v.x, v.y), max(v.z, v.w)); }

float constrain(float v, float n, float x) { return max(min(v, x), n); }

vec2 constrain(vec2 v, float n, float x) { return max(min(v, x), n); }

vec3 constrain(vec3 v, float n, float x) { return max(min(v, x), n); }

vec4 constrain(vec4 v, float n, float x) { return max(min(v, x), n); }

mat2 inverse(mat2 m) {
	return mat2(m[1][1], -m[1][0], -m[0][1], m[0][0]) / determinant(m);
}
mat3 inverse(mat3 m) {
	mat3 adj = mat3(0.0);
	for(int r = 0; r < 3; r++)
	for(int c = 0; c < 3; c++) {
		int d = r + c, q = d - 2 * (d / 2);
		adj[c][r] = float(1 - q * 2) * determinant(exclusionTranspose(m, c, r));
	}
	float d = dot(vec3(m[0][0], m[1][0], m[2][0]), adj[0]);
	return adj / d;
}
mat4 inverse(mat4 m) {
	mat4 adj = mat4(0.0);
	for(int r = 0; r < 4; r++)
	for(int c = 0; c < 4; c++) {
		int d = r + c, q = d - 2 * (d / 2);
		adj[c][r] = float(1 - q * 2) * determinant(exclusionTranspose(m, c, r));
	}
	float d = dot(vec4(m[0][0], m[1][0], m[2][0], m[3][0]), adj[0]);
	return adj / d;
}

struct voro2 {
	float dis;
	float blend;
	float edge;
	vec2 gen;
	vec3 color;
};

struct voro3 {
	float dis;
	float blend;
	float edge;
	vec3 gen;
	vec3 color;
};

struct voro4 {
	float dis;
	float blend;
	float edge;
	vec4 gen;
	vec3 color;
};

#define NOISE simplexGradient

vec2 intersect(line2d l1, line2d l2) {
	vec2 d = l2.base - l1.base;
	mat2 A = mat2(l1.ray, -l2.ray);
	mat2 A1 = mat2(d, -l2.ray);
	return determinant(A1) / determinant(A) * l1.ray + l1.base;
}

float drawline(vec2 p, line2d line, float thickness) {
	vec2 vector = p - line.base;
	return pulse(-thickness * 0.5, thickness * 0.5, dot(line.normal, vector));
}

float drawray(vec2 p, line2d line, float thickness) {
	vec2 vector = p - line.base;
	return pulse(-thickness * 0.5, thickness * 0.5, dot(line.normal, vector)) * step(0.0, dot(vector, line.ray));
}

#define PERMUTER(x, o, r) (MOD289(((x*34.0)+1.0)*x)/289.0*r+o)

float drawdashedlinesegment(vec2 p, line2d line, float thickness, float freq) {
	vec2 vector = p - line.base;
	//return smoothpulse(-0.5, 0.0, 0.0, 0.5, dot(line.normal, vector)) * pulse(0.0, line.length, dot(vector, line.ray));// * step(0.0, sin(dot(vector, line.ray)));
	return pulse(-thickness * 0.5, thickness * 0.5, dot(line.normal, vector)) * pulse(0.0, line.length, dot(vector, line.ray)) * step(0.0, sin(dot(vector, freq * line.ray)));
}

mat2 demote2(mat3 m) {
	return mat2(m[0].xy, m[1].xy);
}
mat2 demote2(mat4 m) {
	return mat2(m[0].xy, m[1].xy);
}
mat3 demote3(mat4 m) {
	return mat3(m[0].xyz, m[1].xyz, m[2].xyz);
}
vec2 demote2(vec3 v) {
	return v.xy;
}
vec2 demote2(vec4 v) {
	return v.xy;
}
vec3 demote3(vec4 v) {
	return v.xyz;
}

parallelogram2d Square_corner_size(vec2 base, float size) {
	return parallelogram2d(
		base, // base
		size, // majorLength
		size, // minorLength
		size * sqrt(2.0), //diagonalLength
		i2, // majorRay
		j2, // minorRay
		vec2(size), // diagonalRay
		i2 * size, // majorVector
		j2 * size, // minorVector
		base + size * i2, // majorCorner
		base + size * j2, // minorCorner
		base + size, // diagonalCorner
		base + size * 0.5 // centerPoint
	);
}

#define NOISEITERATIONS 10

parallelogram2d Square_center_size_angle(vec2 center, float size, float angle) {
	vec2 x = vec2(cos(angle), sin(angle));
	vec2 y = vec2(-sin(angle), cos(angle));
	return Square_corner_size_angle(center - (x + y) * size * 0.5, size, angle);
}

parallelogram2dPoint Parallelogram2dPoint(vec2 p, parallelogram2d rect) {
	vec2 vector = p - rect.base;
	vec2 ray = p - rect.centerPoint;
	mat2 A = transpose(mat2(rect.majorVector, rect.minorVector));
	mat2 i = inverse(A);
	vec2 coord = i * vector;
	return parallelogram2dPoint (
		rect, // rect
		p, // point
		vector, // vector
		ray, // ray
		coord, // coord
		length(vector), // distance
		length(p - rect.majorCorner), // majorDistance
		length(p - rect.minorCorner), // minorDistance
		length(p - rect.diagonalCorner), // diagonalDistance
		length(ray), // radius
		coord.x >= 0.0 && coord.y >= 0.0 && coord.x <= 1.0 && coord.y <= 1.0 ? 0 : 1, // inside
		ivec2(coord.x < 0.0 ? -1 : (coord.x > 1.0 ? 1 : 0), coord.y < 0.0 ? -1 : (coord.y > 1.0 ? 1 : 0)) // placement
	);
}

#define NOISEGET(x) x

struct triangle2dPoint {
	triangle2d tri;
	vec2 point;
	vec2 vector;
	vec2 coord;
	vec3 baryocentric;
	float distance;
	float majorDistance;
	float minorDistance;
	int inside;
	ivec3 placement;
};

float Dot(vec2 v) { return dot(v, v); }

float Dot(vec3 v) { return dot(v, v); }

float Dot(vec4 v) { return dot(v, v); }

float smoothpulse(float nn, float nx, float xn, float xx, float a) {
	return smoothstep(nn, nx, a) - smoothstep(xn, xx, a);
}

float sinfract(float x, vec4 s) { return SINFRACT(x, s); }

vec2 sinfract(vec2 x, vec4 s) { return SINFRACT(x, s); }

vec3 sinfract(vec3 x, vec4 s) { return SINFRACT(x, s); }

vec4 sinfract(vec4 x, vec4 s) { return SINFRACT(x, s); }

float rand1(vec2 uv, mat2 dm, vec2 dv, vec4 s) { return rand(sin(2.0 * pow(qlmap(uv, dm, dv), 6.0 / 11.0)), s); }

float rand1(vec3 uv, mat3 dm, vec3 dv, vec4 s) { return rand(sin(2.0 * pow(qlmap(uv, dm, dv), 6.0 / 11.0)), s); }

float rand1(vec4 uv, mat4 dm, vec4 dv, vec4 s) { return rand(sin(2.0 * pow(qlmap(uv, dm, dv), 6.0 / 11.0)), s); }

float perlinGradient(vec2 p, sampler2D n1, vec2 r1, float scale) {
  vec2 r = floor(p);
  vec2 f = CURVE(fract(p)), F = 1.0 - f;
  float o = 0.0;
  for(float i = 0.0; i < 2.0; i++)
  for(float j = 0.0; j < 2.0; j++) {
    vec2 b = vec2(i, j);
    vec2 B = 1.0 - b;
    vec2 R = r + b;
    vec2 v = texture2D(n1, scale * R / r1).rg * 2.0 - 1.0;
    v /= length(v);
    o += dot(v, p - R) * CURVE(prod_e(b * f + B * F));
  }
  return o / 0.5625;
}

mat2 exclusion(mat3 m, int r, int c) {
	return transpose(demote2(colExclusion(transpose(colExclusion(m, c)), r)));
}
mat3 exclusion(mat4 m, int r, int c) {
	return transpose(demote3(colExclusion(transpose(colExclusion(m, c)), r)));
}

float Mod(float a, float b) {return MOD(a, b);}

vec2 Mod(vec2 a, vec2 b) {return MOD(a, b);}

vec3 Mod(vec3 a, vec3 b) {return MOD(a, b);}

vec4 Mod(vec4 a, vec4 b) {return MOD(a, b);}

float mod289(float x) { return MOD289(x); }

vec2 mod289(vec2 x) { return MOD289(x); }

vec3 mod289(vec3 x) { return MOD289(x); }

vec4 mod289(vec4 x) { return MOD289(x); }

float simplexGradient(vec2 p, sampler2D n1, vec2 r1, float scale) {
    float skew = (sqrt(3.0) - 1.0) / 2.0, unskew = (1.0 - 1.0 / sqrt(3.0)) / 2.0;
    vec2 P = p + sum_e(p) * skew;
    ivec2 L = ivec2(floor(P));
    vec2 f = fract(P);
    ivec2 c1 = L;
    ivec2 c2 = c1 + ivec2(f.x >= f.y ? i2 : j2);
    ivec2 c3 = L + ivec2(1);
    vec2 C1 = vec2(c1) - sum_e(vec2(c1)) * unskew;
    vec2 C2 = vec2(c2) - sum_e(vec2(c2)) * unskew;
    vec2 C3 = vec2(c3) - sum_e(vec2(c3)) * unskew;
    float A = triangle(C1, C2, C3);
    vec3 w = vec3(
      triangle( p, C2, C3) / A,
      triangle(C1,  p, C3) / A,
      triangle(C1, C2,  p) / A
    );
    w = CURVE(w);
    vec3 v = vec3(
      dot(normalize(texture2D(n1, scale * vec2(c1) / r1).rg * 2.0 - 1.0), p - C1),
      dot(normalize(texture2D(n1, scale * vec2(c2) / r1).rg * 2.0 - 1.0), p - C2),
      dot(normalize(texture2D(n1, scale * vec2(c3) / r1).rg * 2.0 - 1.0), p - C3)
    );
    return dot(w, v) / (w.x + w.y + w.z) / 0.5329;
    //return (w.x + w.y + w.z) * 0.5;
    //return min(min(length(p - c1), length(p - c2)), length(p - c3));
}

vec2 Mod(vec2 a, float b) {return MOD(a, b);}

vec3 Mod(vec3 a, float b) {return MOD(a, b);}

vec4 Mod(vec4 a, float b) {return MOD(a, b);}

voro2 voronoi( in vec2 x, mat2 dm, vec2 dv, vec2 delta, vec4 s ) {
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
        eres += exp( -FALLOUT*dis );
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
    c /= max_e(c);
    return voro2(
    	res,
		1.0 +(1.0/FALLOUT)*log( res ),
		edge,
		ray,
		c
	);
}
voro3 voronoi( in vec3 x, mat3 dm, vec3 dv, vec3 delta, vec4 s ) {
    ivec3 p = ivec3(floor( x ));
    vec3 f = fract( x );

    float res = 1.0e20;
    float res2 = 1.0e20;
    float eres = 0.0;
    ivec3 center;
    vec3 ray;
    const int range = 2;
    for( int k=-range; k<=range; k++ )
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        //ivec3 b = ivec2( i, j, k );
        //ivec3 c = b + p;
        ivec3 c = ivec3( i, j, k ) + p;
        vec3 v = rand3( vec3(c), dm, dv, delta, s );
        vec3 r = vec3(c) + v;
        vec3 d = r - x;
        float dis = length( d );

		if(dis < res) {
			center = c;
			ray = r;
		}
		res2 = min(max(res, dis), res2);
        res = min(res, dis);
        eres += exp( -FALLOUT*dis );
    }
    float edge = 1.0e20;
    for( int k=-range; k<=range; k++ )
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        //ivec3 b = ivec2( i, j, k );
        //ivec3 c = b + center;
        ivec3 c = ivec3( i, j, k ) + center;
        vec3 v = rand3( vec3(c), dm, dv, delta, s );
        vec3 r = vec3(c) + v;
        float dis = abs(dot(0.5 * (r + ray) - x, normalize(r - ray) ));

        edge = min(edge, dis);
    }
    vec3 c = rand3(vec3(center), dm, dv, delta, s);
    c /= max_e(c);
    return voro3(
    	res,
		1.0 +(1.0/FALLOUT)*log( res ),
		edge,
		ray,
		c
	);
}
voro4 voronoi( in vec4 x, mat4 dm, vec4 dv, vec4 delta, vec4 s ) {
	return voro4(0.0, 0.0, 0.0, vec4(0.0), vec3(0.0));
}

voro2 voronoi( in vec2 x, sampler2D n1, vec2 r1, float scale, float amp ) {
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
        vec2 v = (texture2D(n1, scale * vec2(c) / r1).rg - 0.5) * amp;
        vec2 r = vec2(c) + v;
        vec2 d = r - x;
        float dis = length( d );

		if(dis < res) {
			center = c;
			ray = r;
		}
		res2 = min(max(res, dis), res2);
        res = min(res, dis);
        eres += exp( -FALLOUT*dis );
    }
    float edge = 1.0e20;
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        //ivec2 b = ivec2( i, j );
        //ivec2 c = b + center;
        ivec2 c = ivec2( i, j ) + center;
        vec2 v = texture2D(n1, scale * vec2(c) / r1).rg * amp;
        vec2 r = vec2(c) + v;
        float dis = abs(dot(0.5 * (r + ray) - x, normalize(r - ray) ));

        edge = min(edge, dis);
    }
    vec3 c = vec3(0.0);
    return voro2(
    	res,
		1.0 +(1.0/FALLOUT)*log( res ),
		edge,
		ray,
		c
	);
}

mat3 promote3(mat2 m) {
	return mat3(vec3(m[0], 0.0), vec3(m[1], 0.0), vec3(0.0));
}
mat4 promote4(mat2 m) {
	return mat4(vec4(m[0], 0.0, 0.0), vec4(m[1], 0.0, 0.0), vec4(0.0), vec4(0.0));
}
mat4 promote4(mat3 m) {
	return mat4(vec4(m[0], 0.0), vec4(m[1], 0.0), vec4(m[2], 0.0), vec4(0.0));
}
vec3 promote3(vec2 v) {
	return vec3(v, 0.0);
}
vec4 promote4(vec2 v) {
	return vec4(v, 0.0, 0.0);
}
vec4 promote4(vec3 v) {
	return vec4(v, 0.0);
}

line2d Line_point_point(vec2 base, vec2 target, vec2 other) {
	vec2 vector = target - base;
	vec2 ray = normalize(vector);
	return line2d(
		base,
		target,
		(base + target) * 0.5,
		vector,
		ray,
		length(vector),
		normalize(other - base - dot(other - base, ray) * ray)
	);
}

float permute(float x, float o, float r, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); float xseed = mul(x, seed); return PERMUTER(xseed, o, r); }

vec2 permute(vec2 x, float o, float r, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec2 xseed = mul(x, seed); return PERMUTER(xseed, o, r); }

vec3 permute(vec3 x, float o, float r, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec3 xseed = mul(x, seed); return PERMUTER(xseed, o, r); }

vec4 permute(vec4 x, float o, float r, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec4 xseed = mul(x, seed); return PERMUTER(xseed, o, r); }

float lmap(vec2 v, vec2 d) { return Dot(d, v); }

float lmap(vec3 v, vec3 d) { return Dot(d, v); }

float lmap(vec4 v, vec4 d) { return Dot(d, v); }

float drawline(vec2 p, vec2 base, vec2 target, vec2 other, float thickness) {
	return drawline(p, Line_point_point(base, target, other), thickness);
}

float permute(float x, float o, float r, float seed) { x = PERMUTE(x); seed = PERMUTE(seed); float xseed = x * seed; return PERMUTER(xseed, o, r); }

vec2 permute(vec2 x, float o, float r, float seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec2 xseed = x * seed; return PERMUTER(xseed, o, r); }

vec3 permute(vec3 x, float o, float r, float seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec3 xseed = x * seed; return PERMUTER(xseed, o, r); }

vec4 permute(vec4 x, float o, float r, float seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec4 xseed = x * seed; return PERMUTER(xseed, o, r); }

float drawray(vec2 p, vec2 base, vec2 target, vec2 other, float thickness) {
	return drawray(p, Line_point_point(base, target, other), thickness);
}

mat3 translation2dAffine(vec2 shift) {
	return mat3(i3, j3, vec3(shift, 1.0));
}

float drawlinesegment(vec2 p, vec2 base, vec2 target, vec2 other, float thickness) {
	return drawlinesegment(p, Line_point_point(base, target, other), thickness);
}

mat2 rotation2d(float angle) {
	return mat2(cos(angle), sin(angle), -sin(angle), cos(angle));
}

float drawdashedlinesegment(vec2 p, vec2 base, vec2 target, vec2 other, float thickness, float freq) {
	return drawdashedlinesegment(p, Line_point_point(base, target, other), thickness, freq);
}

float curve5(float a) { a = constrain(a, 0.0, 1.0); return CURVE5(a); }

vec2 curve5(vec2 a) { a = constrain(a, 0.0, 1.0); return CURVE5(a); }

vec3 curve5(vec3 a) { a = constrain(a, 0.0, 1.0); return CURVE5(a); }

vec4 curve5(vec4 a) { a = constrain(a, 0.0, 1.0); return CURVE5(a); }

float drawcircle(vec2 p, circle2d circle, float thickness) {
	vec2 vector = p - circle.center;
	return pulse(-thickness * 0.5, thickness * 0.5, length(vector) - circle.radius);
}

float curve3(float a) { a = constrain(a, 0.0, 1.0); return CURVE3(a); }

vec2 curve3(vec2 a) { a = constrain(a, 0.0, 1.0); return CURVE3(a); }

vec3 curve3(vec3 a) { a = constrain(a, 0.0, 1.0); return CURVE3(a); }

vec4 curve3(vec4 a) { a = constrain(a, 0.0, 1.0); return CURVE3(a); }

mat3 rotation2dAffine(float angle) {
	return mat3(cos(angle), sin(angle), 0.0, -sin(angle), cos(angle), 0.0, k3);
}

parallelogram2d Rectangle_corner_size(vec2 base, vec2 size) {
	int x = size.y > size.x ? 2 : 1;
	float majorLength = x == 2 ? size.y : size.x;
	float minorLength = x == 1 ? size.y : size.x;
	vec2 majorRay = x == 2 ? j2 : i2;
	vec2 minorRay = x == 1 ? j2 : i2;
	return parallelogram2d(
		base, // base
		majorLength, // majorLength
		minorLength, // minorLength
		length(size), //diagonalLength
		majorRay, // majorRay
		minorRay, // minorRay
		normalize(size), // diagonalRay
		majorRay * majorLength, // majorVector
		minorRay * minorLength, // minorVector
		base + majorLength * majorRay, // majorCorner
		base + minorLength * minorRay, // minorCorner
		base + size, // diagonalCorner
		base + size * 0.5 // centerPoint
	);
}

float permute(float x, float seed) { x = PERMUTE(x); seed = PERMUTE(seed); float xseed = x * seed; return PERMUTE(xseed); }

vec2 permute(vec2 x, float seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec2 xseed = x * seed; return PERMUTE(xseed); }

vec3 permute(vec3 x, float seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec3 xseed = x * seed; return PERMUTE(xseed); }

vec4 permute(vec4 x, float seed) { x = PERMUTE(x); seed = PERMUTE(seed); vec4 xseed = x * seed; return PERMUTE(xseed); }

float permute(float x, float o, float r) { return PERMUTER(x, o, r); }

vec2 permute(vec2 x, float o, float r) { return PERMUTER(x, o, r); }

vec3 permute(vec3 x, float o, float r) { return PERMUTER(x, o, r); }

vec4 permute(vec4 x, float o, float r) { return PERMUTER(x, o, r); }

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

float min_e(vec2 v) { return min(v.x, v.y); }
float min_e(vec3 v) { return min(v.x, min(v.y, v.z)); }
float min_e(vec4 v) { return min(min(v.x, v.y), min(v.z, v.w)); }

float permute(float x) { return PERMUTE(x); }

vec2 permute(vec2 x) { return PERMUTE(x); }

vec3 permute(vec3 x) { return PERMUTE(x); }

vec4 permute(vec4 x) { return PERMUTE(x); }

float qmap(vec2 v, mat2 d) { return Dot(Dot(d, v), v); }

float qmap(vec3 v, mat3 d) { return Dot(Dot(d, v), v); }

float qmap(vec4 v, mat4 d) { return Dot(Dot(d, v), v); }

parallelogram2dPoint squares(vec2 p) {
	vec2 f = floor(p);
	parallelogram2d rect = Square_corner_size(f, 1.0);
	return Parallelogram2dPoint(p, rect);
}

parallelogram2dPoint diamonds(vec2 p, float size) {
	vec2 f = floor(p);
	parallelogram2d rect = Square_center_size_angle(f + 0.5, size, 3.1415926535 * 0.25);
	return Parallelogram2dPoint(p, rect);
}

triangle2d Triangle_3point(vec2 base, vec2 p1, vec2 p2) {
	vec2 centroid = (base + p1 + p2) / 3.0;
	line2d lined = Line_point_point(p1, p2, base - p2);
	line2d line1 = Line_point_point(base, p1, lined.vector);
	line2d line2 = Line_point_point(base, p2, -lined.vector);
	vec2 b0 = normalize(line1.ray + line2.ray);
	vec2 b1 = normalize(-line1.ray + lined.ray);
	vec2 b2 = normalize(-line2.ray - lined.ray);
	line2d median0 = Line_point_point(lined.midpoint, base, lined.ray);
	line2d median1 = Line_point_point(line1.midpoint, p2, line1.ray);
	line2d median2 = Line_point_point(line2.midpoint, p1, line2.ray);
	line2d pbisector0 = Line_point_point(lined.midpoint, lined.midpoint + lined.normal, lined.ray);
	line2d pbisector1 = Line_point_point(line1.midpoint, line1.midpoint + line1.normal, line1.ray);
	line2d pbisector2 = Line_point_point(line2.midpoint, line2.midpoint + line2.normal, line2.ray);
	vec2 circumcenter = intersect(pbisector1, pbisector2);
	line2d altitude0 = Line_point_point(base, base - dot(-line1.vector, lined.normal) * lined.normal, lined.ray);
	line2d altitude1 = Line_point_point(p1, p1 - dot(line1.vector, line2.normal) * line2.normal, line1.ray);
	line2d altitude2 = Line_point_point(p2, p2 - dot(line2.vector, line1.normal) * line1.normal, line2.ray);
	vec2 orthocenter = intersect(altitude1, altitude2);
	line2d abisector0 = Line_point_point(base, base + b0, lined.ray);
	line2d abisector1 = Line_point_point(p1, p1 + b1, line1.ray);
	line2d abisector2 = Line_point_point(p2, p2 + b2, line2.ray);
	vec2 incenter = intersect(abisector1, abisector2);
	circle2d incircle = circle2d(incenter, dot(incenter - base, line1.normal));
	circle2d circumcircle = circle2d(circumcenter, length(circumcenter - base));
	return triangle2d(
		base, // base
		lined, // leg0
		line1, // leg1
		line2, // leg2
		median0, // median0
		median1, // median1
		median2, // median2
		pbisector0, // pbisector0
		pbisector1, // pbisector1
		pbisector2, // pbisector2
		altitude0, // altitude0
		altitude1, // altitude1
		altitude2, // altitude2
		abisector0, // abisector0
		abisector1, // abisector1
		abisector2, // abisector2
		orthocenter, // orthocenter
		//incenter, // incenter
		//circumcenter, // circumcenter
		centroid, // centroid
		incircle,
		circumcircle
	);
}

triangle2dPoint Triangle2dPoint(vec2 p, triangle2d tri) {
	vec2 vector = p - tri.base;
	mat2 A = transpose(mat2(tri.leg1.vector, tri.leg2.vector));
	mat2 i = inverse(A);
	vec2 coord = i * vector;
	return triangle2dPoint (
		tri, // tri
		p, // point
		vector, // vector
		coord, // coord
		vec3(0.0), // baryocentric
		length(vector), // distance
		length(p - tri.leg1.target), // majorDistance
		length(p - tri.leg2.target), // minorDistance
		0, // inside
		ivec3(0) // placement
	);
}