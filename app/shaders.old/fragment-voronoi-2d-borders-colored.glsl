precision mediump float;

uniform vec2 u_resolution;
uniform float u_scale;
uniform float u_granularity;
uniform float u_time;
uniform float u_time_scale;
uniform int u_samples;
uniform mat2 u_qseed;
uniform vec2 u_lseed;
uniform vec4 u_rseed;
uniform vec3 u_backgroundcolor;
uniform vec3 u_edgecolor;
uniform float u_edgewidth;
uniform float u_wavefrequency;
uniform float u_waveslope;
uniform int u_colored;
uniform int u_ball;
uniform vec3 u_ballinnercolor;
uniform vec3 u_balloutercolor;
uniform float u_ballradius;
uniform int u_glow;
uniform float u_glowopacity;
uniform vec3 u_glowinnercolor;
uniform vec3 u_glowoutercolor;
uniform float u_glowradius;

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
  vec2 uv = gl_FragCoord.xy;
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
      voro2 voro = voronoi(uv, u_qseed, u_lseed, vec2(10.0, 10.0), u_rseed);
      float b = smoothstep(0.0125, u_edgewidth, voro.edge);
      vec3 cur = mix(u_edgecolor, u_backgroundcolor, b);
      cur += (u_colored > 0 ? voro.color : vec3(1.0)) * smoothstep(0.0, 1.0, u_waveslope * voro.edge * cos(u_wavefrequency * voro.edge));
      if(u_ball > 0) {
        if(u_glow > 0) {
          float g = smoothstep(0.0, u_glowradius, voro.dis);
          cur = mix(mix(u_glowinnercolor, u_glowoutercolor, voro.dis / u_glowradius), cur, 1.0 - (1.0 - g) * u_glowopacity);
        }
        float l = smoothstep(0.0375, u_ballradius, voro.dis);
        cur = mix(mix(u_ballinnercolor, u_balloutercolor, CURVE5(voro.dis / u_ballradius)), cur, l);
      }
      c += cur * factor;
    }
  gl_FragColor = vec4(c, 1.0);
}
