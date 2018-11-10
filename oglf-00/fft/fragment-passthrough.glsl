#version 330 core

out vec3 color;

uniform ivec2 res;
uniform float weight;
uniform sampler2D previous;
uniform sampler2D current;
uniform int iteration;

void main(){
  vec3 p = texture( previous, gl_FragCoord.xy / vec2(res) ).rgb;
  vec3 c = texture( current, gl_FragCoord.xy / vec2(res) ).rgb;
  color = iteration == 0 ? c : mix(p, c, weight);
  //color = (p + c) * 0.5;
  //color = c;
}
