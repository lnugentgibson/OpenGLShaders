precision mediump float;

uniform vec2 u_resolution;
uniform float u_scale;
uniform float u_granularity;
uniform float u_time;
uniform float u_time_scale;
uniform int u_samples;

%COMMON%
void position(inout vec2 coord, vec2 res, float scale, float time, float timescale, float granularity, float radius, out vec3 coord3, out vec4 coord4) {
  coord /= res;
  coord *= scale;
  float t = time * timescale;
  coord3 = vec3(coord, t);
  coord4 = vec4(coord, radius * cos(t), radius * sin(t));
  //coord = floor(granularity * coord) / granularity;
  //coord3 = floor(granularity * coord3) / granularity;
  //coord4 = floor(granularity * coord4) / granularity;
}
vec3 pixel(vec2 uv, mat2 dm2, vec2 dv2, vec4 s, float edgewidth, float glowradius, float ballradius) {
  vec3 c;
  //float v1 = rand1(uv3, dm3, dv3, s);
  //float v1 = perlinGradient(uv2, dm2, dv2, vec2(10.0, 10.0), s);
  //float v1 = perlinGradient(uv3, dm3, dv3, vec3(0.0, 0.0, 10.0), s);
  //float v1 = perlinGradient(uv4, dm4, dv4, vec4(0.0, 0.0, 10.0, 10.0), s);
  //float v1 = simplexGradient(uv, dm2, dv2, vec2(10.0, 10.0), s);
  //float v1 = simplexGradient(uv3, dm3, dv3, vec3(0.0, 0.0, 10.0), s);
  //float v1 = simplexGradient(uv4, dm4, dv4, vec4(0.0, 0.0, 10.0, 10.0), s);
  voro2 voro = voronoi(uv, dm2, dv2, vec2(10.0, 10.0), s);
  float b = smoothstep(0.0125, edgewidth, voro.edge);
  c = mix(vec3(1.0, 0.8, 0.0), voro.color * smoothstep(0.0, 1.0, 1.5 * voro.edge * cos(75.0 * voro.edge)), b);
  float g = smoothstep(0.0, glowradius, voro.dis);
  c = mix(mix(vec3(1.0, 0.75, 0.0), vec3(1.0, 0.5, 0.0), voro.dis / glowradius), c, g);
  float l = smoothstep(0.0375, ballradius, voro.dis);
  c = mix(mix(vec3(1.0, 1.0, 0.0), vec3(1.0, 0.5, 0.0), CURVE5(voro.dis / ballradius)), c, l);
  //c = vec3(voro.dis);
  //c = c * 0.5 + 0.5;
  //vec2 v2 = rand2(uv3, dm3, dv3, vec3(0.0, 0.0, 1.0), s);
  //c = vec3(v2 * 2.0 - 1.0, 0.5);
  return c;
}
void main() {
  vec2 uv = gl_FragCoord.xy;
  vec3 uv3;
  vec4 uv4;
  position(uv, u_resolution, u_scale, 0.0, u_time_scale, u_granularity, 1.0, uv3, uv4);
  //mat2 dm2 = mat2(sqrt(5.0) * 13.0, sqrt(3.0) * 12.0, sqrt(2.0) * 10.0, sqrt(7.0) * 11.0);
  mat2 dm2 = mat2(sqrt(5.0) / 3.0, sqrt(2.0) / 1.5, sqrt(7.0) / 2.0, sqrt(3.0) / 1.8);
  mat3 dm3 = mat3(
    sqrt(5.0) / 3.0, sqrt(2.0) / 1.5, sqrt(63.0) / 8.2,
    sqrt(7.0) / 2.0, sqrt(3.0) / 1.8, sqrt(137.0) / 11.8,
    //sqrt(19.0) / 4.2, sqrt(123.0) / 11.1, sqrt(23.0) / 4.9
    0.0, 0.0, 0.0
  );
  mat4 dm4 = mat4(
    sqrt(5.0) / 3.0, sqrt(2.0) / 1.5, sqrt(63.0) / 8.2, 0.0,
    sqrt(7.0) / 2.0, sqrt(3.0) / 1.8, sqrt(137.0) / 11.8, 0.0,
    //sqrt(19.0) / 4.2, sqrt(123.0) / 11.1, sqrt(23.0) / 4.9
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0
  );
  //vec2 dv2 = vec2(35.5215, 43.6436)
  vec2 dv2 = vec2(sqrt(11.0) / 3.2, sqrt(15.0) / 4.0);
  vec3 dv3 = vec3(sqrt(11.0) / 3.2, sqrt(15.0) / 4.0, /*sqrt(17.0) / 4.1*/ 1.0);
  vec4 dv4 = vec4(sqrt(11.0) / 3.2, sqrt(15.0) / 4.0, /*sqrt(17.0) / 4.1*/ 1.0, 0.5976);
  vec4 s = vec4(1518.367, 34.347, 184.536, 363.5773);
  vec3 c = vec3(0.0);//pixel(uv, dm2, dv2, s);
  float factor = 1.0 / float(u_samples);
  for(int i = 0; i < 20; i++)
    if(i < u_samples) {
      vec2 shift = rand2(uv3 + vec3(0.0, 0.0, float(i)), dm3, dv3, vec3(0.0, 0.0, 0.5), s) * u_scale / u_resolution;
      //c += pixel(uv + shift * u_scale / u_resolution, dm2, dv2, s) * factor;
      c += pixel(uv + shift, dm2, dv2, s, 0.05, 0.5, 0.05) * factor;
    }
  gl_FragColor = vec4(c, 1.0);
}
/*
float simplexGradient(vec4 p, mat4 d, vec4 s) {
    //p.z = 0.0;
    float skew = (sqrt(5.0) - 1.0) / 4.0, unskew = (1.0 - 1.0 / sqrt(5.0)) / 4.0;
    #define SKEW
    #ifdef SKEW
    vec4 P = p + sum_e(p) * skew;
    #else
    vec3 P = p;
    #endif
    vec4 L = floor(P);
    vec4 f = fract(P);
    ivec4 o = sortD(f);
    vec4 c1 = L;
    vec4 c2 = c1 + (o.x == 1 ? i4 : o.x == 2 ? j4 : o.x == 3 ? k4 : l4);
    vec4 c3 = c2 + (o.y == 1 ? i4 : o.y == 2 ? j4 : o.y == 3 ? k4 : l4);
    vec4 c4 = c3 + (o.z == 1 ? i4 : o.z == 2 ? j4 : o.z == 3 ? k4 : l4);
    vec4 c5 = L + 1.0;
    #ifdef SKEW
    c1 -= sum_e(c1) * unskew;
    c2 -= sum_e(c2) * unskew;
    c3 -= sum_e(c3) * unskew;
    c4 -= sum_e(c4) * unskew;
    c5 -= sum_e(c5) * unskew;
    #endif
    float V = pentachoron(c1, c2, c3, c4, c5);
    float w1 = CURVE(pentachoron(p, c2, c3, c4, c5) / V);
    float w2 = CURVE(pentachoron(c1, p, c3, c4, c5) / V);
    float w3 = CURVE(pentachoron(c1, c2, p, c4, c5) / V);
    float w4 = CURVE(pentachoron(c1, c2, c3, p, c5) / V);
    float w5 = CURVE(pentachoron(c1, c2, c3, c4, p) / V);
    //#define WEIGHT3
    #ifdef WEIGHT3
    if(o.x == 1)
        return o.y == 2 ? i3 : 1.0 - i3;
    else if(o.x == 2)
        return o.y == 3 ? j3 : 1.0 - j3;
    else if(o.x == 3)
        return o.y == 1 ? k3 : 1.0 - k3;
    return (w1 + w2 + w3 + w4 + w5) * 0.5;
    #else
    #define GRADIENT3
    #ifdef GRADIENT3
    vec4 g1 = randRot(c1, d, s);
    vec4 g2 = randRot(c2, d, s);
    vec4 g3 = randRot(c3, d, s);
    vec4 g4 = randRot(c4, d, s);
    vec4 g5 = randRot(c5, d, s);
    vec4 d1 = p - c1;
    vec4 d2 = p - c2;
    vec4 d3 = p - c3;
    vec4 d4 = p - c4;
    vec4 d5 = p - c5;
    float v1 = dot(g1, d1);
    float v2 = dot(g2, d2);
    float v3 = dot(g3, d3);
    float v4 = dot(g4, d4);
    float v5 = dot(g4, d5);
    //return (w1 > w2 && w1 > w3 && w1 > w4 ? d1 : w2 > w1 && w2 > w3 && w2 > w4 ? d2 : w3 > w1 && w3 > w2 && w3 > w4 ? d3 : d4) * 0.5 + 0.5;
    //return w1 > w2 && w1 > w3 && w1 > w4 ? g1 : w2 > w1 && w2 > w3 && w2 > w4 ? g2 : w3 > w1 && w3 > w2 && w3 > w4 ? g3 : g4;
    //return vec3(w1 > w2 && w1 > w3 && w1 > w4 ? v1 : w2 > w1 && w2 > w3 && w2 > w4 ? v2 : w3 > w1 && w3 > w2 && w3 > w4 ? v3 : v4);
    //return vec3(w1 > w2 && w1 > w3 && w1 > w4 ? v1 * w1 : w2 > w1 && w2 > w3 && w2 > w4 ? v2 * w2 : w3 > w1 && w3 > w2 && w3 > w4 ? v3 * w3 : v4 * w4);
    return (v1 * w1 + v2 * w2 + v3 * w3 + v4 * w4 + v5 * w5) / (w1 + w2 + w3 + w4 + w5);
    #else
    float v1 = rand(c1, 0.0, 1.0, d[0], s);
    float v2 = rand(c2, 0.0, 1.0, d[0], s);
    float v3 = rand(c3, 0.0, 1.0, d[0], s);
    float v4 = rand(c4, 0.0, 1.0, d[0], s);
    float v5 = rand(c5, 0.0, 1.0, d[0], s);
    //return vec3(v1 * w1, v2 * w2, v3 * w3);
    return (w1 > w2 && w1 > w3 && w1 > w4 ? v1 : w2 > w1 && w2 > w3 && w2 > w4 ? v2 : w3 > w1 && w3 > w2 && w3 > w4 ? v3 : v4);
    #endif
    #endif
    //return vec3(w2, w3, w4);
}
*/
