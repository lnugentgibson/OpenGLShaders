precision mediump float;

uniform vec2 u_resolution;
uniform float u_granularity;
uniform float u_scale;
uniform mat4 u_qseed;
uniform vec4 u_lseed;
uniform vec4 u_rseed;
uniform float u_time;
uniform float u_time_scale;

%noise{noisetype:1,randtype:0,curvetype:1}%

void main() {
  vec2 UV = gl_FragCoord.xy, uv = UV, uvi;
  if(u_granularity > 1.0) {
    uv = floor(UV / u_granularity) * u_granularity;
    uvi = (UV - uv) / u_granularity;
  }
  uv /= u_resolution;
  uv *= u_scale;
  float t = u_time * u_time_scale;
  vec4 uv4 = vec4(uv, 1.0 * cos(t), 1.0 * sin(t));
  gl_FragColor = vec4(vec3(NOISE(uv4, u_qseed, u_lseed, vec4(0.0, 0.0, 10.0, 10.0), u_rseed) * 0.5 + 0.5), 1.0);
}
