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

#define CASTFUNC(f, to, t1, t2) to f(t2 x) { return f(t1(x)); }

#define REDE(t) float red_e(t v, float f) { return Dot(v, t(f)); }
REDE(vec2)
REDE(vec3)
REDE(vec4)
#define SUME(t) float sum_e(t v) {return red_e(v, 1.0);}
SUME(vec2)
SUME(vec3)
SUME(vec4)
CASTFUNC(sum_e, float, vec2, ivec2)
CASTFUNC(sum_e, float, vec3, ivec3)
CASTFUNC(sum_e, float, vec4, ivec4)
float prod_e(vec2 v) {return v.x * v.y;}
float prod_e(vec3 v) {return v.x * v.y * v.z;}
float prod_e(vec4 v) {return v.x * v.y * v.z * v.w;}
CASTFUNC(prod_e, float, vec2, ivec2)
CASTFUNC(prod_e, float, vec3, ivec3)
CASTFUNC(prod_e, float, vec4, ivec4)

float max_e(vec2 v) { return max(v.x, v.y); }
float max_e(vec3 v) { return max(v.x, max(v.y, v.z)); }
float max_e(vec4 v) { return max(max(v.x, v.y), max(v.z, v.w)); }
float min_e(vec2 v) { return min(v.x, v.y); }
float min_e(vec3 v) { return min(v.x, min(v.y, v.z)); }
float min_e(vec4 v) { return min(min(v.x, v.y), min(v.z, v.w)); }

#define MOD(a, b) (a - floor(a / b) * b)
#define MODFUNC(t1, t2) t1 Mod(t1 a, t2 b) {return MOD(a, b);}
MODFUNC(float, float)
MODFUNC(vec2, float)
MODFUNC(vec2, vec2)
MODFUNC(vec3, float)
MODFUNC(vec3, vec3)
MODFUNC(vec4, float)
MODFUNC(vec4, vec4)

#define CONSTRAIN(t) t constrain(t v, float n, float x) { return max(min(v, x), n); }
CONSTRAIN(float)
CONSTRAIN(vec2)
CONSTRAIN(vec3)
CONSTRAIN(vec4)

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

float pulse(float n, float x, float a) {
	return step(n, a) - step(x, a);
}

float smoothpulse(float nn, float nx, float xn, float xx, float a) {
	return smoothstep(nn, nx, a) - smoothstep(xn, xx, a);
}
