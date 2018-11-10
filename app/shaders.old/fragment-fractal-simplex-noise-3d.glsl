precision mediump float;

uniform vec2 u_resolution;
uniform float u_granularity;
uniform float u_scale;
uniform int u_iterations;
uniform mat3 u_qseed;
uniform vec3 u_lseed;
uniform vec4 u_rseed;
uniform float u_time;
uniform float u_time_scale;

%DIM%
%MISC%
%MAP%
%SINERAND%

#define rand sinfract

%RAND%
%CURVES%

#define CURVE CURVE3

%GEOM%
%SIMPLEX%

#define NOISEITERATIONS 10
#define NOISE simplexGradient
#define NOISEGET(x) x

%FBM%

float dither(float g, vec2 uv) {
  uv = uv * 2.0;
  float x, y, z, l;
  
  x = 3.0 * uv.x;
  y = 3.0 * uv.y;
  z = 3.0 * (1.0 - uv.x - uv.y);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g);
  
  x = 3.0 * (uv.x - 1.0);
  y = 3.0 * uv.y;
  z = 3.0 * (2.0 - uv.x - uv.y);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 1.0);
  
  x = 3.0 * uv.x;
  y = 3.0 * (uv.y - 1.0);
  z = 3.0 * (2.0 - uv.x - uv.y);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 2.0);
  
  x = 3.0 * (uv.x - 1.0);
  y = 3.0 * (uv.y - 1.0);
  z = 3.0 * (3.0 - uv.x - uv.y);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 3.0);
  
  x = 3.0 * (1.0 - uv.x);
  y = 3.0 * (1.0 - uv.y);
  z = 3.0 * (uv.x + uv.y - 1.0);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 4.0);
  
  x = 3.0 * (2.0 - uv.x);
  y = 3.0 * (1.0 - uv.y);
  z = 3.0 * (uv.x + uv.y - 2.0);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 5.0);
  
  x = 3.0 * (1.0 - uv.x);
  y = 3.0 * (2.0 - uv.y);
  z = 3.0 * (uv.x + uv.y - 2.0);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 6.0);
  
  x = 3.0 * (2.0 - uv.x);
  y = 3.0 * (2.0 - uv.y);
  z = 3.0 * (uv.x + uv.y - 3.0);
  l = min(min(x, y), z);
  if(l >= 0.0)
    return step(1.0 - l, g - 7.0);
  
  return g / 8.0;
}

void main() {
  vec2 UV = gl_FragCoord.xy, uv = UV, uvi;
  if(u_granularity > 1.0) {
    uv = floor(UV / u_granularity) * u_granularity;
    uvi = (UV - uv) / u_granularity;
  }
  uv /= u_resolution;
  uv *= u_scale;
  vec3 uv3 = vec3(uv, u_time * u_time_scale);
  mat3 ss = mat3(2.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 1.0) * mat3(cos(0.2), sin(0.2), 0.0, -sin(0.2), cos(0.2), 0.0, 0.0, 0.0, 1.0);
  vec3 d1 = vec3(0.0, 0.0, 10.0);
  vec3 d2 = vec3(0.0, 0.0, -5.0);
  float g = fbm(uv3, u_iterations, ss, 0.5, u_qseed, u_lseed, d1, d2, u_rseed) * 1.4 * 0.5 + 0.5 + 0.05;
  float G = g * 8.0;
  gl_FragColor = vec4(vec3(u_granularity > 1.0 ? dither(G, uvi) : g), 1.0);
}
