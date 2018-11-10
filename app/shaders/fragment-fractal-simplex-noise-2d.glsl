precision mediump float;

uniform vec2 u_resolution;
uniform float u_granularity;
uniform float u_scale;
uniform int u_iterations;
uniform mat2 u_qseed;
uniform vec2 u_lseed;
uniform vec4 u_rseed;

%fbm{noiseiterations:10,noisegettype:0,noisetype:1,randtype:0,curvetype:1}%

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
  mat2 ss = mat2(2.0, 0.0, 0.0, 2.0) * mat2(cos(0.2), sin(0.2), -sin(0.2), cos(0.2));
  vec2 d1 = vec2(10.0, 10.0);
  vec2 d2 = vec2(-5.0, -5.0);
  float g = fbm(uv, u_iterations, ss, 0.5, u_qseed, u_lseed, d1, d2, u_rseed) * 1.4 * 0.5 + 0.5 + 0.05;
  float G = g * 8.0;
  gl_FragColor = vec4(vec3(u_granularity > 1.0 ? dither(G, uvi) : g), 1.0);
}
