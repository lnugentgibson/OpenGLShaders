precision mediump float;

uniform vec2 u_resolution;
uniform float u_scale;
uniform mat2 u_qseed;
uniform vec2 u_lseed;
uniform vec4 u_rseed;
uniform vec2 u_amp;

%DIM%
%MISC%
%POLYFILL%
%MAP%
%GEOM%
%SHAPES%
%TESSELATIONS%
%SINERAND%

#define rand sinfract

%RAND%

vec2 squareCenter(vec2 c, ivec2 i) {
	vec2 r = rand2(vec2(i), u_qseed, u_lseed, vec2(10.0, 10.0), u_rseed) * 2.0 - 1.0;
	return c + u_amp.x * r;
}

struct tri2d {
	vec2 c0;
	vec2 c1;
	vec2 c2;
	vec2 c3;
};

vec2 triCenter(tri2d t, ivec2 i) {
	vec3 r = rand3(vec2(i), u_qseed, u_lseed, vec2(10.0, 10.0), u_rseed);
	r /= sum_e(r);
	r = mix(vec3(1.0 / 3.0), r, u_amp.y);
	return demote2(mat3(t.c1, 0.0, t.c2, 0.0, t.c3, 0.0) * r);
}

tri2d Tri2d() {
	return tri2d(o2, o2, o2, o2);
}

void main() {
	vec2 center = vec2( u_scale * 0.5);
	vec2 uv = gl_FragCoord.xy;
	uv /= u_resolution;
	uv *= u_scale;
	float dis = 0.0;
	const int range = 4;
	float fr = float(range), fr2 = fr * fr;
	for(int i = 0; i < range; i++)
	for(int j = 0; j < range; j++) {
		vec2 shift = vec2(0.5 / fr) + vec2(ivec2(i, j)) / fr - 0.5;
		shift *= u_scale / u_resolution;
		vec2 p = uv + shift;

		vec2 bF = floor(p);
		ivec2 bf = ivec2(bF);

		//vec2 mp;
		float md = 1.0e20;
		for(int ix = -1; ix <= 1; ix++)
		for(int iy = -1; iy <= 1; iy++) {
			vec2 F = bF + vec2(ivec2(ix, iy));
			ivec2 f = bf + ivec2(ix, iy);
			int d = f.x + f.y, q = d - 2 * (d / 2);
			mat3 trans = (sqrt(3.0) + 1.0) * 0.5 * rotation2dAffine((q > 0 ? 1.0 : -1.0) * 3.1415926535 / 6.0) * 2.0 * translation2dAffine(-F - 0.5);
			vec2 pp = demote2(trans * vec3(p, 1.0));
			float i = 0.0;
			tri2d t1 = Tri2d(), t2 = Tri2d(), t3 = Tri2d(), t4 = Tri2d();

			if(q == 0) {
				t3.c2 = vec2(-1.0, 1.0);
				t3.c3 = vec2(-1.0, -1.0);
				t3.c1 = 0.5 * (sqrt(3.0) + 1.0) * (t3.c2 + t3.c3);
			}
			else {
				t3.c1 = vec2(-1.0, -1.0);
				t3.c3 = vec2(-1.0, 1.0);
				t3.c2 = 0.5 * (sqrt(3.0) + 1.0) * (t3.c1 + t3.c3);
			}
			t3.c0 = (t3.c1 + t3.c2 + t3.c3) / 3.0;
			t1.c1 = vec2(1.0, -1.0);
			t1.c2 = vec2(1.0, 1.0);
			t1.c3 = 0.5 * (sqrt(3.0) + 1.0) * (t1.c1 + t1.c2);
			t1.c0 = (t1.c1 + t1.c2 + t1.c3) / 3.0;
			if(q == 0) {
				t4.c1 = vec2(-1.0, -1.0);
				t4.c3 = vec2(1.0, -1.0);
				t4.c2 = 0.5 * (sqrt(3.0) + 1.0) * (t4.c1 + t4.c3);
			}
			else {
				t4.c2 = vec2(1.0, -1.0);
				t4.c3 = vec2(-1.0, -1.0);
				t4.c1 = 0.5 * (sqrt(3.0) + 1.0) * (t4.c2 + t4.c3);
			}
			t4.c0 = (t4.c1 + t4.c2 + t4.c3) / 3.0;
			t2.c1 = vec2(-1.0, 1.0);
			t2.c2 = vec2(1.0, 1.0);
			t2.c3 = 0.5 * (sqrt(3.0) + 1.0) * (t2.c1 + t2.c2);
			t2.c0 = (t2.c1 + t2.c2 + t2.c3) / 3.0;
			float cd = length(pp - squareCenter(o2, f));
			cd = min(cd, length(pp - triCenter(t1, 3 * f + ivec2(3, 2 - q))));
			cd = min(cd, length(pp - triCenter(t2, 3 * f + ivec2(1 + q, 3))));
			cd = min(cd, length(pp - triCenter(t3, 3 * f + ivec2(0, 1 + q))));
			cd = min(cd, length(pp - triCenter(t4, 3 * f + ivec2(2 - q, 0))));
			md = min(md, cd);
		}
		dis += md / fr2;
	}
	dis *= 0.75;
	//gl_FragColor = vec4(vec3(mix(dis, 1.0, 1.0 - smoothstep(0.0, 0.1, dis))), 1.0);
	gl_FragColor = vec4(vec3(dis), 1.0);
}
