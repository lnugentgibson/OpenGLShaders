precision mediump float;

uniform vec2 u_resolution;
uniform float u_scale;
uniform vec2 u_p0;
uniform vec2 u_p1;
uniform vec2 u_p2;

%DIM%
%MISC%
%GEOM%
%POLYFILL%
%SHAPES%

void main() {
  triangle2d tri = Triangle_3point(u_p0, u_p1, u_p2);

  vec2 center = vec2( u_scale * 0.5);
  vec2 uv = gl_FragCoord.xy;
  uv /= u_resolution;
  uv *= u_scale;
  vec3 color = vec3(0.0);
  const int range = 16;
  float fr = float(range), fr2 = fr * fr;
  for(int i = 0; i < range; i++)
  for(int j = 0; j < range; j++) {
    vec2 shift = (vec2(ivec2(i, j)) + 0.5) / fr;
    shift *= u_scale / u_resolution;
    vec2 p = uv + shift;

    float radius = length(p - center);
    vec2 vector = p - u_p0;

    vec3 c = mix(
    	mix(
    		vec3(1.0, 0.0, 0.0),
			vec3(0.0, 1.0, 0.0),
			smoothstep(0.125, sqrt(2.0) * u_scale * 0.625, radius)
		)
		, vec3(1.0)
		, 0.5
    );

    vec3 d = vec3(length(p - u_p0), length(p - u_p1), length(p - u_p2));
    float d3 = min_e(d);
    vec3 md = vec3(length(p - tri.leg0.midpoint), length(p - tri.leg1.midpoint), length(p - tri.leg2.midpoint));
    float md2 = min_e(md);

    c = mix(vec3(0.0), c, 1.0 - max(drawlinesegment(p, tri.leg0, 0.05), max(drawlinesegment(p, tri.leg1, 0.05), drawlinesegment(p, tri.leg2, 0.05))));
    c = mix(vec3(0.0, 0.0, 1.0), c, 1.0 - max(drawlinesegment(p, tri.median0, 0.05), max(drawlinesegment(p, tri.median1, 0.05), drawlinesegment(p, tri.median2, 0.05))));
    c = mix(vec3(0.0, 1.0, 0.0), c, 1.0 - max(drawray(p, tri.pbisector0, 0.05), max(drawray(p, tri.pbisector1, 0.05), drawray(p, tri.pbisector2, 0.05))));
    c = mix(vec3(1.0, 1.0, 0.0), c, 1.0 - max(drawlinesegment(p, tri.altitude0, 0.05), max(drawlinesegment(p, tri.altitude1, 0.05), drawlinesegment(p, tri.altitude2, 0.05))));
    c = mix(vec3(0.5, 0.5, 1.0), c, 1.0 - max(drawray(p, tri.abisector0, 0.05), max(drawray(p, tri.abisector1, 0.05), drawray(p, tri.abisector2, 0.05))));
    c = mix(vec3(1.0, 0.0, 1.0), c, smoothstep(0.04, 0.05, length(p - tri.circumcircle.center)));
    c = mix(vec3(1.0, 0.0, 1.0), c, 1.0 - drawcircle(p, tri.circumcircle, 0.05));
    c = mix(vec3(1.0, 0.5, 0.0), c, smoothstep(0.04, 0.05, length(p - tri.orthocenter)));
    c = mix(vec3(1.0, 0.5, 0.5), c, smoothstep(0.04, 0.05, length(p - tri.incircle.center)));
    c = mix(vec3(1.0, 0.5, 0.5), c, 1.0 - drawcircle(p, tri.incircle, 0.05));
    c = mix(vec3(1.0, 0.0, 1.0), c, smoothstep(0.04, 0.05, md2));
    c = mix(vec3(0.8, 0.0, 1.0), c, smoothstep(0.09, 0.10, d3));
    c = mix(vec3(0.0, 1.0, 1.0), c, smoothstep(0.04, 0.05, length(p - tri.centroid)));

    color += c / fr2;
  }
  //vec3 c1 = mix(vec3(0.0, 0.0, 0.0), mix(vec3(0.0), background, v1b), v1a);
  gl_FragColor = vec4(color, 1.0);
}
