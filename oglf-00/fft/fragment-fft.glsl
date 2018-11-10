#version 330 core

out vec3 color;

uniform ivec2 res;
uniform mat2 QS1;
uniform vec2 LS1;
uniform vec4 RS1;
uniform mat2 QS2;
uniform vec2 LS2;
uniform vec4 RS2;
uniform mat2 QS3;
uniform vec2 LS3;
uniform vec4 RS3;
uniform float Grain;
uniform float Threshold;
uniform sampler2D previous;
uniform int iteration;

vec2 complex_conjugate(vec2 a) {
  return vec2(a.x, -a.y);
}

vec2 complex_exp(vec2 a) {
  return exp(a.x) * vec2(cos(a.x), sin(a.y));
}

vec2 complex_mul(vec2 a, vec2 b) {
  return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

float map(vec2 uv, mat2 q, vec2 l) {
  return sin(2.0 * pow(dot(q * uv + l, uv), 6.0 / 11.0));
}

float rnd(float v, vec4 r) {
  return fract(sin(v * r.x + r.y) * r.z + r.w) > Threshold ? 1.0 : 0.0;
}

struct rset {
  mat2 q;
  vec2 l;
  vec4 r;
};

float rmap(vec2 uv, rset rs) {
  return rnd(map(uv, rs.q, rs.l), rs.r);
}

vec3 rvec(vec2 uv, rset r1, rset r2, rset r3) {
  return vec3(rmap(uv, r1), rmap(uv, r2), rmap(uv, r3));
}

struct neighborhood {
  vec3 rgb;
  vec3[8] n;
  ivec3 count;
};

neighborhood neighborhood_0() {
  return neighborhood(vec3(0.0), vec3[8](vec3(0.0), vec3(0.0), vec3(0.0), vec3(0.0), vec3(0.0), vec3(0.0), vec3(0.0), vec3(0.0)), ivec3(0));
}

neighborhood neighbors(vec2 xy, vec2 uv) {
  neighborhood n = neighborhood_0();
  n.rgb = texture( previous, uv ).rgb;
  for(int i = -1; i < 2; i++)
  for(int j = -1; j < 2; j++) {
    int k = i * 3 + j + 4;
    k = k > 4 ? k - 1 : k;
    if(i != 0 || j != 0) {
      n.n[k] = texture( previous, (xy + vec2(ivec2(i, j))) * Grain / vec2(res) ).rgb;
      n.count.r += n.n[k].r < 0.5 ? 1 : 0;
      n.count.g += n.n[k].g < 0.5 ? 1 : 0;
      n.count.b += n.n[k].b < 0.5 ? 1 : 0;
    }
  }
  return n;
}

vec3 ca(vec2 xy, vec2 uv) {
  neighborhood n = neighbors(xy, uv);
  vec3 c = vec3(0.0);
  for(int i = 0; i < 3; i++)
    if(n.rgb[i] < 0.5) {
      if(n.count[i] < 2 || n.count[i] > 3)
        c[i] = 1.0;
      else
        c[i] = 0.0;
    }
    else {
      if(n.count[i] == 3)
        c[i] = 0.0;
      else
        c[i] = 1.0;
    }
  return c;
}

float cam(vec2 xy, vec2 uv) {
  ivec4 n = ivec4(0);
  for(float i = -15.0; i < 16.0; i++)
  for(float j = -15.0; j < 16.0; j++) {
    float l = texture( previous, (xy + vec2(i, j)) * Grain / vec2(res) ).r;
    if(l < 0.5) {
      vec2 a = vec2(i, j);
      float r = length(a), R = max(i, j);
      
      if(r < 14.04) {
        if(R < 2.0 ||
            r >= 2.5 && r < 3.5 ||
            r >= 4.25 && r < 5.25 ||
            r >= 6.5 && r < 7.5 ||
            r >= 9.21 && r < 10.125 ||
            r >= 13.04 && r < 14.04)
          n.x++;
        
        if(R >= 1.0 && R < 2.0 ||
            r >= 2.5 && r < 3.5)
          n.y++;
        
        if(r >= 3.5 && r < 6.25)
          n.z++;
        
        if(R >= 1.0 && R < 2.0 ||
            r >= 3.25 && r < 4.25 ||
            r >= 6.5 && r < 7.5 ||
            r >= 9.5 && r < 13.5)
          n.w++;
      }
    }
  }
  if(n.x >= 0 && n.x <= 17) return 1.0;
  if(n.x >= 40 && n.x <= 42) return 0.0;
  if(n.y >= 10 && n.y <= 13) return 0.0;
  if(n.z >= 9 && n.z <= 21) return 1.0;
  if(n.w >= 78 && n.w <= 89) return 1.0;
  if(n.w > 108) return 1.0;
  return texture( previous, uv ).r > 0.5 ? 1.0 : 0.0;
}

void main(){
  vec2 uv;
  rset r1 = rset(QS1, LS1, RS1);
  rset r2 = rset(QS2, LS2, RS2);
  rset r3 = rset(QS3, LS3, RS3);
  if(iteration == 0) {
    uv = floor(gl_FragCoord.xy / Grain) * Grain / vec2(res);
    //color = rvec(uv, r1, r2, r3);
    color = vec3(rmap(uv, r1));
  }
  else {
    vec2 xy = floor(gl_FragCoord.xy / Grain);
    uv = vec2(xy) * Grain / vec2(res);
    //color = ca(xy, uv);
    color = vec3(cam(xy, uv));
    //color = texture( previous, uv ).rgb;
  }
}
