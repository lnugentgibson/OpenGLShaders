precision mediump float;

uniform vec2 u_resolution;
uniform sampler2D u_source;

void main() {
  gl_FragColor = texture2D(u_source, gl_FragCoord.xy / u_resolution) * vec4(0.0, 1.0, 1.0, 1.0) + vec4(1.0, 0.0, 0.0, 0.0);
}
