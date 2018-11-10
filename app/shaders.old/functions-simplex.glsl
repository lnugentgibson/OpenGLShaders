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
    //return (w.x + w.y + w.z) * 0.5;
    //return min(min(length(p - c1), length(p - c2)), length(p - c3));
}

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
