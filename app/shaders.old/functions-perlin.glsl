#define PERLININNER(t, rf, p, r, f, F, b, o) t B = 1.0 - b; t R = r + b; t v = rf(R, dm, dv, delta, s) * 2.0 - 1.0; v /= length(v); o += dot(v, p - R) * CURVE(prod_e(b * f + B * F));

float perlinGradient(vec2 p, mat2 dm, vec2 dv, vec2 delta, vec4 s) {
    vec2 r = floor(p);
    vec2 f = CURVE(fract(p)), F = 1.0 - f;
    float o = 0.0;
    for(float i = 0.0; i < 2.0; i++)
    for(float j = 0.0; j < 2.0; j++) {
        vec2 b = vec2(i, j);
        PERLININNER(vec2, rand2, p, r, f, F, b, o)
    }
    return o / 0.5625;
}

float perlinGradient(vec2 p, sampler2D n1, vec2 r1, sampler2D n2, vec2 r2) {
    vec2 r = floor(p);
    vec2 f = CURVE(fract(p)), F = 1.0 - f;
    float o = 0.0;
    for(float i = 0.0; i < 2.0; i++)
    for(float j = 0.0; j < 2.0; j++) {
        vec2 b = vec2(i, j);
        vec2 B = 1.0 - b;
        vec2 R = r + b;
        vec2 v = vec2(texture2D(n1, R / r1).r, texture2D(n2, R / r2).r) * 2.0 - 1.0;
        v /= length(v);
        o += dot(v, p - R) * CURVE(prod_e(b * f + B * F));
    }
    float x = texture2D(n1, r / r1).r;
    float y = texture2D(n2, r / r2).r;
    vec2 v = vec2(x, y) * 2.0 - 1.0;
    v /= length(v);
    //return o / 0.5625;
    //return v.x - v.y;
    return f.y > 0.5 ? (f.x > 0.5 ? v.y : v.x) : (f.x > 0.5 ? y : x);
}

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

float perlinGradient(vec3 p, mat3 dm, vec3 dv, vec3 delta, vec4 s) {
    vec3 r = floor(p);
    vec3 f = CURVE(fract(p)), F = 1.0 - f;
    float o = 0.0;
    for(float i = 0.0; i < 2.0; i++)
    for(float j = 0.0; j < 2.0; j++)
    for(float k = 0.0; k < 2.0; k++) {
        vec3 b = vec3(i, j, k);
        PERLININNER(vec3, rand3, p, r, f, F, b, o)
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
        PERLININNER(vec4, rand4, p, r, f, F, b, o)
    }
    return o;
}
