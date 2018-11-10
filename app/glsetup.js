var fs = require('fs');
const {depend} = require('./shaders.js');

var onerr = (msg, err) => {
  if (err) {
    console.error(msg);
    console.error(err);
  }
};

function loadTextFile(file) {
  return new Promise((resolve, reject) => {
    fs.readFile(file, (err, body) => {
      if (err) {
        reject(err);
        return;
      }
      resolve('' + body);
    });
  });
}

function loadVertexShader() {
  //return loadTextFile('resources\\app\\shaders\\vertex-pass-through.glsl');
  return loadTextFile('shaders/vertex-pass-through.glsl');
}

function loadFragmentShader(name) {
  return loadTextFile(`shaders/fragment-${name}.glsl`).then(frag => {
    return frag.replace(/%([a-zA-Z0-9]+(,[a-zA-Z0-9]+)*){([a-zA-Z0-9]+:[0-9]+(,[a-zA-Z0-9]+:[0-9]+)*)?}%/, (match, p1, p2, p3, p4) => {
      var fs = p1 ? p1.split(',') : [];
      var is = p3 ? p3.split(',') : [];
      var input = {};
      is.forEach(i => {
        let [,
          id,
          val
        ] = i.match(/([a-zA-Z0-9]+):([0-9]+)/);
        input[id] = val;
      });
      return depend(input, fs).join('\n\n');
    });
  });
}

function Save(data, subdir, basename, modifiers) {
  //var dir = `resources\\app\\images\\${subdir.join('\\')}`;
  var dir = `images/${subdir.join('/')}`;
  modifiers = modifiers.map(m => {
    let [
      index,
      span
    ] = m;
    var len = span.length;
    return `.${(span + index).substr(-len, len)}`;
  });
  var filename = `${basename}${modifiers.join('')}`;
  //console.log(`${dir}\\${filename}.png`);
  base64Img.img(data, dir, filename, err => {
    if (err)
      console.error(err);
  });
}

function zeros(n) {
  var arr = [];
  for (var i = 0; i < n; i++)
    arr.push(0);
  return arr;
}

function genseed(s, dim) {
  var r = new random(`seed-${('000' + s).substr(-3, 3)}`);
  return {
    qs: zeros(dim * dim).map(() => r.floatBetween(0.85, 1.35) * (r.range(2) * 2 - 1)),
    ls: zeros(dim).map(() => r.floatBetween(0.95, 1.5) * (r.range(2) * 2 - 1)),
    rs: [
      [1200, 1600],
      [20, 40],
      [120, 200],
      [300, 400]
    ].map(i => r.floatBetween(i[0], i[1]) * (r.range(2) * 2 - 1))
  };
}

function seeds(n, sizes, dim, iteration) {
  var seeds = genseed(iteration, dim);
  for (var i = 1; i < n; i++) {
    let {
      qs,
      ls,
      rs
    } = genseed(n * iteration + i, dim);
    seeds.qs = seeds.qs.concat(qs);
    seeds.ls = seeds.ls.concat(ls);
    seeds.rs = seeds.rs.concat(rs);
  }
  while (seeds.qs.length < sizes[0])
    seeds.qs.push(0);
  while (seeds.ls.length < sizes[1])
    seeds.ls.push(0);
  while (seeds.rs.length < sizes[2])
    seeds.rs.push(0);
  return seeds;
}

function updateSeeds(data, uniforms, iteration) {
  let {
    qs,
    ls,
    rs
  } = seeds(data.outputs, data.outputs > 1 ? [16, 4, 16] : [data.dimensions * data.dimensions, data.dimensions, 4], data.dimensions, iteration);
  uniforms.u_qseed.value = qs;
  uniforms.u_lseed.value = ls;
  uniforms.u_rseed.value = rs;
}

function imageLoad(resolve, Canvas, program, id, i, path, image) {
  console.log({
    //resolve, Canvas, program,
    id,
    i,
    path,
    //image
  });
  Canvas.bindTexture(id);
  Canvas.gl.texImage2D(Canvas.gl.TEXTURE_2D, 0, Canvas.gl.RGBA, Canvas.gl.RGBA, Canvas.gl.UNSIGNED_BYTE, image);
  // gl.NEAREST is also allowed, instead of gl.LINEAR, as neither mipmap.
  Canvas.gl.texParameteri(Canvas.gl.TEXTURE_2D, Canvas.gl.TEXTURE_MIN_FILTER, Canvas.gl.NEAREST);
  // Prevents s-coordinate wrapping (repeating).
  Canvas.gl.texParameteri(Canvas.gl.TEXTURE_2D, Canvas.gl.TEXTURE_WRAP_S, Canvas.gl.CLAMP_TO_EDGE);
  // Prevents t-coordinate wrapping (repeating).
  Canvas.gl.texParameteri(Canvas.gl.TEXTURE_2D, Canvas.gl.TEXTURE_WRAP_T, Canvas.gl.CLAMP_TO_EDGE);
  var tex = `TEXTURE${i}`;
  Canvas.gl.activeTexture(Canvas.gl[tex]);
  console.log('activeTexture(' + tex + '): ' + Canvas.gl[tex]);
  Canvas.bindTexture(id);
  console.log(id + ' -> ' + i);
  program.setUniform(`u_tex_${i}`, 'list', 1, 'i', i);
  resolve();
}

function Setup(data, par) {
  return loadFragmentShader(data.fragment).then(frag => {
    var vert = data.vert;
    var uniforms = {
      u_resolution: {
        type: 'list',
        dim: 2,
        datatype: 'f',
        values: [data.size, data.size]
      },
      u_scale: {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: data.scale
      }
    };
    if (data.omitscale)
      delete uniforms.u_scale;
    if (data.omitresolution)
      delete uniforms.u_resolution;
    if (data.granularity)
      uniforms.u_granularity = {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: data.granularity
      };
    if (data.time) {
      uniforms.u_time = {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: 0
      };
      uniforms.u_time_scale = {
        type: 'list',
        dim: 1,
        datatype: 'f',
        value: data.timescale ? data.timescale : 0.001
      };
    }
    if (data.iterations)
      uniforms.u_iterations = {
        type: 'list',
        dim: 1,
        datatype: 'i',
        value: data.iterations
      };
    if (data.samples)
      uniforms.u_samples = {
        type: 'list',
        dim: 1,
        datatype: 'i',
        value: data.samples
      };
    if (data.seed !== undefined) {
      var seeds = {
        u_qseed: {
          type: 'matrix',
          dim: 2,
          datatype: 'f',
          value: zeros(4)
        },
        u_lseed: {
          type: 'vector',
          dim: 2,
          datatype: 'f',
          value: zeros(2)
        },
        u_rseed: {
          type: 'vector',
          dim: 4,
          datatype: 'f',
          value: zeros(4)
        }
      };
      if (data.dimensions) {
        seeds.u_qseed.dim = seeds.u_lseed.dim = data.dimensions;
        seeds.u_qseed.value = zeros(data.dimensions * data.dimensions);
        seeds.u_lseed.value = zeros(data.dimensions);
      }
      else
        data.dimensions = 2;
      if (data.outputs && data.outputs > 1) {
        seeds.u_qseed.dim = 4;
        seeds.u_qseed.value = zeros(16);
        seeds.u_lseed.type = 'matrix';
        seeds.u_lseed.dim = 3;
        seeds.u_lseed.value = zeros(9);
        seeds.u_rseed.type = 'matrix';
        seeds.u_rseed.dim = 4;
        seeds.u_rseed.value = zeros(16);
      }
      else
        data.outputs = 1;
      Object.assign(uniforms, seeds);
    }
    uniforms = Object.assign(uniforms, data.uniforms);
    var Canvas = par.Canvas;
    var program = Canvas.programFromShaders(data.id + 'p', data.id + 'v', vert, data.id + 'f', frag, onerr);
    Canvas.useProgram(data.id + 'p');
    program.initUniforms(uniforms);
    program.initAttribute("a_position");
    Canvas.createBuffer('positionBuffer');
    Canvas.bindBuffer('positionBuffer', 'ARRAY_BUFFER');
    Canvas.clear('COLOR_BUFFER_BIT');
    program.enableAttribute("a_position");
    program.vertexAttribPointer("a_position", 2, Canvas.gl.FLOAT, false, 0, 0);
    var x1 = -1;
    var x2 = 1;
    var y1 = -1;
    var y2 = 1;
    Canvas.setBufferData('ARRAY_BUFFER', 'STATIC_DRAW', new Float32Array([
      x1, y1,
      x2, y1,
      x1, y2,
      x1, y2,
      x2, y1,
      x2, y2,
    ]));
    Canvas.createTexture(data.id + 'l');
    Canvas.bindTexture(data.id + 'l');
    Canvas.gl.texImage2D(Canvas.gl.TEXTURE_2D, 0, Canvas.gl.RGBA, 1, 1, 0, Canvas.gl.RGBA, Canvas.gl.UNSIGNED_BYTE, new Uint8Array([0, 0, 255, 255]));
    Canvas.createFrameBuffer(data.id + 'L');
	Canvas.createTexture(data.id + 'r');
    Canvas.bindTexture(data.id + 'r');
    Canvas.gl.texImage2D(Canvas.gl.TEXTURE_2D, 0, Canvas.gl.RGBA, 1, 1, 0, Canvas.gl.RGBA, Canvas.gl.UNSIGNED_BYTE, new Uint8Array([0, 0, 255, 255]));
    Canvas.createFrameBuffer(data.id + 'R');
	if (data.shaders)
      data.shaders({
        vert: vert.split(/\r?\n/).map((l, i) => `${('000' + (i + 1)).substr(-3, 3)}: ${l}`).join('<br/>\n'),
        frag: frag.split(/\r?\n/).map((l, i) => `${('000' + (i + 1)).substr(-3, 3)}: ${l}`).join('<br/>\n')
      });
    var relay = Object.assign({},
      data, {
        Canvas,
        program,
        uniforms,
		//frag
      }
    );
	//console.log(JSON.stringify(relay, null, 2));
	return relay;
  });
}

function Draw(data) {}

function Imagine(data) {
	//console.log(JSON.stringify(data, null, 2));
    var Canvas = new OCanvas('test');
    data.canvas.width = data.size;
    data.canvas.height = data.size;
    Canvas.canvas = data.canvas;
	data.Canvas = Canvas;
  var loader = data.textures ? dat => Promise.all(data.textures.map((tex, i) => {
    let { program, Canvas } = dat;
    let {
      id,
      name,
      resolution,
      path
    } = tex;
    name = name ? 'u_' + name : `u_tex_${i}`;
    var resname = name + '_res';
    program.initUniform(name);
    if (resolution) {
      program.initUniform(resname);
      program.setUniform(resname, 'vector', 2, 'f', resolution);
    }
    Canvas.createTexture(id);
    Canvas.bindTexture(id);
    Canvas.gl.texImage2D(Canvas.gl.TEXTURE_2D, 0, Canvas.gl.RGBA, 1, 1, 0, Canvas.gl.RGBA, Canvas.gl.UNSIGNED_BYTE, new Uint8Array([0, 0, 255, 255]));
    return new Promise((resolve, reject) => {
      var image = new Image();
      image.onload = imageLoad.bind(null, resolve, Canvas, program, id, i, path, image);
      image.onerror = reject;
      //image.src = path;
      image.src = '../../' + path;
    });
  })) : () => Promise.resolve();
  var passthrough = loadFragmentShader('pass-through').then(frag => {
    var vert = data.vert;
    var uniforms = {
      u_resolution: {
        type: 'list',
        dim: 2,
        datatype: 'f',
        values: [data.size, data.size]
      }
    };
    var Canvas = data.Canvas;
    var program = Canvas.programFromShaders('pass-through-p', 'pass-through-v', vert, 'pass-through-f', frag, onerr);
    Canvas.useProgram('pass-through-p');
    program.initUniform('u_source');
    program.initUniforms(uniforms);
    program.initAttribute("a_position");
    Canvas.createBuffer('positionBuffer');
    Canvas.bindBuffer('positionBuffer', 'ARRAY_BUFFER');
    Canvas.clear('COLOR_BUFFER_BIT');
    program.enableAttribute("a_position");
    program.vertexAttribPointer("a_position", 2, Canvas.gl.FLOAT, false, 0, 0);
    var x1 = -1;
    var x2 = 1;
    var y1 = -1;
    var y2 = 1;
    Canvas.setBufferData('ARRAY_BUFFER', 'STATIC_DRAW', new Float32Array([
      x1, y1,
      x2, y1,
      x1, y2,
      x1, y2,
      x2, y1,
      x2, y2,
    ]));
	return program;
  });
  return Promise.all([loadVertexShader(), passthrough, loader]).then(pass => {
    let [vert, passthrough] = pass;
    return Promise.all([
	  Promise.resolve(passthrough),
      Setup(Object.assign({ vert, id: `main` }, data.main), data)
    ].concat(data.auxiliary.map((resource, i) => {
      return Setup(Object.assign({ vert, id: `ax${('00' + i).substr(-2, 2)}` }, resource), data);
    })));
  }).then(relays => {
	//console.log(JSON.stringify(relays, null, 2));
    let [passthrough, main] = relays;
    var aux = relays.slice(2, relays.length);
    
    var relay = main;
    var Canvas = relay.Canvas;
    var program = relay.program;
    var uniforms = relay.uniforms;
    if (relay.time)
      uniforms.u_time.value = 0;
    var epoch = Date.now();
    var update = relay.update;
    var tup = (uniforms, frame) => {
      uniforms.u_time.value = Date.now() - epoch;
    };
    if (relay.time)
      update = update ? (uniforms, frame) => {
        update(uniforms, frame);
        tup(uniforms, frame);
      } : tup;
    var sup = updateSeeds.bind(null, relay);
    if (relay.dynamicseed)
      update = update ? (uniforms, frame) => {
        update(uniforms, frame);
        sup(uniforms, relay.seed + frame);
      } : sup;
    else if (relay.seed !== undefined)
      sup(uniforms, relay.seed);
    var frame = 0;
    if (update)
      update(uniforms, frame);
    Canvas.useProgram('mainp');
    program.setUniforms(uniforms);
    var modifiers = relay.modifiers;
    var frameIndex = modifiers.length;
    modifiers = modifiers.concat([
      [0, '000']
    ]);
    Canvas.bindFrameBuffer('mainL');
	Canvas.gl.drawArrays(Canvas.gl.TRIANGLES, 0, 6);
	Canvas.bindFrameBuffer(null);
    Canvas.useProgram('pass-through');
	Canvas.bindTexture('mainl');
    passthrough.setUniform(`u_source`, 'list', 1, 'i', 0);
	Canvas.gl.drawArrays(Canvas.gl.TRIANGLES, 0, 6);
    new Promise((resolve, reject) => {
      try {
        Canvas.gl.finish();
        resolve();
      }
      catch (err) {
        reject(err);
      }
    }).then(() => {
      Save(Canvas.canvas.toDataURL(), relay.subdir, relay.basename, modifiers);
      if (relay.frames) {
        var interval = window.setInterval(() => {
          frame++;
          if (frame >= relay.frames) {
            window.clearInterval(interval);
            return;
          }
          if (update) {
            update(uniforms, frame);
            program.setUniforms(uniforms);
          }
          Canvas.gl.drawArrays(Canvas.gl.TRIANGLES, 0, 6);
          new Promise((resolve, reject) => {
            try {
              Canvas.gl.finish();
              resolve();
            }
            catch (err) {
              reject(err);
            }
          }).then(() => {
            modifiers[frameIndex][0] = frame;
            Save(Canvas.canvas.toDataURL(), relay.subdir, relay.basename, modifiers);
          });
        }, relay.frameRate);
      }
    });
  });
}

var name = 'fractal-simplex-noise-2d';
loadFragmentShader(name).then(shader => {
  fs.writeFile(`shaders/Fragment-${name}.glsl`, shader, 'utf8', err => {
    if(err)
      console.error(err);
  });
});

module.exports = {
  Imagine
};
