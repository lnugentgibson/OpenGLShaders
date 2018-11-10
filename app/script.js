const base64Img = require('base64-img');
const random = require('random-seed');

window.$ = window.jQuery = require('./lib/jquery/jquery.min.js');
require('./lib/jquery/jquery-ui.min.js');

function map2D(data) {
  delete data.iterations;
  delete data.samples;
  Imagine(Object.assign(data, {
    omitscale: true,
    omitresolution: true,
    dimensions: 2,
    fragment: 'map-2d',
    subdir: [data.size, 'map'],
    basename: 'map-2d',
    modifiers: [],
    dynamicseed: true
  }));
}

function whiteNoise2D(data) {
  delete data.iterations;
  delete data.samples;
  Imagine(Object.assign(data, {
    omitscale: true,
    omitresolution: true,
    granularity: 1,
    dimensions: 2,
    fragment: 'white-noise-2d',
    subdir: [data.size, 'white', '2d', 1],
    basename: 'whitenoise-2d',
    modifiers: [],
    dynamicseed: true
  }));
}

function whiteNoise2Dx3(data) {
  delete data.iterations;
  delete data.samples;
  Imagine(Object.assign(data, {
    omitscale: true,
    omitresolution: true,
    granularity: 1,
    dimensions: 2,
    outputs: 3,
    fragment: 'white-noise-2d-x3',
    subdir: [data.size, 'white', '2d', 3],
    basename: 'whitenoise-2d-x3',
    modifiers: [],
    dynamicseed: true
  }));
}

function whiteNoise2Dx4(data) {
  delete data.iterations;
  delete data.samples;
  Imagine(Object.assign(data, {
    omitscale: true,
    omitresolution: true,
    granularity: 1,
    dimensions: 2,
    outputs: 4,
    fragment: 'white-noise-2d-x4',
    subdir: [data.size, 'white', '2d', 4],
    basename: 'whitenoise-2d-x4',
    modifiers: [],
    dynamicseed: true
  }));
}

function whiteNoise3D(data) {
  delete data.iterations;
  delete data.samples;
  Imagine(Object.assign(data, {
    omitscale: true,
    omitresolution: true,
    granularity: 1,
    dimensions: 3,
    fragment: 'white-noise-3d',
    subdir: [data.size, 'white', '3d', 1, ('000' + data.seed).substr(-3, 3)],
    basename: 'whitenoise-3d',
    modifiers: [],
    time: true
  }));
}

function perlinNoise2D(data) {
  delete data.iterations;
  delete data.samples;
  Imagine(Object.assign(data, {
    dimensions: 2,
    fragment: 'perlin-noise-2d',
    subdir: [data.size, 'perlin', '2d', 1],
    basename: 'perlinnoise-2d',
    modifiers: [
      [data.scale, '0000']
    ],
    dynamicseed: true
  }));
}

function perlinNoise2DFT(data) {
  delete data.iterations;
  delete data.samples;
  delete data.frames;
  var seed = data.seed;
  delete data.seed;
  Imagine(Object.assign(data, {
    dimensions: 2,
    fragment: 'perlin-noise-2d-ft',
    subdir: [data.size, 'perlin', '2d', 1, 'ft'],
    basename: 'perlinnoise-2d',
    modifiers: [
      [seed, '000'],
      [data.scale, '0000']
    ],
    uniforms: {
      u_tex_scale: {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: 32
      }
    },
    textures: [{
      id: 'white-noise-0',
      resolution: [512, 512],
      path: 'images/512/white/2d/4/whitenoise-2d-x4.000.png'
    }]
  }));
}

function simplexNoise2D(data) {
  delete data.iterations;
  delete data.samples;
  Imagine(Object.assign(data, {
    dimensions: 2,
    fragment: 'simplex-noise-2d',
    subdir: [data.size, 'simplex', '2d', 1],
    basename: 'simplexnoise-2d',
    modifiers: [
      [data.granularity, '00'],
      [data.scale, '0000']
    ],
    dynamicseed: true
  }));
}

function simplexNoise2DFT(data) {
  delete data.iterations;
  //delete data.samples;
  delete data.frames;
  var seed = data.seed;
  delete data.seed;
  Imagine(Object.assign(data, {
    dimensions: 2,
    fragment: 'simplex-noise-2d-ft',
    subdir: [data.size, 'simplex', '2d', 1, 'ft'],
    basename: 'simplexnoise-2d',
    modifiers: [
      [seed, '000'],
      [data.scale, '0000']
    ],
    uniforms: {
      u_tex_scale: {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: 32
      }
    },
    textures: [{
      id: 'white-noise-0',
      resolution: [512, 512],
      path: 'images/512/white/2d/4/whitenoise-2d-x4.000.png'
    }]
  }));
}

function simplexNoise3D(data) {
  delete data.iterations;
  delete data.samples;
  Imagine(Object.assign(data, {
    dimensions: 3,
    fragment: 'simplex-noise-3d',
    subdir: [data.size, 'simplex', '3d', 1, ('000' + data.seed).substr(-3, 3)],
    basename: 'simplexnoise-3d',
    modifiers: [
      [data.scale, '0000']
    ],
    time: true
  }));
}

function simplexNoise4D(data) {
  delete data.iterations;
  delete data.samples;
  Imagine(Object.assign(data, {
    dimensions: 4,
    fragment: 'simplex-noise-4d',
    subdir: [data.size, 'simplex', '4d', 1, ('000' + data.seed).substr(-3, 3)],
    basename: 'simplexnoise-4d',
    modifiers: [
      [data.scale, '0000']
    ],
    time: true
  }));
}

function fractalPerlinNoise2D(data) {
  delete data.samples;
  Imagine(Object.assign(data, {
    dimensions: 2,
    fragment: 'fractal-perlin-noise-2d',
    subdir: [data.size, 'perlin', '2d', 1, 'fractal'],
    basename: 'fractalnoise-2d',
    modifiers: [
      [data.scale, '0000'],
      [data.iterations, '00']
    ],
    dynamicseed: true
  }));
}

function fractalSimplexNoise2D(data) {
  delete data.samples;
  Imagine(Object.assign(data, {
    dimensions: 2,
    fragment: 'fractal-simplex-noise-2d',
    subdir: [data.size, 'simplex', '2d', 1, 'fractal'],
    basename: 'fractalnoise-2d',
    modifiers: [
      [data.granularity, '00'],
      [data.scale, '0000'],
      [data.iterations, '00']
    ],
    dynamicseed: true
  }));
}

function fractalSimplexNoise3D(data) {
  delete data.samples;
  Imagine(Object.assign(data, {
    dimensions: 3,
    fragment: 'fractal-simplex-noise-3d',
    subdir: [data.size, 'simplex', '3d', 1, 'fractal', ('000' + data.seed).substr(-3, 3)],
    basename: 'fractalnoise-3d',
    modifiers: [
      [data.granularity, '00'],
      [data.scale, '0000'],
      [data.iterations, '00']
    ],
    time: true
  }));
}

function voronoi2D(data) {
  var main = Object.assign(data.main, {
    dimensions: 2,
    fragment: 'voronoi-2d',
    subdir: [data.main.size, 'voronoi', '2d', 1],
    basename: 'voronoi-2d',
    modifiers: [
      [data.scale, '0000']
    ],
    dynamicseed: true
  });
  delete main.iterations;
  data.main = main;
  Imagine(data);
}

function voronoi2DFT(data) {
  delete data.iterations;
  delete data.frames;
  var seed = data.seed;
  delete data.seed;
  Imagine(Object.assign(data, {
    dimensions: 2,
    fragment: 'voronoi-2d-ft',
    subdir: [data.size, 'voronoi', '2d', 1, 'ft'],
    basename: 'voronoi-2d',
    modifiers: [
      [seed, '000'],
      [data.scale, '0000']
    ],
    uniforms: {
      u_tex_scale: {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: 32
      },
      u_voro_amp: {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: 1.5
      }
    },
    textures: [{
      id: 'white-noise-0',
      resolution: [512, 512],
      path: 'images/512/white/2d/4/whitenoise-2d-x4.000.png'
    }]
  }));
}

function voronoi3D(data) {
  delete data.iterations;
  Imagine(Object.assign(data, {
    dimensions: 3,
    fragment: 'voronoi-3d',
    subdir: [data.size, 'voronoi', '3d', 1, ('000' + data.seed).substr(-3, 3)],
    basename: 'voronoi-3d',
    modifiers: [
      [data.scale, '0000']
    ],
    time: true,
    timescale: 0.0001
  }));
}

function voronoiColoredBorders(data) {
  delete data.iterations;
  Imagine(Object.assign(data, {
    dimensions: 2,
    fragment: 'voronoi-2d-borders-colored',
    subdir: [data.size, 'voronoi', '2d', 'colored'],
    basename: 'voronoiborders-2d',
    modifiers: [
      [data.scale, '0000']
    ],
    dynamicseed: true,
    uniforms: {
      u_backgroundcolor: {
        type: 'vector',
        dim: 3,
        datatype: 'f',
        value: [0, 0, 0]
      },
      u_edgecolor: {
        type: 'vector',
        dim: 3,
        datatype: 'f',
        value: [1, 0.8, 0]
      },
      u_edgewidth: {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: 0.05
      },
      u_wavefrequency: {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: 75
      },
      u_waveslope: {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: 1.5
      },
      u_colored: {
        type: 'list',
        dim: 1,
        datatype: 'i',
        value: 1
      },
      u_ball: {
        type: 'list',
        dim: 1,
        datatype: 'i',
        value: 1
      },
      u_ballinnercolor: {
        type: 'vector',
        dim: 3,
        datatype: 'f',
        value: [1, 1.0, 0]
      },
      u_balloutercolor: {
        type: 'vector',
        dim: 3,
        datatype: 'f',
        value: [1, 0.5, 0]
      },
      u_ballradius: {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: 0.05
      },
      u_glow: {
        type: 'list',
        dim: 1,
        datatype: 'i',
        value: 1
      },
      u_glowopacity: {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: 0.75
      },
      u_glowinnercolor: {
        type: 'vector',
        dim: 3,
        datatype: 'f',
        value: [1, 0.75, 0]
      },
      u_glowoutercolor: {
        type: 'vector',
        dim: 3,
        datatype: 'f',
        value: [1, 0.5, 0]
      },
      u_glowradius: {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: 0.25
      }
    }
  }));
}

function snubSquare(data) {
  var amp = [0.0, 0.0];
  delete data.iterations;
  Imagine(Object.assign(data, {
    fragment: 'snub-square',
    subdir: [data.size, 'tesselation', 'snub-square'],
    basename: 'snub-square',
    modifiers: [
      [Math.round(amp[0] * 1000), '0000'],
      [Math.round(amp[1] * 1000), '0000']
    ],
    uniforms: {
      u_amp: {
        type: 'vector',
        dim: 2,
        datatype: 'f',
        value: amp
      }
    }
  }));
}

function triangle(data) {
  delete data.iterations;
  delete data.seed;
  delete data.frames;
  Imagine(Object.assign(data, {
    fragment: 'triangle',
    subdir: [data.size, 'shapes', 'triangle'],
    basename: 'triangle',
    modifiers: [],
    uniforms: {
      u_p0: {
        type: 'vector',
        dim: 2,
        datatype: 'f',
        value: [0.3 * data.scale, 0.3 * data.scale]
      },
      u_p1: {
        type: 'vector',
        dim: 2,
        datatype: 'f',
        value: [0.7 * data.scale, 0.4 * data.scale]
      },
      u_p2: {
        type: 'vector',
        dim: 2,
        datatype: 'f',
        value: [0.4 * data.scale, 0.6 * data.scale]
      }
    }
  }));
}

var canvas = $('#main-view')[0];
var programs = {
  white: {
    1: {
      2: whiteNoise2D,
      3: whiteNoise3D
    },
    3: {
      2: whiteNoise2Dx3
    },
    4: {
      2: whiteNoise2Dx4
    }
  },
  perlin: {
    perlin: {
      2: perlinNoise2D
    },
    simplex: {
      2: simplexNoise2D,
      3: simplexNoise3D,
      4: simplexNoise4D
    },
    fractalperlin: {
      2: fractalPerlinNoise2D
    },
    fractalsimplex: {
      2: fractalSimplexNoise2D,
      3: fractalSimplexNoise3D
    },
    perlinft: {
      2: perlinNoise2DFT
    },
    simplexft: {
      2: simplexNoise2DFT
    }
  },
  voronoi: {
    seed: {
      2: voronoi2D,
      3: voronoi3D
    },
    colored: {
      2: voronoiColoredBorders
    },
    texture: {
      2: voronoi2DFT
    }
  }
};
programs.voronoi.seed[2]({
  canvas,
  size: 1 << 9,
  main: {
    granularity: 0,
    size: 1 << 9,
    scale: 16,
    //scale: 1,
    iterations: 7,
    frames: 1,
    samples: 4,
    frameRate: 1000. / 20,
    seed: 0,
    shaders: shaders => {
      $('#vert-shader').html(shaders.vert);
      $('#frag-shader').html(shaders.frag);
    }
  },
  auxiliary: []
});
