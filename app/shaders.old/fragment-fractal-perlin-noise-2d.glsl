precision mediump float;

uniform vec2 u_resolution;
uniform float u_granularity;
uniform float u_scale;
uniform int u_iterations;
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

%PERLIN%

#define NOISEITERATIONS 10
#define NOISE perlinGradient
#define NOISEGET(x) x

%FBM%

void main() {
  vec2 UV = gl_FragCoord.xy, uv = UV, uvi;
  if(u_granularity > 1.0) {
    uv = floor(UV / u_granularity) * u_granularity;
    uvi = (UV - uv) / u_granularity;
  }
  uv /= u_resolution;
  uv *= u_scale;
  mat2 ss = mat2(2.0, 0.0, 0.0, 2.0) * mat2(cos(0.2), sin(0.2), -sin(0.2), cos(0.2));
  vec2 d1 = vec2(10.0, 10.0);
  vec2 d2 = vec2(-5.0, -5.0);
  gl_FragColor = vec4(vec3(fbm(uv, u_iterations, ss, 0.5, u_qseed, u_lseed, d1, d2, u_rseed) * 0.5 + 0.5), 1.0);
}
