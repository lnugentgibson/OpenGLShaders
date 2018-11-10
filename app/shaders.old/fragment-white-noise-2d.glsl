precision mediump float;

uniform float u_granularity;
uniform mat2 u_qseed;
uniform vec2 u_lseed;
uniform vec4 u_rseed;

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
  gl_FragColor = vec4(vec3(rand1(uv, u_qseed, u_lseed, u_rseed)), 1.0);
}
