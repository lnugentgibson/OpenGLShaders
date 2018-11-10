precision mediump float;

uniform vec2 u_resolution;
uniform float u_granularity;
uniform float u_scale;
uniform int u_samples;
uniform mat2 u_qseed;
uniform vec2 u_lseed;
uniform vec4 u_rseed;

%DIM%
%MISC%
%MAP%
%SINERAND%

#define rand sinfract

%RAND%
%CURVES%

#define CURVE CURVE3
#define FALLOUT 1.0

%VORONOI%

void main() {
  vec2 UV = gl_FragCoord.xy, uv = UV, uvi;
  if(u_granularity > 1.0) {
    uv = floor(UV / u_granularity) * u_granularity;
    uvi = (UV - uv) / u_granularity;
  }
  uv /= u_resolution;
  uv *= u_scale;
  mat3 dm3 = mat3(
    sqrt(5.0) / 3.0, sqrt(2.0) / 1.5, sqrt(63.0) / 8.2,
    sqrt(7.0) / 2.0, sqrt(3.0) / 1.8, sqrt(137.0) / 11.8,
    0.0, 0.0, 0.0
  );
  vec3 dv3 = vec3(sqrt(11.0) / 3.2, sqrt(15.0) / 4.0, 1.0);
  vec4 s = vec4(1518.367, 34.347, 184.536, 363.5773);
  float factor = 1.0 / float(u_samples);
  vec3 c = vec3(0.0);
  for(int i = 0; i < 20; i++)
    if(i < u_samples) {
      vec2 shift = rand2(vec3(uv, float(i)), dm3, dv3, vec3(0.0, 0.0, 0.5), s) * u_scale / u_resolution;
      c += voronoi(uv + shift, u_qseed, u_lseed, vec2(10.0, 10.0), u_rseed).dis * factor;
    }
  gl_FragColor = vec4(c, 1.0);
}
