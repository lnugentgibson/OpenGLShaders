precision mediump float;

uniform vec2 u_resolution;
uniform float u_granularity;
uniform mat3 u_qseed;
uniform vec3 u_lseed;
uniform vec4 u_rseed;
uniform float u_time;
uniform float u_time_scale;

%DIM%
%MAP%
%SINERAND%

#define rand sinfract

%RAND%

void main() {
  vec2 UV = gl_FragCoord.xy, uv = UV, uvi;
  if(u_granularity > 1.0) {
    uv = floor(UV / u_granularity) * u_granularity;
    uvi = (UV - uv) / u_granularity;
  }
  vec3 uv3 = vec3(uv, u_time * u_time_scale);
  gl_FragColor = vec4(vec3(rand1(uv3, u_qseed, u_lseed, u_rseed)), 1.0);
}
