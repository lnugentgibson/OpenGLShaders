const fs = require('fs');

window.$ = window.jQuery = require('./lib/jquery/jquery.min.js');
require('./lib/jquery/jquery-ui.min.js');

function init(cid, _uniforms, vid, fid) {
  var scene = new THREE.Scene();
  var camera = new THREE.PerspectiveCamera(50, window.innerWidth / window.innerHeight, 0.1, 10000);
  camera.position.z = 1;
  var uniforms = Object.assign({
      time: {
          type: "f",
          value: 0.0
      },
      resolution: {
          type: "v2",
          value: new THREE.Vector2(128, 128)
      }
  }, _uniforms);
  material = new THREE.ShaderMaterial({
    uniforms: uniforms,
    vertexShader: $("#" + vid).text(),
    fragmentShader: $("#" + fid).text()
  });
  mesh = new THREE.Mesh(new THREE.PlaneBufferGeometry(2, 2), material);
  scene.add(mesh);
  var canvas = $('#' + cid)[0];
  renderer = new THREE.WebGLRenderer({
      canvas
  });
  return {
    scene,
    camera,
    material,
    uniforms,
    renderer
  };
}

$(() => {
  $('#g-tabs').tabs();
  var tick = void 0;
  var scene = init('main-view', {
    deltaY: {
      type: "f",
      value: 0.0
    }
  }, 'vertex-shader', 'fragment-shader');
  function render() {
    tick++;
    scene.material.uniforms['time'].value = 0.00025 * tick;
    scene.material.uniforms['deltaY'].value -= 0.0005;
    scene.renderer.render(scene.scene, scene.camera);
    window.requestAnimationFrame(render);
  }
  render();
});