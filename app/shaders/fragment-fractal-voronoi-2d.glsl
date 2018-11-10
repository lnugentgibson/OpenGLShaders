precision mediump float;

uniform vec2 u_resolution;
uniform float u_granularity;
uniform float u_scale;
uniform int u_iterations;
uniform mat2 u_qseed;
uniform vec2 u_lseed;
uniform vec4 u_rseed;

#define NOISE voronoi
#define NOISEGET(x) x.dis

%COMMON%

void position(inout vec2 coord, vec2 res, float scale) {
  coord /= res;
  coord *= scale;
}
vec3 pixel(vec2 uv, mat2 dm, vec2 dv, vec4 s) {
  mat2 ss = mat2(2.0, 0.0, 0.0, 2.0) * mat2(cos(0.2), sin(0.2), -sin(0.2), cos(0.2));
  vec2 d1 = vec2(10.0, 10.0);
  vec2 d2 = vec2(-5.0, -5.0);
  return vec3(fbm(uv, u_iterations, ss, 0.5, dm, dv, d1, d2, s) * 0.5 + 0.5);
}
void main() {
  vec2 UV = gl_FragCoord.xy, uv = UV, uvi;
  if(u_granularity > 1.0) {
    uv = floor(UV / u_granularity) * u_granularity;
    uvi = (UV - uv) / u_granularity;
  }
  position(uv, u_resolution, u_scale);
  gl_FragColor = vec4(pixel(uv, u_qseed, u_lseed, u_rseed), 1.0);
}
