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

mat3 colExclusion(mat3 m, int c) {
	return mat3(c == 0 ? m[1] : m[0], c == 2 ? m[1] : m[2], o3);
}

mat4 colExclusion(mat4 m, int c) {
	return mat4(c == 0 ? m[1] : m[0], c > 1 ? m[1] : m[2], c == 3 ? m[2] : m[3], o4);
}

mat2 exclusionTranspose(mat3 m, int r, int c) {
	return demote2(colExclusion(transpose(colExclusion(m, c)), r));
}

mat3 exclusionTranspose(mat4 m, int r, int c) {
	return demote3(colExclusion(transpose(colExclusion(m, c)), r));
}

mat2 exclusion(mat3 m, int r, int c) {
	return transpose(demote2(colExclusion(transpose(colExclusion(m, c)), r)));
}

mat3 exclusion(mat4 m, int r, int c) {
	return transpose(demote3(colExclusion(transpose(colExclusion(m, c)), r)));
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
