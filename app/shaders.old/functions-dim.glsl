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
