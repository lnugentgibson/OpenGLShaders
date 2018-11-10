precision mediump float;

uniform vec2 u_resolution;
uniform float u_granularity;
uniform float u_scale;
uniform int u_samples;
uniform sampler2D u_tex_0;
uniform vec2 u_tex_0_res;
uniform float u_tex_scale;
uniform float u_voro_amp;

#define FALLOUT 1.0

%voronoift1{randtype:0}%

void position(inout vec2 coord, vec2 res, float scale, out vec3 coord3) {
  coord /= res;
  coord *= scale;
  coord3 = vec3(coord, 0.0);
}
vec3 pixel(vec2 uv) {
  vec3 c;
  voro2 voro = voronoi(uv, u_tex_0, u_tex_0_res, u_tex_scale, u_voro_amp);
  c = vec3(voro.dis);
  return c;
}
void main() {
  vec2 UV = gl_FragCoord.xy, uv = UV, uvi;
  if(u_granularity > 1.0) {
    uv = floor(UV / u_granularity) * u_granularity;
    uvi = (UV - uv) / u_granularity;
  }
  vec3 uv3;
  position(uv, u_resolution, u_scale, uv3);
  vec3 c = vec3(0.0);
  float factor = 1.0 / float(u_samples);
  for(int i = 0; i < 20; i++)
    if(i < u_samples) {
      vec2 shift = vec2(0.0) * u_scale / u_resolution;
      c += pixel(uv + shift) * factor;
    }
  gl_FragColor = vec4(c, 1.0);
}
