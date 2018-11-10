precision mediump float;

uniform vec2 u_resolution;
uniform float u_granularity;
uniform mat4 u_qseed;
uniform mat3 u_lseed;
uniform mat4 u_rseed;

%rand1{randtype:0}%

void main() {
  vec2 UV = gl_FragCoord.xy, uv = UV, uvi;
  if(u_granularity > 1.0) {
    uv = floor(UV / u_granularity) * u_granularity;
    uvi = (UV - uv) / u_granularity;
  }
  gl_FragColor = vec4(
    rand1(uv, mat2(u_qseed[0].xy, u_qseed[0].zw), vec2(u_lseed[0].xy), u_rseed[0]),
    rand1(uv, mat2(u_qseed[1].xy, u_qseed[1].zw), vec2(u_lseed[0].z, u_lseed[1].x), u_rseed[1]),
    rand1(uv, mat2(u_qseed[2].xy, u_qseed[2].zw), vec2(u_lseed[1].yz), u_rseed[2]),
    rand1(uv, mat2(u_qseed[3].xy, u_qseed[3].zw), vec2(u_lseed[2].xy), u_rseed[3])
  );
}
