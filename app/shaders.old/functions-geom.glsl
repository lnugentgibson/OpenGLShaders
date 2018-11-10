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

mat3 translation2dAffine(vec2 shift) {
	return mat3(i3, j3, vec3(shift, 1.0));
}

mat2 rotation2d(float angle) {
	return mat2(cos(angle), sin(angle), -sin(angle), cos(angle));
}

mat3 rotation2dAffine(float angle) {
	return mat3(cos(angle), sin(angle), 0.0, -sin(angle), cos(angle), 0.0, k3);
}
