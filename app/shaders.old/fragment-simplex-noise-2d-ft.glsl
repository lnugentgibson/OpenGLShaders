precision mediump float;

uniform vec2 u_resolution;
uniform float u_granularity;
uniform float u_scale;
uniform int u_samples;
uniform sampler2D u_tex_0;
uniform vec2 u_tex_0_res;
uniform float u_tex_scale;

%DIM%
%MISC%
%GEOM%
%MAP%
%SINERAND%

#define rand sinfract

%RAND%
%CURVES%

#define CURVE CURVE3

%SIMPLEX%

#define NOISE simplexGradient

void position(inout vec2 coord, vec2 res, float scale) {
  coord /= res;
  coord *= scale;
}
vec3 pixel(vec2 uv) {
  float v1 = 0.0;
  float factor = float(u_samples);
  float factor2 = factor * factor;
  for(int i = 0; i < 16; i++)
  for(int j = 0; j < 16; j++) {
    if(i < u_samples && j < u_samples) {
      vec2 shift = 0.5 / factor + vec2(ivec2(i, j)) / factor2 - 0.5;
      v1 += NOISE(uv + shift * u_scale / u_resolution, u_tex_0, u_tex_0_res, u_tex_scale) / factor2;
    }
  }
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
