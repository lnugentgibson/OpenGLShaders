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
