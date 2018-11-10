precision mediump float;

uniform vec2 u_resolution;
uniform float u_scale;
uniform mat2 u_qseed;
uniform vec2 u_lseed;
uniform vec4 u_rseed;

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

vec2 squareCenter(vec2 c, ivec2 i, float amp) {
	vec2 r = rand2(vec2(i), u_qseed, u_lseed, vec2(10.0, 10.0), u_rseed) * 2.0 - 1.0;
	return c + amp * r;
}

struct tri2d {
	vec2 c0;
	vec2 c1;
	vec2 c2;
	vec2 c3;
};

vec2 triCenter(tri2d t, ivec2 i, float amp) {
	vec3 r = rand3(vec2(i), u_qseed, u_lseed, vec2(10.0, 10.0), u_rseed);
	r /= sum_e(r);
	r = mix(vec3(1.0 / 3.0), r, amp);
	return demote2(mat3(t.c1, 0.0, t.c2, 0.0, t.c3, 0.0) * r);
}

tri2d Tri2d() {
	return tri2d(o2, o2, o2, o2);
}

vec3 squaremix(vec3 ic, vec2 p, vec2 c, vec2 c1, ivec2 f, float amp) {
	vec2 c2 = vec2(-c1.y, c1.x), c3 = -c1, c4 = -c2;
	vec3 oc = mix(ic, i3, 1.0 - smoothstep(0.09, 0.11, length(p - c)));
	oc = mix(oc, 1.0 - i3, 1.0 - smoothstep(0.09, 0.11, length(p - c - c1)));
	oc = mix(oc, 1.0 - i3, 1.0 - smoothstep(0.09, 0.11, length(p - c - c2)));
	oc = mix(oc, 1.0 - i3, 1.0 - smoothstep(0.09, 0.11, length(p - c - c3)));
	oc = mix(oc, 1.0 - i3, 1.0 - smoothstep(0.09, 0.11, length(p - c - c4)));
	oc = mix(oc, o3, 1.0 - smoothstep(0.045, 0.055, length(p - squareCenter(c, f, amp))));
	oc = mix(oc, 1.0 - i3, drawlinesegment(p, c + c1, c + c2, c, 0.05));
	oc = mix(oc, 1.0 - i3, drawlinesegment(p, c + c2, c + c3, c, 0.05));
	oc = mix(oc, 1.0 - i3, drawlinesegment(p, c + c3, c + c4, c, 0.05));
	oc = mix(oc, 1.0 - i3, drawlinesegment(p, c + c4, c + c1, c, 0.05));
	return oc;
}

vec3 trimix(vec3 ic, vec2 p, tri2d t, ivec2 f, float amp) {
	vec3 oc = mix(ic, j3, 1.0 - smoothstep(0.09, 0.11, length(p - t.c0)));
	oc = mix(oc, 1.0 - j3, 1.0 - smoothstep(0.045, 0.055, length(p - t.c1)));
	oc = mix(oc, 1.0 - j3, 1.0 - smoothstep(0.045, 0.055, length(p - t.c2)));
	oc = mix(oc, 1.0 - j3, 1.0 - smoothstep(0.045, 0.055, length(p - t.c3)));
	oc = mix(oc, o3, 1.0 - smoothstep(0.045, 0.055, length(p - triCenter(t, f, amp))));
	oc = mix(oc, i3, drawlinesegment(p, t.c1, (t.c1 + t.c0) * 0.5, t.c2, 0.05));
	oc = mix(oc, j3, drawlinesegment(p, t.c2, (t.c2 + t.c0) * 0.5, t.c3, 0.05));
	oc = mix(oc, k3, drawlinesegment(p, t.c3, (t.c3 + t.c0) * 0.5, t.c1, 0.05));
	oc = mix(oc, 1.0 - j3, drawdashedlinesegment(p, t.c1, t.c2, t.c0, 0.025, 20.0));
	oc = mix(oc, 1.0 - j3, drawdashedlinesegment(p, t.c2, t.c3, t.c0, 0.025, 20.0));
	oc = mix(oc, 1.0 - j3, drawdashedlinesegment(p, t.c3, t.c1, t.c0, 0.025, 20.0));
	return oc;
}

void main() {
	float samp = 1.0, tamp = 1.0;
	vec2 uv = gl_FragCoord.xy;
	uv /= u_resolution;
	uv *= u_scale;

	vec2 center = vec2( u_scale * 0.5);

	float dis = 0.0;
	vec2 coord = vec2(0.0);
	vec3 color = vec3(0.0), corner = vec3(0.0);

	const int range = 4;
	float fr = float(range), fr2 = fr * fr;
	for(int i = 0; i < range; i++)
	for(int j = 0; j < range; j++) {
		vec2 shift = vec2(0.5 / fr) + vec2(ivec2(i, j)) / fr - 0.5;
		shift *= u_scale / u_resolution;
		vec2 p = uv + shift;

		float radius = length(p - center);
		vec3 c = mix(j3 * 0.5 + 0.5, i3 * 0.5 + 0.5, smoothstep(0.2, 2.0, radius));

		vec2 F = vec2(2.0, 2.0);
		F = vec2(2.0, 1.0);
		p -= j2;
		ivec2 f = ivec2(F);
		int d = f.x + f.y, q = d - 2 * (d / 2);

		mat3 trans = (sqrt(3.0) + 1.0) * 0.5 * rotation2dAffine((q > 0 ? 1.0 : -1.0) * 3.1415926535 / 6.0) * 2.0 * translation2dAffine(-F - 0.5);
		mat3 inv = inverse(trans);
		vec3 pp3 = trans * vec3(p, 1.0);
		vec2 pp = pp3.xy;

		float i = 0.0;
		tri2d t0 = Tri2d(), t1 = Tri2d(), t2 = Tri2d(), t3 = Tri2d(), t4 = Tri2d(), tp = Tri2d(), tm = Tri2d();
		vec2 sm;
		ivec2 I, I1, I2, I3, I4, Im, fm;

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
		if(pp.x < -1.0 && (q == 0 && pp.y <= 1.0 || q == 1 && pp.y >= -1.0)) {
			t0 = t3;
			i = 1.0;
			I = I3 = ivec2(0, 1 + q);
			tp.c1 = q == 0 ? t0.c3 : t0.c2;
			tp.c2 = q == 0 ? t0.c1 : t0.c3;
			tp.c3 = tp.c1 + tp.c2 - (q == 0 ? t0.c2 : t0.c1);
			tm.c1 = q == 0 ? tp.c3 : tp.c1;
			tm.c2 = q == 0 ? tp.c2 : tp.c3;
			tm.c3 = q == 0 ? tp.c1 : tp.c2;
			Im = ivec2(0, q * 5 - 1);
			fm = f + ivec2(0, 2 * q - 1);
		}
		t1.c1 = vec2(1.0, -1.0);
		t1.c2 = vec2(1.0, 1.0);
		t1.c3 = 0.5 * (sqrt(3.0) + 1.0) * (t1.c1 + t1.c2);
		t1.c0 = (t1.c1 + t1.c2 + t1.c3) / 3.0;
		if(pp.x > 1.0 && (q == 1 && pp.y <= 1.0 || q == 0 && pp.y >= -1.0)) {
			t0 = t1;
			i = 1.0;
			I = I1 = ivec2(3, 2 - q);
			tp.c1 = q == 0 ? t0.c2 : t0.c3;
			tp.c2 = q == 0 ? t0.c3 : t0.c1;
			tp.c3 = tp.c1 + tp.c2 - (q == 0 ? t0.c1 : t0.c2);
			tm.c1 = q == 0 ? tp.c1 : tp.c3;
			tm.c2 = q == 0 ? tp.c3 : tp.c2;
			tm.c3 = q == 0 ? tp.c2 : tp.c1;
			Im = ivec2(3, q * 5 - 1);
			fm = f + ivec2(0, 2 * q - 1);
		}
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
		if(pp.y < -1.0 && (q == 1 && pp.x <= 1.0 || q == 0 && pp.x >= -1.0)) {
			t0 = t4;
			i = 1.0;
			I = I4 = ivec2(2 - q, 0);
			tp.c1 = q == 0 ? t0.c2 : t0.c3;
			tp.c2 = q == 0 ? t0.c3 : t0.c1;
			tp.c3 = tp.c1 + tp.c2 - (q == 0 ? t0.c1 : t0.c2);
			tm.c1 = q == 0 ? tp.c1 : tp.c3;
			tm.c2 = q == 0 ? tp.c3 : tp.c2;
			tm.c3 = q == 0 ? tp.c2 : tp.c1;
			Im = ivec2(4 - q * 5, 0);
			fm = f + ivec2(1 - 2 * q, 0);
		}
		t2.c1 = vec2(-1.0, 1.0);
		t2.c2 = vec2(1.0, 1.0);
		t2.c3 = 0.5 * (sqrt(3.0) + 1.0) * (t2.c1 + t2.c2);
		t2.c0 = (t2.c1 + t2.c2 + t2.c3) / 3.0;
		if(pp.y > 1.0 && (q == 0 && pp.x <= 1.0 || q == 1 && pp.x >= -1.0)) {
			t0 = t2;
			i = 1.0;
			I = I2 = ivec2(1 + q, 3);
			tp.c1 = q == 0 ? t0.c3 : t0.c2;
			tp.c2 = q == 0 ? t0.c1 : t0.c3;
			tp.c3 = tp.c1 + tp.c2 - (q == 0 ? t0.c2 : t0.c1);
			tm.c1 = q == 0 ? tp.c3 : tp.c1;
			tm.c2 = q == 0 ? tp.c2 : tp.c3;
			tm.c3 = q == 0 ? tp.c1 : tp.c2;
			Im = ivec2(q * 5 - 1, 3);
			fm = f + ivec2(2 * q - 1, 0);
		}
		if(i < 0.5) {
			//vec2 v = pp + 0.5;
			float d = length(pp - squareCenter(o2, f, samp));
			d = min(d, length(pp - triCenter(t1, 3 * f + ivec2(3, 2 - q), tamp)));
			d = min(d, length(pp - triCenter(t2, 3 * f + ivec2(1 + q, 3), tamp)));
			d = min(d, length(pp - triCenter(t3, 3 * f + ivec2(0, 1 + q), tamp)));
			d = min(d, length(pp - triCenter(t4, 3 * f + ivec2(2 - q, 0), tamp)));
			d = mix(d, float(q), 1.0 - step(0.2, length(pp)));
			dis += d / fr2;
			coord += (pp * 0.5 + 0.5) * min(1.0, d * 4.0) / fr2;
		}
		else {
			tm.c0 = (tm.c1 + tm.c2 + tm.c3) / 3.0;
			vec2 del = normalize(tm.c1 - tm.c2);
			sm = 2.0 * (tm.c1 + del * dot(del, -tm.c1));
			float d = length(pp - triCenter(t0, 3 * f + I, tamp));
			d = min(d, length(pp - triCenter(tm, 3 * f + Im, tamp)));
			d = min(d, length(pp - squareCenter(o2, f, samp)));
			d = min(d, length(pp - squareCenter(sm, fm, samp)));
			dis += d / fr2;
			coord += inverse(transpose(mat2(t0.c2 - t0.c1, t0.c3 - t0.c1))) * (pp - t0.c1) * min(1.0, d * 4.0) / fr2;
			vec3 cn = vec3(
				1.0 - smoothstep(0.19, 0.21, length(pp - t0.c1)),
			1.0 - smoothstep(0.19, 0.21, length(pp - t0.c2)),
			1.0 - smoothstep(0.19, 0.21, length(pp - t0.c3))
		);
			if(q > 0)
				cn = mix(cn, 1.0 - cn, step(0.2, length(cn)));
			corner += cn / fr2;
		}

		//c = mix(c, i3, 1.0 - smoothstep(0.09, 0.11, length(pp)));
		//c = mix(c, 1.0 - i3, 1.0 - smoothstep(0.09, 0.11, length(pp - i2 - j2)));
		//c = mix(c, 1.0 - i3, 1.0 - smoothstep(0.09, 0.11, length(pp - i2 + j2)));
		//c = mix(c, 1.0 - i3, 1.0 - smoothstep(0.09, 0.11, length(pp + i2 - j2)));
		//c = mix(c, 1.0 - i3, 1.0 - smoothstep(0.09, 0.11, length(pp + i2 + j2)));
		//c = mix(c, o3, 1.0 - smoothstep(0.045, 0.055, length(pp - squareCenter(o2, f, samp))));
		c = squaremix(c, pp, o2, vec2(1.0), f, samp);
		c = trimix(c, pp, t1, 3 * f + I1, tamp);
		c = trimix(c, pp, t2, 3 * f + I2, tamp);
		c = trimix(c, pp, t3, 3 * f + I3, tamp);
		c = trimix(c, pp, t4, 3 * f + I4, tamp);
		if(i > 0.5)
			c = trimix(c, pp, tm, 3 * f + Im, tamp);

		color += c / fr2;
	}
	gl_FragColor = vec4(coord, 0.0, 1.0);
	gl_FragColor = vec4(vec3(dis * 0.75), 1.0);
	float vp = 1.0 - smoothstep(0.0, 0.1, dis);
	vec3 c3 = vec3(coord, 0.0), d3 = vec3(mix(dis * 0.75, 1.0, vp)), cd = mix(c3, d3, 1.0);
	gl_FragColor = vec4(mix(cd, corner, 0.0 * step(0.2, length(corner))), 1.0);
	gl_FragColor = vec4(color, 1.0);
}
