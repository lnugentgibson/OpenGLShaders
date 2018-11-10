var identity = x => x;

function OProgram(canvas, id) {
  var program;
  var uniforms = {};
  var attributes = {};
  Object.defineProperties(this, {
    toString: {
      get: () => (() => `Program-${id}`)
    },
    id: {
      get: () => id
    },
    canvas: {
      get: () => canvas
    },
    gl: {
      get: () => canvas.gl
    },
    program: {
      get: () => program
    },
    create: {
      get: () => (() => {
        if(!canvas) return;
        if(!canvas.gl) throw new Error('InvalidOperation: webgl is undefined');
        program = canvas.gl.createProgram();
      })
    },
    attachShader: {
      get: () => (shader => {
        if(!canvas) return;
        if(!canvas.gl) throw new Error('InvalidOperation: webgl is undefined');
        if(!program) return;
        canvas.gl.attachShader(program, shader);
      })
    },
    link: {
      get: () => (() => {
        if(!canvas) return;
        if(!canvas.gl) throw new Error('InvalidOperation: webgl is undefined');
        if(!program) return;
        canvas.gl.linkProgram(program);
        if (!canvas.gl.getProgramParameter(program, canvas.gl.LINK_STATUS)) {
          console.error('program failed to link');
          console.error(canvas.gl.getProgramInfoLog(program));
        }
      })
    },
    setup: {
      get: () => ((vs, fs) => {
        this.create();
        this.attachShader(vs);
        this.attachShader(fs);
        this.link();
      })
    },
    initUniform: {
        get: () => (name => {
            if(!canvas) return;
            if(!canvas.gl) throw new Error('InvalidOperation: webgl is undefined');
            if(!program) return;
            var uniform = canvas.gl.getUniformLocation(program, name);
            if(uniform !== undefined)
                uniforms[name] = uniform;
        })
    },
    initUniforms: {
        get: () => (names => {
          if(Array.isArray(names))
            names.forEach(name => this.initUniform(name));
          else
            Object.keys(names).forEach(name => {
              this.initUniform(name);
              var v = names[name];
              if(v.value !== undefined)
                this.setUniform(name, v.type, v.dim, v.datatype, v.value);
              else if(v.values !== undefined)
                this.setUniform.apply(this, [name, v.type, v.dim, v.datatype].concat(v.values));
              else
                this.setUniform(name, undefined, undefined, undefined, v);
            });
        })
    },
    setUniform: {
        get: () => ((name, type, dim, datatype, v0, v1, v2, v3) => {
            if(!canvas) throw new Error('InvalidOperation: canvas is undefined');
            if(!canvas.gl) throw new Error('InvalidOperation: webgl is undefined');
            if(!program) throw new Error('InvalidOperation: program is undefined');
            var uniform = uniforms[name];
            if(uniform === undefined) throw new Error(`InvalidOperation: uniform ${name} is undefined`);
            if(dim === undefined) {
              if(v1 === undefined) {
                if(Array.isArray(v0))
                  dim = type == 'matrix' ? Math.floor(Math.sqrt(v0.length)) : v0.length;
                else
                  dim = 1;
              }
              else if(v2 === undefined)
                dim = 2;
              else if(v3 === undefined)
                dim = 3;
              else
                dim = 4;
            }
            if(datatype === undefined)
              datatype = 'f';
            var f;
            if(type)
              switch(type) {
                case 'list':
                  f = `uniform${dim}${datatype}`;
                  console.log(`${f}: ${name}, ${v0}, ${v1}, ${v2}, ${v3}`);
                  canvas.gl[f](uniform, v0, v1, v2, v3);
                  break;
                case 'vector':
                  f = `uniform${dim}${datatype}v`;
                  console.log(`${f}: ${name}, ${v0}`);
                  canvas.gl[f](uniform, v0);
                  break;
                case 'matrix':
                  f = `uniformMatrix${dim}${datatype}v`;
                  console.log(`${f}: ${name}, ${v0}`);
                  canvas.gl[f](uniform, false, v0);
                  break;
              }
        })
    },
    setUniforms: {
        get: () => (names => {
          /*
          console.log({
            func: 'setUniforms',
            uniforms: names
          });
          //*/
          Object.keys(names).forEach(name => {
            /*
            console.log({
              func: 'setUniforms',
              name,
              uniform: names[name]
            });
            //*/
            var v = names[name];
            if(v.value !== undefined)
              this.setUniform(name, v.type, v.dim, v.datatype, v.value);
            else if(v.values !== undefined)
              this.setUniform.apply(this, [name, v.type, v.dim, v.datatype].concat(v.values));
            else
              this.setUniform(name, undefined, undefined, undefined, v);
          });
        })
    },
    initAttribute: {
        get: () => (name => {
            if(!canvas) throw new Error('InvalidOperation: canvas is undefined');
            if(!canvas.gl) throw new Error('InvalidOperation: webgl is undefined');
            if(!program) throw new Error('InvalidOperation: program is undefined');
            var attribute = canvas.gl.getAttribLocation(program, name);
            if(attribute !== undefined)
                attributes[name] = attribute;
        })
    },
    enableAttribute: {
        get: () => (name => {
            if(!canvas) throw new Error('InvalidOperation: canvas is undefined');
            if(!canvas.gl) throw new Error('InvalidOperation: webgl is undefined');
            if(!program) throw new Error('InvalidOperation: program is undefined');
            var attribute = attributes[name];
            if(attribute === undefined) throw new Error(`InvalidOperation: attribute ${name} is undefined`);
            canvas.gl.enableVertexAttribArray(attribute);
        })
    },
    vertexAttribPointer: {
        get: () => ((name, size, type, normalize, stride, offset) => {
            if(!canvas) throw new Error('InvalidOperation: canvas is undefined');
            if(!canvas.gl) throw new Error('InvalidOperation: webgl is undefined');
            if(!program) throw new Error('InvalidOperation: program is undefined');
            var attribute = attributes[name];
            if(attribute === undefined) throw new Error(`InvalidOperation: attribute ${name} is undefined`);
            canvas.gl.vertexAttribPointer(attribute, size, type, normalize, stride, offset);
        })
    }
  });
}

function OCanvas(name) {
  var canvas;
  var gl;
  var width, height;
  var clear = [0, 0, 0, 0];
  var shaders = {};
  var programs = {};
  var buffers = {};
  var textures = {};
  var framebuffers = {};
  Object.defineProperties(this, {
    name: {
      get: () => name
    },
    canvas: {
      get: () => canvas,
      set: v => {
        canvas = v;
        if(canvas) {
          gl = canvas.getContext('webgl');
          if(width && height) {
            canvas.width = width;
            canvas.height = height;
          }
          else if(canvas.width && canvas.height) {
            width = canvas.width;
            height = canvas.height;
          }
          this.clearColor = [0, 0, 0, 0];
        }
        else
          gl = null;
      }
    },
    width: {
      get: () => width ? width : canvas && canvas.width ? width = canvas.width : undefined,
      set: v => {
        if(v) {
          width = v;
          if(canvas)
            canvas.width = width;
        }
      }
    },
    height: {
      get: () => height ? height : canvas && canvas.height ? height = canvas.height : undefined,
      set: v => {
        if(v) {
          height = v;
          if(canvas)
            canvas.height = height;
        }
      }
    },
    gl: {
      get: () => gl
    },
    viewport: {
      get: () => ((x, y, w, h) => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        if(x === null || y === null)
          x = y = 0;
        if(!w && canvas)
          w = canvas.width;
        if(!w && canvas)
          h = canvas.height;
        gl.viewport(x, y, w, h);
      })
    },
    clearColor: {
      get: () => clear.map(identity),
      set: v => {
        if(v)
          for(var i = 0; i < 4 && i < v.length; i++)
            clear[i] = v[1];
        else
          clear = [0, 0, 0, 0];
        if(gl)
          gl.clearColor.apply(gl, clear);
      }
    },
    clear: {
      get: () => (mask => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        gl.clear(gl[mask]);
      })
    },
    createShader: {
      get: () => ((id, type) => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        var shader = gl.createShader(gl[type]);
        shaders[id] = shader;
      })
    },
    setShaderSource: {
      get: () => ((id, src) => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        var shader = shaders[id];
        if(!shader) return;
        gl.shaderSource(shader, src);
      })
    },
    compileShader: {
      get: () => ((id) => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        var shader = shaders[id];
        if(!shader) return;
        gl.compileShader(shader);
        if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
          console.error('shader failed to compile');
          console.error(gl.getShaderInfoLog(shader));
          gl.deleteShader(shader);
        }
      })
    },
    setupShader: {
      get: () => ((id, type, src, onerr) => {
        this.createShader(id, type);
        this.setShaderSource(id, src);
        this.compileShader(id, onerr);
      })
    },
    createProgram: {
      get: () => (id => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        var program = new OProgram(this, id);
        program.create();
        programs[id] = program;
        return program;
      })
    },
    attachShader: {
      get: () => ((id, sid) => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        var program = programs[id];
        if(!program) return;
        var shader = shaders[sid];
        if(!shader) return;
        program.attachShader(shader);
      })
    },
    linkProgram: {
      get: () => ((id) => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        var program = programs[id];
        if(!program) return;
        program.link();
      })
    },
    setupProgram: {
      get: () => ((id, vid, fid) => {
        var program = new OProgram(this, id);
        var vs = shaders[vid];
        if(!vs) return;
        var fs = shaders[fid];
        if(!fs) return;
        program.setup(vs, fs);
        programs[id] = program;
        return program;
      })
    },
    programFromShaders: {
      get: () => ((id, vid, vsrc, fid, fsrc) => {
        var program = new OProgram(this, id);
        this.setupShader(vid, 'VERTEX_SHADER', vsrc);
        this.setupShader(fid, 'FRAGMENT_SHADER', fsrc);
        var vs = shaders[vid];
        if(!vs) return;
        var fs = shaders[fid];
        if(!fs) return;
        program.setup(vs, fs);
        programs[id] = program;
        return program;
      })
    },
    useProgram: {
      get: () => (id => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        var program = programs[id];
        if(!program) return;
        if(!program.program) return;
        gl.useProgram(program.program);
      })
    },
    createBuffer: {
      get: () => (id => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        var buffer = gl.createBuffer();
        buffers[id] = buffer;
      })
    },
    bindBuffer: {
      get: () => ((id, target) => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        var buffer = buffers[id];
        if(!buffer) throw new Error('InvalidOperation: buffer is undefined');
        gl.bindBuffer(gl[target], buffer);
      })
    },
    setBufferData: {
      get: () => ((target, usage, data) => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        gl.bufferData(gl[target], data, gl[usage]);
      })
    },
    createTexture: {
      get: () => (id => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        //var texture = gl.createTexture();
        //textures[id] = texture;
        console.log('creating texture ' + id);
        textures[id] = gl.createTexture();
      })
    },
    bindTexture: {
      get: () => ((id, target) => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        if(!target)
          target = 'TEXTURE_2D';
        var texture = textures[id];
        console.log({
          id,
          texture,
          target,
          gltarget: gl[target]
        });
        if(texture == undefined) throw new Error(`InvalidOperation: texture ${id} is undefined`);
        gl.bindTexture(gl[target], texture);
      })
    },
    setTextureIParameter: {
      get: () => ((target, parameter, value) => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        if(!target)
          target = 'TEXTURE_2D';
        gl.texParameteri(gl[target], gl[parameter], gl[value]);
      })
    },
    setTexturePixels: {
      get: () => ((target, level, internalformat, format, type, pixels) => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        if(!target)
          target = 'TEXTURE_2D';
        if(!level)
          level = 0;
        gl.texImage2D(gl[target], level, gl[internalformat], gl[format], gl[type], pixels);
      })
    },
    createFrameBuffer: {
      get: () => (id => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        console.log('creating texture ' + id);
        framebuffers[id] = gl.createFramebuffer();
      })
    },
    bindFrameBuffer: {
      get: () => ((id, target) => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        if(!target)
          target = 'FRAMEBUFFER';
        var framebuffer = framebuffers[id];
        console.log({
          id,
          framebuffer,
          target,
          gltarget: gl[target]
        });
        if(framebuffer == undefined && id != null) throw new Error(`InvalidOperation: framebuffer ${id} is undefined`);
        gl.bindFramebuffer(gl[target], framebuffer);
      })
    },
    attachFramebufferTexture: {
      get: () => ((id, attachmentPoint, tid, target) => {
        if(!gl) throw new Error('InvalidOperation: webgl is undefined');
        if(!attachmentPoint)
          attachmentPoint = 'FRAMEBUFFER';
        if(!target)
          target = 'TEXTURE_2D';
        var framebuffer = framebuffers[id];
        var texture = textures[tid];
        console.log({
          id,
          framebuffer,
          tid,
          texture,
          attachmentPoint,
          glattachmentPoint: gl[attachmentPoint],
          target,
          gltarget: gl[target]
        });
        if(framebuffer == undefined) throw new Error(`InvalidOperation: framebuffer ${id} is undefined`);
        if(texture == undefined) throw new Error(`InvalidOperation: texture ${id} is undefined`);
        gl.framebufferTexture2D(gl.FRAMEBUFFER, gl[attachmentPoint], gl[target], texture, 0);
      })
    }
  });
}