precision mediump float;

uniform vec2 u_resolution;
uniform float u_granularity;
uniform float u_scale;
uniform mat3 u_qseed;
uniform vec3 u_lseed;
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
  vec3 uv3 = vec3(uv, u_time * u_time_scale);
  gl_FragColor = vec4(vec3(NOISE(uv3, u_qseed, u_lseed, vec3(0.0, 0.0, 10.0), u_rseed) * 0.5 + 0.5), 1.0);
}
