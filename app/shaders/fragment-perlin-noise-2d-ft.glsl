precision mediump float;

uniform vec2 u_resolution;
uniform float u_granularity;
uniform float u_scale;
uniform sampler2D u_tex_0;
uniform vec2 u_tex_0_res;
uniform float u_tex_scale;

%perlinft1{randtype:0,curvetype:1}%

void position(inout vec2 coord, vec2 res, float scale) {
  coord /= res;
  coord *= scale;
}
vec3 pixel(vec2 uv) {
  float v1 = perlinGradient(uv, u_tex_0, u_tex_0_res, u_tex_scale);
  v1 = v1 * 0.5 + 0.5;
  return vec3(v1);
}
void main() {
  vec2 UV = gl_FragCoord.xy, uv = UV, uvi;
  if(u_granularity > 1.0) {
    uv = floor(UV / u_granularity) * u_granularity;
    uvi = (UV - uv) / u_granularity;
  }
  position(uv, u_resolution, u_scale);
  gl_FragColor = vec4(pixel(uv), 1.0);
}
