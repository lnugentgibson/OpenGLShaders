var fs = require('fs');

function times(n, f) {
  var arr = [];
  for (var i = 0; i < n; i++)
    arr.push(f(i));
  return arr;
}

var functions = {
  "unitvectors": {
    "type": "macro",
    "code": "#define o2 vec2(0.0)\n#define i2 vec2(1.0, 0.0)\n#define j2 vec2(0.0, 1.0)\n#define o3 vec3(0.0)\n#define i3 vec3(1.0, 0.0, 0.0)\n#define j3 vec3(0.0, 1.0, 0.0)\n#define k3 vec3(0.0, 0.0, 1.0)\n#define o4 vec4(0.0)\n#define i4 vec4(1.0, 0.0, 0.0, 0.0)\n#define j4 vec4(0.0, 1.0, 0.0, 0.0)\n#define k4 vec4(0.0, 0.0, 1.0, 0.0)\n#define l4 vec4(0.0, 0.0, 0.0, 1.0)"
  },
  "constrain": {
    "type": "function",
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "float",
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype constrain($returntype v, float n, float x) { return max(min(v, x), n); }"
  },
  "curve1": {
    "type": "macro",
    "code": "#define CURVE1(a) (a)"
  },
  "curve3": {
    "type": "macro",
    "code": "#define CURVE3(a) (a * a * (3.0 - 2.0 * a))"
  },
  "curve5": {
    "type": "macro",
    "code": "#define CURVE5(a) (a * a * a * (10.0 + a * (6.0 * a - 15.0)))"
  },
  "curve": {
    "type": "macro",
    "input": [
      {
        "id": "curvetype",
        "type": "option",
        "options": [
          "1",
          "3",
          "5"
        ],
        "defaultValue": 1
      }
    ],
    "code": "#define CURVE CURVE$curvetype",
    "dependencies": {
      "curve1": "simple",
      "curve3": "simple",
      "curve5": "simple"
    }
  },
  "Curve3": {
    "type": "function",
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "float",
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype curve3($returntype a) { a = constrain(a, 0.0, 1.0); return CURVE3(a); }",
    "dependencies": {
      "curve3": "simple",
      "constrain": "simple"
    }
  },
  "Curve5": {
    "type": "function",
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "float",
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype curve5($returntype a) { a = constrain(a, 0.0, 1.0); return CURVE5(a); }",
    "dependencies": {
      "curve5": "simple",
      "constrain": "simple"
    }
  },
  "perlin": {
    "type": "function",
    "parameters": [
      {
        "id": "dim",
        "values": [
          2,
          3,
          4
        ]
      }
    ],
    "code": "float perlinGradient(vec$dim p, mat$dim dm, vec$dim dv, vec$dim delta, vec4 s) {\n  vec$dim r = floor(p);\n  vec$dim f = CURVE(fract(p)), F = 1.0 - f;\n  float o = 0.0;\n  $$for i:dim:\n  :for(float ind$i = 0.0; ind$i < 2.0; ind$i++)$$\n  {\n    vec$dim b = vec$dim($$for i:dim:, :ind$i$$);\n    vec$dim B = 1.0 - b;\n    vec$dim R = r + b;\n    vec$dim v = rand$dim(R, dm, dv, delta, s) * 2.0 - 1.0;\n    v /= length(v);\n    o += dot(v, p - R) * CURVE(prod_e(b * f + B * F));\n  }\n  return o / 0.5625;\n}",
    "dependencies": {
      "curve": "simple",
      "rand2": "simple",
      "rand3": "simple",
      "rand4": "simple",
      "prod_e": "simple"
    }
  },
  "perlinft1": {
    "type": "function",
    "code": "float perlinGradient(vec2 p, sampler2D n1, vec2 r1, float scale) {\n  vec2 r = floor(p);\n  vec2 f = CURVE(fract(p)), F = 1.0 - f;\n  float o = 0.0;\n  for(float i = 0.0; i < 2.0; i++)\n  for(float j = 0.0; j < 2.0; j++) {\n    vec2 b = vec2(i, j);\n    vec2 B = 1.0 - b;\n    vec2 R = r + b;\n    vec2 v = texture2D(n1, scale * R / r1).rg * 2.0 - 1.0;\n    v /= length(v);\n    o += dot(v, p - R) * CURVE(prod_e(b * f + B * F));\n  }\n  return o / 0.5625;\n}",
    "dependencies": {
      "curve": "simple",
      "prod_e": "simple"
    }
  },
  "rand": {
    "type": "macro",
    "input": [
      {
        "id": "randtype",
        "type": "option",
        "options": [
          "sinfract",
          "permute"
        ],
        "defaultValue": 0
      }
    ],
    "code": "#define rand $randtype",
    "dependencies": {
      "Sinfract": "simple",
      "VSeededPermute": "simple"
    }
  },
  "rand1": {
    "type": "function",
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "float rand1(vec$dim uv, mat$dim dm, vec$dim dv, vec4 s) { return rand(sin(2.0 * pow(qlmap(uv, dm, dv), 6.0 / 11.0)), s); }",
    "dependencies": {
      "rand": "simple",
      "qlmap": "simple"
    }
  },
  "rand2": {
    "type": "function",
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "vec2 rand2(vec$dim uv, mat$dim dm, vec$dim dv, vec$dim delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); return rand(sin(2.0 * pow(vec2(p1, p2), vec2(6.0 / 11.0))), s); }",
    "dependencies": {
      "rand": "simple",
      "qlmap": "simple"
    }
  },
  "rand3": {
    "type": "function",
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "vec3 rand3(vec$dim uv, mat$dim dm, vec$dim dv, vec$dim delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); float p3 = qlmap(uv + 2.0 * delta, dm, dv); return rand(sin(2.0 * pow(vec3(p1, p2, p3), vec3(6.0 / 11.0))), s); }",
    "dependencies": {
      "rand": "simple",
      "qlmap": "simple"
    }
  },
  "rand4": {
    "type": "function",
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "vec4 rand4(vec$dim uv, mat$dim dm, vec$dim dv, vec$dim delta, vec4 s) { float p1 = qlmap(uv, dm, dv); float p2 = qlmap(uv + delta, dm, dv); float p3 = qlmap(uv + 2.0 * delta, dm, dv); float p4 = qlmap(uv + 3.0 * delta, dm, dv); return rand(sin(2.0 * pow(vec4(p1, p2, p3, p4), vec4(6.0 / 11.0))), s); }",
    "dependencies": {
      "rand": "simple",
      "qlmap": "simple"
    }
  },
  "sinfract": {
    "type": "macro",
    "code": "#define SINFRACT(x, s) fract(sin(x * s.x + s.y) * s.z + s.w)"
  },
  "Sinfract": {
    "type": "function",
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "float",
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype sinfract($returntype x, vec4 s) { return SINFRACT(x, s); }",
    "dependencies": {
      "sinfract": "simple"
    }
  },
  "SinfractRange": {
    "type": "function",
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "float",
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype sinfract($returntype x, vec4 s) { return SINFRACT(x, s); }",
    "dependencies": {
      "sinfract": "simple"
    }
  },
  "permute": {
    "type": "macro",
    "code": "#define PERMUTE(x) (MOD289(((x*34.0)+1.0)*x)/289.0)",
    "dependencies": {
      "mod289": "simple"
    }
  },
  "permuteRange": {
    "type": "macro",
    "code": "#define PERMUTER(x, o, r) (MOD289(((x*34.0)+1.0)*x)/289.0*r+o)",
    "dependencies": {
      "mod289": "simple"
    }
  },
  "Permute": {
    "type": "function",
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "float",
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype permute($returntype x) { return PERMUTE(x); }",
    "dependencies": {
      "permute": "simple"
    }
  },
  "PermuteRange": {
    "type": "function",
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "float",
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype permute($returntype x, float o, float r) { return PERMUTER(x, o, r); }",
    "dependencies": {
      "permuteRange": "simple"
    }
  },
  "FSeededPermute": {
    "type": "function",
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "float",
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype permute($returntype x, float seed) { x = PERMUTE(x); seed = PERMUTE(seed); $returntype xseed = x * seed; return PERMUTE(xseed); }",
    "dependencies": {
      "permute": "simple"
    }
  },
  "FSeededPermuteRange": {
    "type": "function",
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "float",
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype permute($returntype x, float o, float r, float seed) { x = PERMUTE(x); seed = PERMUTE(seed); $returntype xseed = x * seed; return PERMUTER(xseed, o, r); }",
    "dependencies": {
      "permute": "simple",
      "permuteRange": "simple"
    }
  },
  "VSeededPermute": {
    "type": "function",
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "float",
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype permute($returntype x, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); $returntype xseed = mul(x, seed); return PERMUTE(xseed); }",
    "dependencies": {
      "permute": "simple",
      "mul": "simple"
    }
  },
  "VSeededPermuteRange": {
    "type": "function",
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "float",
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype permute($returntype x, float o, float r, vec4 seed) { x = PERMUTE(x); seed = PERMUTE(seed); $returntype xseed = mul(x, seed); return PERMUTER(xseed, o, r); }",
    "dependencies": {
      "permute": "simple",
      "permuteRange": "simple",
      "mul": "simple"
    }
  },
  "mul": {
    "code": "#define MUL(t) t mul(t a, t b) { return a * b; }\nMUL(float)\nMUL(vec2)\nMUL(vec3)\nMUL(vec4)\n#define MULTF(t) t mul(t a, float b) { return a * b; }\nMULTF(vec2)\nMULTF(vec3)\nMULTF(vec4)\n#define MULF(t) float mul(float a, t b) { return a * b.x; }\nMULF(vec2)\nMULF(vec3)\nMULF(vec4)\n#define MUL2(t) vec2 mul(vec2 a, t b) { return a * b.xy; }\nMUL2(vec3)\nMUL2(vec4)\nvec3 mul(vec3 a, vec4 b) { return a * b.xyz; }\nvec3 mul(vec3 a, vec2 b) { return a * vec3(b, 1.0); }\nvec4 mul(vec4 a, vec2 b) { return a * vec4(b, b); }\nvec4 mul(vec4 a, vec3 b) { return a * vec4(b, 1.0); }"
  },
  "mod289": {
    "type": "macro",
    "code": "#define MOD289(x) MOD(x, 289.0)",
    "dependencies": {
      "mod": "simple"
    }
  },
  "Mod289": {
    "type": "function",
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "float",
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype mod289($returntype x) { return MOD289(x); }",
    "dependencies": {
      "mod289": "simple"
    }
  },
  "mod": {
    "code": "#define MOD(a, b) (a - floor(a / b) * b)"
  },
  "Mod": {
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "float",
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype Mod($returntype a, $returntype b) {return MOD(a, b);}",
    "dependencies": {
      "mod": "simple"
    }
  },
  "ModFloat": {
    "parameters": [
      {
        "id": "returntype",
        "values": [
          "vec2",
          "vec3",
          "vec4"
        ]
      }
    ],
    "code": "$returntype Mod($returntype a, float b) {return MOD(a, b);}",
    "dependencies": {
      "mod": "simple"
    }
  },
  "qlmap": {
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "float qlmap(vec$dim v, mat$dim dm, vec$dim dv) { return Dot(Dot(dm, v) + dv, v); }",
    "dependencies": {
      "dotmv": "simple",
      "dotvv": "simple"
    }
  },
  "lmap": {
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "float lmap(vec$dim v, vec$dim d) { return Dot(d, v); }",
    "dependencies": {
      "dotmv": "simple",
      "dotvv": "simple"
    }
  },
  "qmap": {
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "float qmap(vec$dim v, mat$dim d) { return Dot(Dot(d, v), v); }",
    "dependencies": {
      "dotmv": "simple",
      "dotvv": "simple"
    }
  },
  "dotmv": {
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "vec$dim Dot(mat$dim m, vec$dim v) { return m * v; }"
  },
  "dotvv": {
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "float Dot(vec$dim a, vec$dim b) { return dot(a, b); }"
  },
  "dotvs": {
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "float Dot(vec$dim v) { return dot(v, v); }"
  },
  "noise": {
    "type": "macro",
    "input": [
      {
        "id": "noisetype",
        "type": "option",
        "options": [
          "perlinGradient",
          "simplexGradient"
        ],
        "defaultValue": 1
      }
    ],
    "code": "#define NOISE $noisetype",
    "dependencies": {
      "perlin": "simple",
      "simplex": "simple"
    }
  },
  "prod_e": {
    "type": "function",
    "code": "float prod_e(vec2 v) {return v.x * v.y;}\nfloat prod_e(vec3 v) {return v.x * v.y * v.z;}\nfloat prod_e(vec4 v) {return v.x * v.y * v.z * v.w;}"
  },
  "fbm": {
    "type": "function",
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "float fbm(vec$dim p, int iterations, mat$dim ss, float as, mat$dim dm, vec$dim dv, vec$dim d1, vec$dim d2, vec4 s) {\n    float o = 0.0, a = 1.0;\n    for(int i = 0; i < NOISEITERATIONS; i++) {\n      if(i < iterations) {\n        o += NOISEGET(NOISE(p + float(i) * d2, dm, dv, d1, s)) * a;\n        p *= ss;\n        a *= as;\n      }\n    }\n    return o;\n}",
    "dependencies": {
      "noise": "simple",
      "noiseget": "simple",
      "noiseiterations": "simple"
    }
  },
  "Triple": {
    "type": "function",
    "code": "float Triple(vec3 a, vec3 b, vec3 c) {\n    return dot(a, cross(b, c));\n}"
  },
  "demote": {
    "type": "function",
    "code": "mat2 demote2(mat3 m) {\n\treturn mat2(m[0].xy, m[1].xy);\n}\nmat2 demote2(mat4 m) {\n\treturn mat2(m[0].xy, m[1].xy);\n}\nmat3 demote3(mat4 m) {\n\treturn mat3(m[0].xyz, m[1].xyz, m[2].xyz);\n}\nvec2 demote2(vec3 v) {\n\treturn v.xy;\n}\nvec2 demote2(vec4 v) {\n\treturn v.xy;\n}\nvec3 demote3(vec4 v) {\n\treturn v.xyz;\n}"
  },
  "promote": {
    "type": "function",
    "code": "mat3 promote3(mat2 m) {\n\treturn mat3(vec3(m[0], 0.0), vec3(m[1], 0.0), vec3(0.0));\n}\nmat4 promote4(mat2 m) {\n\treturn mat4(vec4(m[0], 0.0, 0.0), vec4(m[1], 0.0, 0.0), vec4(0.0), vec4(0.0));\n}\nmat4 promote4(mat3 m) {\n\treturn mat4(vec4(m[0], 0.0), vec4(m[1], 0.0), vec4(m[2], 0.0), vec4(0.0));\n}\nvec3 promote3(vec2 v) {\n\treturn vec3(v, 0.0);\n}\nvec4 promote4(vec2 v) {\n\treturn vec4(v, 0.0, 0.0);\n}\nvec4 promote4(vec3 v) {\n\treturn vec4(v, 0.0);\n}"
  },
  "noiseget": {
    "type": "macro",
    "input": [
      {
        "id": "noisegettype",
        "type": "option",
        "options": [
          "x",
          "x.dis"
        ],
        "defaultValue": 0
      }
    ],
    "code": "#define NOISEGET(x) $noisegettype"
  },
  "noiseiterations": {
    "type": "macro",
    "input": [
      {
        "id": "noiseiterations",
        "type": "int",
        "range": [
          2,
          20
        ],
        "defaultValue": 10
      }
    ],
    "code": "#define NOISEITERATIONS $noiseiterations"
  },
  "triangle": {
    "type": "function",
    "code": "float triangle(vec2 a, vec2 b, vec2 c) {\n    vec2 B = b - a, C = c - a;\n    vec3 B3 = vec3(B, 0.0), C3 = vec3(C, 0.0);\n    //return sqrt(Dot(B) * Dot(C) - Dot2(B, C)) / 2.0;\n    return 0.5 * length(cross(B3, C3));\n}"
  },
  "tetrahedron": {
    "type": "function",
    "code": "float tetrahedron(vec3 a, vec3 b, vec3 c, vec3 d) {\n    vec3 B = b - a, C = c - a, D = d - a;\n    return abs(Triple(B, C, D)) / 6.0;\n}",
    "dependencies": {
      "Triple": "simple"
    }
  },
  "pentachoron": {
    "type": "function",
    "code": "float pentachoron(vec4 a, vec4 b, vec4 c, vec4 d, vec4 e) {\n    vec4 B = b - a, C = c - a, D = d - a, E = e - a;\n    return (\n        B.x * Triple(C.yzw, D.yzw, E.yzw) -\n        C.x * Triple(B.yzw, D.yzw, E.yzw) +\n        D.x * Triple(B.yzw, C.yzw, E.yzw) -\n        E.x * Triple(B.yzw, C.yzw, D.yzw)\n    ) / 24.0;\n}",
    "dependencies": {
      "Triple": "simple"
    }
  },
  "translation2A": {
    "type": "function",
    "code": "mat3 translation2dAffine(vec2 shift) {\n\treturn mat3(i3, j3, vec3(shift, 1.0));\n}"
  },
  "rotation2": {
    "type": "function",
    "code": "mat2 rotation2d(float angle) {\n\treturn mat2(cos(angle), sin(angle), -sin(angle), cos(angle));\n}"
  },
  "rotation2A": {
    "type": "function",
    "code": "mat3 rotation2dAffine(float angle) {\n\treturn mat3(cos(angle), sin(angle), 0.0, -sin(angle), cos(angle), 0.0, k3);\n}"
  },
  "red_e": {
    "type": "function",
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "float red_e(vec$dim v, float f) {return Dot(v, vec$dim(f));}",
    "dependencies": {
      "dotvv": "simple"
    }
  },
  "sum_e": {
    "type": "function",
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "float sum_e(vec$dim v) {return red_e(v, 1.0);}",
    "dependencies": {
      "red_e": "simple"
    }
  },
  "max_e": {
    "type": "function",
    "code": "float max_e(vec2 v) { return max(v.x, v.y); }\nfloat max_e(vec3 v) { return max(v.x, max(v.y, v.z)); }\nfloat max_e(vec4 v) { return max(max(v.x, v.y), max(v.z, v.w)); }"
  },
  "min_e": {
    "type": "function",
    "code": "float min_e(vec2 v) { return min(v.x, v.y); }\nfloat min_e(vec3 v) { return min(v.x, min(v.y, v.z)); }\nfloat min_e(vec4 v) { return min(min(v.x, v.y), min(v.z, v.w)); }"
  },
  "sortD3": {
    "type": "function",
    "code": "ivec3 sortD(vec3 v) {\n    if(v.x >= v.y && v.x >= v.z && v.y >= v.z)\n        return ivec3(1, 2, 3);\n    if(v.x >= v.y && v.x >= v.z && v.z >= v.y)\n        return ivec3(1, 3, 2);\n    if(v.y >= v.z && v.y >= v.x && v.z >= v.x)\n        return ivec3(2, 3, 1);\n    if(v.y >= v.z && v.y >= v.x && v.x >= v.z)\n        return ivec3(2, 1, 3);\n    if(v.z >= v.x && v.z >= v.y && v.x >= v.y)\n        return ivec3(3, 1, 2);\n    if(v.z >= v.x && v.z >= v.y && v.y >= v.x)\n        return ivec3(3, 2, 1);\n}"
  },
  "sortD4": {
    "type": "function",
    "code": "ivec4 sortD(vec4 v) {\n    float x = v.x, y = v.y, z = v.z, w = v.w;\n    if(\n        x >= y && x >= z && x >= w &&\n        y >= z && y >= w &&\n        z >= w\n    )\n        return ivec4(1, 2, 3, 4);\n    if(\n        x >= y && x >= z && x >= w &&\n        y >= z && y >= w &&\n        w >= z\n    )\n        return ivec4(1, 2, 4, 3);\n    if(\n        x >= y && x >= z && x >= w &&\n        z >= y && z >= w &&\n        y >= w\n    )\n        return ivec4(1, 3, 2, 4);\n    if(\n        x >= y && x >= z && x >= w &&\n        z >= y && z >= w &&\n        w >= y\n    )\n        return ivec4(1, 3, 4, 2);\n    if(\n        x >= y && x >= z && x >= w &&\n        w >= y && w >= z &&\n        y >= z\n    )\n        return ivec4(1, 4, 2, 3);\n    if(\n        x >= y && x >= z && x >= w &&\n        w >= y && w >= z &&\n        z >= y\n    )\n        return ivec4(1, 4, 3, 2);\n    if(\n        y >= x && y >= z && y >= w &&\n        x >= z && x >= w &&\n        z >= w\n    )\n        return ivec4(2, 1, 3, 4);\n    if(\n        y >= x && y >= z && y >= w &&\n        x >= z && x >= w &&\n        w >= z\n    )\n        return ivec4(2, 1, 4, 3);\n    if(\n        y >= x && y >= z && y >= w &&\n        z >= x && z >= w &&\n        x >= w\n    )\n        return ivec4(2, 3, 1, 4);\n    if(\n        y >= x && y >= z && y >= w &&\n        z >= x && z >= w &&\n        w >= x\n    )\n        return ivec4(2, 3, 4, 1);\n    if(\n        y >= x && y >= z && y >= w &&\n        w >= x && w >= z &&\n        x >= z\n    )\n        return ivec4(2, 4, 1, 3);\n    if(\n        y >= x && y >= z && y >= w &&\n        w >= x && w >= z &&\n        z >= x\n    )\n        return ivec4(2, 4, 3, 1);\n    if(\n        z >= x && z >= y && z >= w &&\n        x >= y && x >= w &&\n        y >= w\n    )\n        return ivec4(3, 1, 2, 4);\n    if(\n        z >= x && z >= y && z >= w &&\n        x >= y && x >= w &&\n        w >= y\n    )\n        return ivec4(3, 1, 4, 2);\n    if(\n        z >= x && z >= y && z >= w &&\n        y >= x && y >= w &&\n        x >= w\n    )\n        return ivec4(3, 2, 1, 4);\n    if(\n        z >= x && z >= y && z >= w &&\n        y >= x && y >= w &&\n        w >= x\n    )\n        return ivec4(3, 2, 4, 1);\n    if(\n        z >= x && z >= y && z >= w &&\n        w >= x && w >= y &&\n        x >= y\n    )\n        return ivec4(3, 4, 1, 2);\n    if(\n        z >= x && z >= y && z >= w &&\n        w >= x && w >= y &&\n        y >= x\n    )\n        return ivec4(3, 4, 2, 1);\n    if(\n        w >= x && w >= y && w >= z &&\n        x >= y && x >= z &&\n        y >= z\n    )\n        return ivec4(4, 1, 2, 3);\n    if(\n        w >= x && w >= y && w >= z &&\n        x >= y && x >= z &&\n        z >= y\n    )\n        return ivec4(4, 1, 3, 2);\n    if(\n        w >= x && w >= y && w >= z &&\n        y >= x && y >= z &&\n        x >= z\n    )\n        return ivec4(4, 2, 1, 3);\n    if(\n        w >= x && w >= y && w >= z &&\n        y >= x && y >= z &&\n        z >= x\n    )\n        return ivec4(4, 2, 3, 1);\n    if(\n        w >= x && w >= y && w >= z &&\n        z >= x && z >= y &&\n        x >= y\n    )\n        return ivec4(4, 3, 1, 2);\n    if(\n        w >= x && w >= y && w >= z &&\n        z >= x && z >= y &&\n        y >= x\n    )\n        return ivec4(4, 3, 2, 1);\n}"
  },
  "pulse": {
    "type": "function",
    "code": "float pulse(float n, float x, float a) {\n\treturn step(n, a) - step(x, a);\n}"
  },
  "smoothpulse": {
    "type": "function",
    "code": "float smoothpulse(float nn, float nx, float xn, float xx, float a) {\n\treturn smoothstep(nn, nx, a) - smoothstep(xn, xx, a);\n}"
  },
  "transpose": {
    "code": "mat2 transpose(mat2 m) {\n\treturn mat2(\n\t\tm[0][0], m[1][0],\n\t\tm[0][1], m[1][1]\n\t);\n}\nmat3 transpose(mat3 m) {\n\treturn mat3(\n\t\tm[0][0], m[1][0], m[2][0],\n\t\tm[0][1], m[1][1], m[2][1],\n\t\tm[0][2], m[1][2], m[2][2]\n\t);\n}\nmat4 transpose(mat4 m) {\n\treturn mat4(\n\t\tm[0][0], m[1][0], m[2][0], m[3][0],\n\t\tm[0][1], m[1][1], m[2][1], m[3][1],\n\t\tm[0][2], m[1][2], m[2][2], m[3][2],\n\t\tm[0][3], m[1][3], m[2][3], m[3][3]\n\t);\n}"
  },
  "colExclusion": {
    "code": "mat3 colExclusion(mat3 m, int c) {\n\treturn mat3(c == 0 ? m[1] : m[0], c == 2 ? m[1] : m[2], o3);\n}\nmat4 colExclusion(mat4 m, int c) {\n\treturn mat4(c == 0 ? m[1] : m[0], c > 1 ? m[1] : m[2], c == 3 ? m[2] : m[3], o4);\n}"
  },
  "exclusionTranspose": {
    "code": "mat2 exclusionTranspose(mat3 m, int r, int c) {\n\treturn demote2(colExclusion(transpose(colExclusion(m, c)), r));\n}\nmat3 exclusionTranspose(mat4 m, int r, int c) {\n\treturn demote3(colExclusion(transpose(colExclusion(m, c)), r));\n}",
    "dependencies": {
      "transpose": "simple",
      "colExclusion": "simple"
    }
  },
  "exclusion": {
    "code": "mat2 exclusion(mat3 m, int r, int c) {\n\treturn transpose(demote2(colExclusion(transpose(colExclusion(m, c)), r)));\n}\nmat3 exclusion(mat4 m, int r, int c) {\n\treturn transpose(demote3(colExclusion(transpose(colExclusion(m, c)), r)));\n}",
    "dependencies": {
      "transpose": "simple",
      "colExclusion": "simple",
      "demote": "simple"
    }
  },
  "determinant": {
    "code": "float determinant(mat2 m) {\n\treturn m[0][0] * m[1][1] - m[0][1] * m[1][0];\n}\nfloat determinant(mat3 m) {\n\treturn m[0][0] * determinant(exclusionTranspose(m, 0, 0)) - m[1][0] * determinant(exclusionTranspose(m, 0, 1)) + m[2][0] * determinant(exclusionTranspose(m, 0, 2));\n}\nfloat determinant(mat4 m) {\n\treturn m[0][0] * determinant(exclusionTranspose(m, 0, 0)) - m[1][0] * determinant(exclusionTranspose(m, 0, 1)) + m[2][0] * determinant(exclusionTranspose(m, 0, 2)) + m[3][0] * determinant(exclusionTranspose(m, 0, 3));\n}",
    "dependencies": {
      "exclusionTranspose": "simple"
    }
  },
  "inverse": {
    "code": "mat2 inverse(mat2 m) {\n\treturn mat2(m[1][1], -m[1][0], -m[0][1], m[0][0]) / determinant(m);\n}\nmat3 inverse(mat3 m) {\n\tmat3 adj = mat3(0.0);\n\tfor(int r = 0; r < 3; r++)\n\tfor(int c = 0; c < 3; c++) {\n\t\tint d = r + c, q = d - 2 * (d / 2);\n\t\tadj[c][r] = float(1 - q * 2) * determinant(exclusionTranspose(m, c, r));\n\t}\n\tfloat d = dot(vec3(m[0][0], m[1][0], m[2][0]), adj[0]);\n\treturn adj / d;\n}\nmat4 inverse(mat4 m) {\n\tmat4 adj = mat4(0.0);\n\tfor(int r = 0; r < 4; r++)\n\tfor(int c = 0; c < 4; c++) {\n\t\tint d = r + c, q = d - 2 * (d / 2);\n\t\tadj[c][r] = float(1 - q * 2) * determinant(exclusionTranspose(m, c, r));\n\t}\n\tfloat d = dot(vec4(m[0][0], m[1][0], m[2][0], m[3][0]), adj[0]);\n\treturn adj / d;\n}",
    "dependencies": {
      "exclusionTranspose": "simple",
      "determinant": "simple"
    }
  },
  "simplex": {
    "type": "function",
    "code": "float simplexGradient(vec2 p, mat2 dm, vec2 dv, vec2 delta, vec4 s) {\n    float skew = (sqrt(3.0) - 1.0) / 2.0, unskew = (1.0 - 1.0 / sqrt(3.0)) / 2.0;\n    vec2 P = p + sum_e(p) * skew;\n    vec2 L = floor(P);\n    vec2 f = fract(P);\n    vec2 c1 = L;\n    vec2 c2 = c1 + (f.x >= f.y ? i2 : j2);\n    vec2 c3 = L + 1.0;\n    c1 -= sum_e(c1) * unskew;\n    c2 -= sum_e(c2) * unskew;\n    c3 -= sum_e(c3) * unskew;\n    float A = triangle(c1, c2, c3);\n    vec3 w = vec3(\n      triangle( p, c2, c3) / A,\n      triangle(c1,  p, c3) / A,\n      triangle(c1, c2,  p) / A\n    );\n    w = CURVE(w);\n    vec3 v = vec3(\n      dot(normalize(rand2(c1, dm, dv, delta, s) * 2.0 - 1.0), p - c1),\n      dot(normalize(rand2(c2, dm, dv, delta, s) * 2.0 - 1.0), p - c2),\n      dot(normalize(rand2(c3, dm, dv, delta, s) * 2.0 - 1.0), p - c3)\n    );\n    return dot(w, v) / (w.x + w.y + w.z) / 0.5329;\n}\nfloat simplexGradient(vec3 p, mat3 dm, vec3 dv, vec3 delta, vec4 s) {\n    float skew = 1.0 / 3.0, unskew = 1.0 / 6.0;\n    vec3 P = p + sum_e(p) * skew;\n    vec3 L = floor(P);\n    vec3 f = fract(P);\n    ivec3 o = sortD(f);\n    vec3 c1 = L;\n    vec3 c2 = c1 + (o.x == 1 ? i3 : o.x == 2 ? j3 : k3);\n    vec3 c3 = c2 + (o.y == 1 ? i3 : o.y == 2 ? j3 : k3);\n    vec3 c4 = L + 1.0;\n    c1 -= sum_e(c1) * unskew;\n    c2 -= sum_e(c2) * unskew;\n    c3 -= sum_e(c3) * unskew;\n    c4 -= sum_e(c4) * unskew;\n    float V = tetrahedron(c1, c2, c3, c4);\n    vec4 w = vec4(\n      tetrahedron( p, c2, c3, c4) / V,\n      tetrahedron(c1,  p, c3, c4) / V,\n\t  tetrahedron(c1, c2,  p, c4) / V,\n\t  tetrahedron(c1, c2, c3,  p) / V\n    );\n    w = CURVE(w);\n    vec4 v = vec4(\n      dot(normalize(rand3(c1, dm, dv, delta, s) * 2.0 - 1.0), p - c1),\n      dot(normalize(rand3(c2, dm, dv, delta, s) * 2.0 - 1.0), p - c2),\n      dot(normalize(rand3(c3, dm, dv, delta, s) * 2.0 - 1.0), p - c3),\n      dot(normalize(rand3(c4, dm, dv, delta, s) * 2.0 - 1.0), p - c4)\n    );\n    return dot(w, v) / (w.x + w.y + w.z + w.w);\n}\nfloat simplexGradient(vec4 p, mat4 dm, vec4 dv, vec4 delta, vec4 s) {\n    float skew = 1.0 / 3.0, unskew = 1.0 / 6.0;\n    vec4 P = p + sum_e(p) * skew;\n    vec4 L = floor(P);\n    vec4 f = fract(P);\n    ivec4 o = sortD(f);\n    vec4 c1 = L;\n    vec4 c2 = c1 + (o.x == 1 ? i4 : o.y == 1 ? j4 : o.z == 1 ? k4 : l4);\n    vec4 c3 = c2 + (o.x == 2 ? i4 : o.y == 2 ? j4 : o.z == 2 ? k4 : l4);\n    vec4 c4 = c2 + (o.x == 3 ? i4 : o.y == 3 ? j4 : o.z == 3 ? k4 : l4);\n    vec4 c5 = L + 1.0;\n    c1 -= sum_e(c1) * unskew;\n    c2 -= sum_e(c2) * unskew;\n    c3 -= sum_e(c3) * unskew;\n    c4 -= sum_e(c4) * unskew;\n    c5 -= sum_e(c5) * unskew;\n    float H = pentachoron(c1, c2, c3, c4, c5);\n    vec3 w1 = vec3(\n      pentachoron( p, c2, c3, c4, c5) / H,\n      pentachoron(c1,  p, c3, c4, c5) / H,\n      pentachoron(c1, c2,  p, c4, c5) / H\n    );\n    vec2 w2 = vec2(\n      pentachoron(c1, c2, c3,  p, c5) / H,\n      pentachoron(c1, c2, c3, c4,  p) / H\n    );\n    w1 = CURVE(w1);\n    w2 = CURVE(w2);\n    vec3 v1 = vec3(\n      dot(normalize(rand4(c1, dm, dv, delta, s) * 2.0 - 1.0), p - c1),\n      dot(normalize(rand4(c2, dm, dv, delta, s) * 2.0 - 1.0), p - c2),\n      dot(normalize(rand4(c3, dm, dv, delta, s) * 2.0 - 1.0), p - c3)\n    );\n    vec2 v2 = vec2(\n      dot(normalize(rand4(c4, dm, dv, delta, s) * 2.0 - 1.0), p - c4),\n      dot(normalize(rand4(c5, dm, dv, delta, s) * 2.0 - 1.0), p - c5)\n    );\n    return (dot(w1, v1) + dot(w2, v2)) / (w1.x + w1.y + w1.z + w2.x + w2.y);\n}",
    "dependencies": {
      "curve": "simple",
      "rand2": "simple",
      "rand3": "simple",
      "rand4": "simple",
      "sum_e": "simple",
      "triangle": "simple",
      "tetrahedron": "simple",
      "pentachoron": "simple",
      "unitvectors": "simple",
      "sortD3": "simple",
      "sortD4": "simple"
    }
  },
  "simplexft1": {
    "type": "function",
    "code": "float simplexGradient(vec2 p, sampler2D n1, vec2 r1, float scale) {\n    float skew = (sqrt(3.0) - 1.0) / 2.0, unskew = (1.0 - 1.0 / sqrt(3.0)) / 2.0;\n    vec2 P = p + sum_e(p) * skew;\n    ivec2 L = ivec2(floor(P));\n    vec2 f = fract(P);\n    ivec2 c1 = L;\n    ivec2 c2 = c1 + ivec2(f.x >= f.y ? i2 : j2);\n    ivec2 c3 = L + ivec2(1);\n    vec2 C1 = vec2(c1) - sum_e(vec2(c1)) * unskew;\n    vec2 C2 = vec2(c2) - sum_e(vec2(c2)) * unskew;\n    vec2 C3 = vec2(c3) - sum_e(vec2(c3)) * unskew;\n    float A = triangle(C1, C2, C3);\n    vec3 w = vec3(\n      triangle( p, C2, C3) / A,\n      triangle(C1,  p, C3) / A,\n      triangle(C1, C2,  p) / A\n    );\n    w = CURVE(w);\n    vec3 v = vec3(\n      dot(normalize(texture2D(n1, scale * vec2(c1) / r1).rg * 2.0 - 1.0), p - C1),\n      dot(normalize(texture2D(n1, scale * vec2(c2) / r1).rg * 2.0 - 1.0), p - C2),\n      dot(normalize(texture2D(n1, scale * vec2(c3) / r1).rg * 2.0 - 1.0), p - C3)\n    );\n    return dot(w, v) / (w.x + w.y + w.z) / 0.5329;\n    //return (w.x + w.y + w.z) * 0.5;\n    //return min(min(length(p - c1), length(p - c2)), length(p - c3));\n}",
    "dependencies": {
      "curve": "simple",
      "unitvectors": "simple"
    }
  },
  "voro": {
    "parameters": [
      {
        "id": "dim",
        "values": [
          "2",
          "3",
          "4"
        ]
      }
    ],
    "code": "struct voro$dim {\n\tfloat dis;\n\tfloat blend;\n\tfloat edge;\n\tvec$dim gen;\n\tvec3 color;\n};"
  },
  "voronoi": {
    "code": "voro2 voronoi( in vec2 x, mat2 dm, vec2 dv, vec2 delta, vec4 s ) {\n    ivec2 p = ivec2(floor( x ));\n    vec2 f = fract( x );\n\n    float res = 1.0e20;\n    float res2 = 1.0e20;\n    float eres = 0.0;\n    ivec2 center;\n    vec2 ray;\n    const int range = 2;\n    for( int j=-range; j<=range; j++ )\n    for( int i=-range; i<=range; i++ )\n    {\n        //ivec2 b = ivec2( i, j );\n        //ivec2 c = b + p;\n        ivec2 c = ivec2( i, j ) + p;\n        vec2 v = rand2( vec2(c), dm, dv, delta, s );\n        vec2 r = vec2(c) + v;\n        vec2 d = r - x;\n        float dis = length( d );\n\n\t\tif(dis < res) {\n\t\t\tcenter = c;\n\t\t\tray = r;\n\t\t}\n\t\tres2 = min(max(res, dis), res2);\n        res = min(res, dis);\n        eres += exp( -FALLOUT*dis );\n    }\n    float edge = 1.0e20;\n    for( int j=-range; j<=range; j++ )\n    for( int i=-range; i<=range; i++ )\n    {\n        //ivec2 b = ivec2( i, j );\n        //ivec2 c = b + center;\n        ivec2 c = ivec2( i, j ) + center;\n        vec2 v = rand2( vec2(c), dm, dv, delta, s );\n        vec2 r = vec2(c) + v;\n        float dis = abs(dot(0.5 * (r + ray) - x, normalize(r - ray) ));\n\n        edge = min(edge, dis);\n    }\n    vec3 c = rand3(vec2(center), dm, dv, delta, s);\n    c /= max_e(c);\n    return voro2(\n    \tres,\n\t\t1.0 +(1.0/FALLOUT)*log( res ),\n\t\tedge,\n\t\tray,\n\t\tc\n\t);\n}\nvoro3 voronoi( in vec3 x, mat3 dm, vec3 dv, vec3 delta, vec4 s ) {\n    ivec3 p = ivec3(floor( x ));\n    vec3 f = fract( x );\n\n    float res = 1.0e20;\n    float res2 = 1.0e20;\n    float eres = 0.0;\n    ivec3 center;\n    vec3 ray;\n    const int range = 2;\n    for( int k=-range; k<=range; k++ )\n    for( int j=-range; j<=range; j++ )\n    for( int i=-range; i<=range; i++ )\n    {\n        //ivec3 b = ivec2( i, j, k );\n        //ivec3 c = b + p;\n        ivec3 c = ivec3( i, j, k ) + p;\n        vec3 v = rand3( vec3(c), dm, dv, delta, s );\n        vec3 r = vec3(c) + v;\n        vec3 d = r - x;\n        float dis = length( d );\n\n\t\tif(dis < res) {\n\t\t\tcenter = c;\n\t\t\tray = r;\n\t\t}\n\t\tres2 = min(max(res, dis), res2);\n        res = min(res, dis);\n        eres += exp( -FALLOUT*dis );\n    }\n    float edge = 1.0e20;\n    for( int k=-range; k<=range; k++ )\n    for( int j=-range; j<=range; j++ )\n    for( int i=-range; i<=range; i++ )\n    {\n        //ivec3 b = ivec2( i, j, k );\n        //ivec3 c = b + center;\n        ivec3 c = ivec3( i, j, k ) + center;\n        vec3 v = rand3( vec3(c), dm, dv, delta, s );\n        vec3 r = vec3(c) + v;\n        float dis = abs(dot(0.5 * (r + ray) - x, normalize(r - ray) ));\n\n        edge = min(edge, dis);\n    }\n    vec3 c = rand3(vec3(center), dm, dv, delta, s);\n    c /= max_e(c);\n    return voro3(\n    \tres,\n\t\t1.0 +(1.0/FALLOUT)*log( res ),\n\t\tedge,\n\t\tray,\n\t\tc\n\t);\n}\nvoro4 voronoi( in vec4 x, mat4 dm, vec4 dv, vec4 delta, vec4 s ) {\n\treturn voro4(0.0, 0.0, 0.0, vec4(0.0), vec3(0.0));\n}",
    "dependencies": {
      "voro": "simple",
      "rand2": "simple",
      "rand3": "simple",
      "rand4": "simple",
      "max_e": "simple"
    }
  },
  "voronoift1": {
    "code": "voro2 voronoi( in vec2 x, sampler2D n1, vec2 r1, float scale, float amp ) {\n    ivec2 p = ivec2(floor( x ));\n    vec2 f = fract( x );\n\n    float res = 1.0e20;\n    float res2 = 1.0e20;\n    float eres = 0.0;\n    ivec2 center;\n    vec2 ray;\n    const int range = 2;\n    for( int j=-range; j<=range; j++ )\n    for( int i=-range; i<=range; i++ )\n    {\n        //ivec2 b = ivec2( i, j );\n        //ivec2 c = b + p;\n        ivec2 c = ivec2( i, j ) + p;\n        vec2 v = (texture2D(n1, scale * vec2(c) / r1).rg - 0.5) * amp;\n        vec2 r = vec2(c) + v;\n        vec2 d = r - x;\n        float dis = length( d );\n\n\t\tif(dis < res) {\n\t\t\tcenter = c;\n\t\t\tray = r;\n\t\t}\n\t\tres2 = min(max(res, dis), res2);\n        res = min(res, dis);\n        eres += exp( -FALLOUT*dis );\n    }\n    float edge = 1.0e20;\n    for( int j=-range; j<=range; j++ )\n    for( int i=-range; i<=range; i++ )\n    {\n        //ivec2 b = ivec2( i, j );\n        //ivec2 c = b + center;\n        ivec2 c = ivec2( i, j ) + center;\n        vec2 v = texture2D(n1, scale * vec2(c) / r1).rg * amp;\n        vec2 r = vec2(c) + v;\n        float dis = abs(dot(0.5 * (r + ray) - x, normalize(r - ray) ));\n\n        edge = min(edge, dis);\n    }\n    vec3 c = vec3(0.0);\n    return voro2(\n    \tres,\n\t\t1.0 +(1.0/FALLOUT)*log( res ),\n\t\tedge,\n\t\tray,\n\t\tc\n\t);\n}",
    "dependencies": {
      "voro": "simple"
    }
  },
  "line2d": {
    "code": "struct line2d {\n\tvec2 base;\n\tvec2 target;\n\tvec2 midpoint;\n\tvec2 vector;\n\tvec2 ray;\n\tfloat length;\n\tvec2 normal;\n};"
  },
  "line_pp": {
    "code": "line2d Line_point_point(vec2 base, vec2 target, vec2 other) {\n\tvec2 vector = target - base;\n\tvec2 ray = normalize(vector);\n\treturn line2d(\n\t\tbase,\n\t\ttarget,\n\t\t(base + target) * 0.5,\n\t\tvector,\n\t\tray,\n\t\tlength(vector),\n\t\tnormalize(other - base - dot(other - base, ray) * ray)\n\t);\n}",
    "dependencies": {
      "line2d": "simple"
    }
  },
  "intersect": {
    "code": "vec2 intersect(line2d l1, line2d l2) {\n\tvec2 d = l2.base - l1.base;\n\tmat2 A = mat2(l1.ray, -l2.ray);\n\tmat2 A1 = mat2(d, -l2.ray);\n\treturn determinant(A1) / determinant(A) * l1.ray + l1.base;\n}",
    "dependencies": {
      "line2d": "simple"
    }
  },
  "drawline": {
    "code": "float drawline(vec2 p, line2d line, float thickness) {\n\tvec2 vector = p - line.base;\n\treturn pulse(-thickness * 0.5, thickness * 0.5, dot(line.normal, vector));\n}",
    "dependencies": {
      "line2d": "simple",
      "pulse": "simple"
    }
  },
  "drawline_pp": {
    "code": "float drawline(vec2 p, vec2 base, vec2 target, vec2 other, float thickness) {\n\treturn drawline(p, Line_point_point(base, target, other), thickness);\n}",
    "dependencies": {
      "drawline": "simple"
    }
  },
  "drawray": {
    "code": "float drawray(vec2 p, line2d line, float thickness) {\n\tvec2 vector = p - line.base;\n\treturn pulse(-thickness * 0.5, thickness * 0.5, dot(line.normal, vector)) * step(0.0, dot(vector, line.ray));\n}",
    "dependencies": {
      "line2d": "simple",
      "pulse": "simple"
    }
  },
  "drawray_pp": {
    "code": "float drawray(vec2 p, vec2 base, vec2 target, vec2 other, float thickness) {\n\treturn drawray(p, Line_point_point(base, target, other), thickness);\n}",
    "dependencies": {
      "drawray": "simple"
    }
  },
  "drawlinesegment": {
    "code": "float drawlinesegment(vec2 p, line2d line, float thickness) {\n\tvec2 vector = p - line.base;\n\t//return smoothpulse(-thickness * 0.5, 0.0, 0.0, thickness * 0.5, dot(line.normal, vector)) * pulse(0.0, line.length, dot(vector, line.ray));\n\treturn pulse(-thickness * 0.5, thickness * 0.5, dot(line.normal, vector)) * pulse(0.0, line.length, dot(vector, line.ray));\n}",
    "dependencies": {
      "line2d": "simple",
      "pulse": "simple"
    }
  },
  "drawlinesegment_pp": {
    "code": "float drawlinesegment(vec2 p, vec2 base, vec2 target, vec2 other, float thickness) {\n\treturn drawlinesegment(p, Line_point_point(base, target, other), thickness);\n}",
    "dependencies": {
      "drawlinesegment": "simple"
    }
  },
  "drawdashedlinesegment": {
    "code": "float drawdashedlinesegment(vec2 p, line2d line, float thickness, float freq) {\n\tvec2 vector = p - line.base;\n\t//return smoothpulse(-0.5, 0.0, 0.0, 0.5, dot(line.normal, vector)) * pulse(0.0, line.length, dot(vector, line.ray));// * step(0.0, sin(dot(vector, line.ray)));\n\treturn pulse(-thickness * 0.5, thickness * 0.5, dot(line.normal, vector)) * pulse(0.0, line.length, dot(vector, line.ray)) * step(0.0, sin(dot(vector, freq * line.ray)));\n}",
    "dependencies": {
      "line2d": "simple",
      "pulse": "simple"
    }
  },
  "drawdashedlinesegment_pp": {
    "code": "float drawdashedlinesegment(vec2 p, vec2 base, vec2 target, vec2 other, float thickness, float freq) {\n\treturn drawdashedlinesegment(p, Line_point_point(base, target, other), thickness, freq);\n}",
    "dependencies": {
      "drawdashedlinesegment": "simple"
    }
  },
  "circle2d": {
    "code": "struct circle2d {\n\tvec2 center;\n\tfloat radius;\n};"
  },
  "drawcircle": {
    "code": "float drawcircle(vec2 p, circle2d circle, float thickness) {\n\tvec2 vector = p - circle.center;\n\treturn pulse(-thickness * 0.5, thickness * 0.5, length(vector) - circle.radius);\n}",
    "dependencies": {
      "circle2d": "simple",
      "pulse": "simple"
    }
  },
  "parallelogram2d": {
    "code": "struct parallelogram2d {\n\tvec2 base;\n\tfloat majorLength;\n\tfloat minorLength;\n\tfloat diagonalLength;\n\tvec2 majorRay;\n\tvec2 minorRay;\n\tvec2 diagonalRay;\n\tvec2 majorVector;\n\tvec2 minorVector;\n\tvec2 majorCorner;\n\tvec2 minorCorner;\n\tvec2 diagonalCorner;\n\tvec2 centerPoint;\n};"
  },
  "parallelogram2dPoint": {
    "code": "struct parallelogram2dPoint {\n\tparallelogram2d rect;\n\tvec2 point;\n\tvec2 vector;\n\tvec2 ray;\n\tvec2 coord;\n\tfloat distance;\n\tfloat majorDistance;\n\tfloat minorDistance;\n\tfloat diagonalDistance;\n\tfloat radius;\n\tint inside;\n\tivec2 placement;\n};",
    "dependencies": {
      "parallelogram2d": "simple"
    }
  },
  "rect_cos": {
    "code": "parallelogram2d Rectangle_corner_size(vec2 base, vec2 size) {\n\tint x = size.y > size.x ? 2 : 1;\n\tfloat majorLength = x == 2 ? size.y : size.x;\n\tfloat minorLength = x == 1 ? size.y : size.x;\n\tvec2 majorRay = x == 2 ? j2 : i2;\n\tvec2 minorRay = x == 1 ? j2 : i2;\n\treturn parallelogram2d(\n\t\tbase, // base\n\t\tmajorLength, // majorLength\n\t\tminorLength, // minorLength\n\t\tlength(size), //diagonalLength\n\t\tmajorRay, // majorRay\n\t\tminorRay, // minorRay\n\t\tnormalize(size), // diagonalRay\n\t\tmajorRay * majorLength, // majorVector\n\t\tminorRay * minorLength, // minorVector\n\t\tbase + majorLength * majorRay, // majorCorner\n\t\tbase + minorLength * minorRay, // minorCorner\n\t\tbase + size, // diagonalCorner\n\t\tbase + size * 0.5 // centerPoint\n\t);\n}",
    "dependencies": {
      "parallelogram2d": "simple"
    }
  },
  "sqr_cos": {
    "code": "parallelogram2d Square_corner_size(vec2 base, float size) {\n\treturn parallelogram2d(\n\t\tbase, // base\n\t\tsize, // majorLength\n\t\tsize, // minorLength\n\t\tsize * sqrt(2.0), //diagonalLength\n\t\ti2, // majorRay\n\t\tj2, // minorRay\n\t\tvec2(size), // diagonalRay\n\t\ti2 * size, // majorVector\n\t\tj2 * size, // minorVector\n\t\tbase + size * i2, // majorCorner\n\t\tbase + size * j2, // minorCorner\n\t\tbase + size, // diagonalCorner\n\t\tbase + size * 0.5 // centerPoint\n\t);\n}",
    "dependencies": {
      "parallelogram2d": "simple"
    }
  },
  "sqr_cosa": {
    "code": "parallelogram2d Square_corner_size_angle(vec2 base, float size, float angle) {\n\tvec2 x = vec2(cos(angle), sin(angle));\n\tvec2 y = vec2(-sin(angle), cos(angle));\n\tvec2 xy = x + y;\n\treturn parallelogram2d(\n\t\tbase, // base\n\t\tsize, // majorLength\n\t\tsize, // minorLength\n\t\tsize * sqrt(2.0), //diagonalLength\n\t\tx, // majorRay\n\t\ty, // minorRay\n\t\tvec2(size), // diagonalRay\n\t\tx * size, // majorVector\n\t\ty * size, // minorVector\n\t\tbase + size * x, // majorCorner\n\t\tbase + size * y, // minorCorner\n\t\tbase + size * xy, // diagonalCorner\n\t\tbase + size * xy * 0.5 // centerPoint\n\t);\n}",
    "dependencies": {
      "parallelogram2d": "simple"
    }
  },
  "sqr_cesa": {
    "code": "parallelogram2d Square_center_size_angle(vec2 center, float size, float angle) {\n\tvec2 x = vec2(cos(angle), sin(angle));\n\tvec2 y = vec2(-sin(angle), cos(angle));\n\treturn Square_corner_size_angle(center - (x + y) * size * 0.5, size, angle);\n}",
    "dependencies": {
      "parallelogram2d": "simple",
      "sqr_cosa": "simple"
    }
  },
  "Parallelogram2dPoint": {
    "code": "parallelogram2dPoint Parallelogram2dPoint(vec2 p, parallelogram2d rect) {\n\tvec2 vector = p - rect.base;\n\tvec2 ray = p - rect.centerPoint;\n\tmat2 A = transpose(mat2(rect.majorVector, rect.minorVector));\n\tmat2 i = inverse(A);\n\tvec2 coord = i * vector;\n\treturn parallelogram2dPoint (\n\t\trect, // rect\n\t\tp, // point\n\t\tvector, // vector\n\t\tray, // ray\n\t\tcoord, // coord\n\t\tlength(vector), // distance\n\t\tlength(p - rect.majorCorner), // majorDistance\n\t\tlength(p - rect.minorCorner), // minorDistance\n\t\tlength(p - rect.diagonalCorner), // diagonalDistance\n\t\tlength(ray), // radius\n\t\tcoord.x >= 0.0 && coord.y >= 0.0 && coord.x <= 1.0 && coord.y <= 1.0 ? 0 : 1, // inside\n\t\tivec2(coord.x < 0.0 ? -1 : (coord.x > 1.0 ? 1 : 0), coord.y < 0.0 ? -1 : (coord.y > 1.0 ? 1 : 0)) // placement\n\t);\n}",
    "dependencies": {
      "parallelogram2d": "simple",
      "parallelogram2dPoint": "simple"
    }
  },
  "triangle2d": {
    "code": "struct triangle2d {\n\tvec2 base;\n\tline2d leg0;\n\tline2d leg1;\n\tline2d leg2;\n\tline2d median0;\n\tline2d median1;\n\tline2d median2;\n\tline2d pbisector0;\n\tline2d pbisector1;\n\tline2d pbisector2;\n\tline2d altitude0;\n\tline2d altitude1;\n\tline2d altitude2;\n\tline2d abisector0;\n\tline2d abisector1;\n\tline2d abisector2;\n\tvec2 orthocenter;\n\tvec2 centroid;\n\tcircle2d incircle;\n\tcircle2d circumcircle;\n};",
    "dependencies": {
      "line2d": "simple",
      "circle2d": "simple"
    }
  },
  "triangle2dPoint": {
    "code": "struct triangle2dPoint {\n\ttriangle2d tri;\n\tvec2 point;\n\tvec2 vector;\n\tvec2 coord;\n\tvec3 baryocentric;\n\tfloat distance;\n\tfloat majorDistance;\n\tfloat minorDistance;\n\tint inside;\n\tivec3 placement;\n};",
    "dependencies": {
      "triangle2d": "simple"
    }
  },
  "squares": {
    "code": "parallelogram2dPoint squares(vec2 p) {\n\tvec2 f = floor(p);\n\tparallelogram2d rect = Square_corner_size(f, 1.0);\n\treturn Parallelogram2dPoint(p, rect);\n}",
    "dependencies": {
      "parallelogram2dPoint": "simple",
      "Parallelogram2dPoint": "simple",
      "sqr_cos": "simple"
    }
  },
  "diamonds": {
    "code": "parallelogram2dPoint diamonds(vec2 p, float size) {\n\tvec2 f = floor(p);\n\tparallelogram2d rect = Square_center_size_angle(f + 0.5, size, 3.1415926535 * 0.25);\n\treturn Parallelogram2dPoint(p, rect);\n}",
    "dependencies": {
      "parallelogram2dPoint": "simple",
      "Parallelogram2dPoint": "simple",
      "sqr_cesa": "simple"
    }
  },
  "triangle_ppp": {
    "code": "triangle2d Triangle_3point(vec2 base, vec2 p1, vec2 p2) {\n\tvec2 centroid = (base + p1 + p2) / 3.0;\n\tline2d lined = Line_point_point(p1, p2, base - p2);\n\tline2d line1 = Line_point_point(base, p1, lined.vector);\n\tline2d line2 = Line_point_point(base, p2, -lined.vector);\n\tvec2 b0 = normalize(line1.ray + line2.ray);\n\tvec2 b1 = normalize(-line1.ray + lined.ray);\n\tvec2 b2 = normalize(-line2.ray - lined.ray);\n\tline2d median0 = Line_point_point(lined.midpoint, base, lined.ray);\n\tline2d median1 = Line_point_point(line1.midpoint, p2, line1.ray);\n\tline2d median2 = Line_point_point(line2.midpoint, p1, line2.ray);\n\tline2d pbisector0 = Line_point_point(lined.midpoint, lined.midpoint + lined.normal, lined.ray);\n\tline2d pbisector1 = Line_point_point(line1.midpoint, line1.midpoint + line1.normal, line1.ray);\n\tline2d pbisector2 = Line_point_point(line2.midpoint, line2.midpoint + line2.normal, line2.ray);\n\tvec2 circumcenter = intersect(pbisector1, pbisector2);\n\tline2d altitude0 = Line_point_point(base, base - dot(-line1.vector, lined.normal) * lined.normal, lined.ray);\n\tline2d altitude1 = Line_point_point(p1, p1 - dot(line1.vector, line2.normal) * line2.normal, line1.ray);\n\tline2d altitude2 = Line_point_point(p2, p2 - dot(line2.vector, line1.normal) * line1.normal, line2.ray);\n\tvec2 orthocenter = intersect(altitude1, altitude2);\n\tline2d abisector0 = Line_point_point(base, base + b0, lined.ray);\n\tline2d abisector1 = Line_point_point(p1, p1 + b1, line1.ray);\n\tline2d abisector2 = Line_point_point(p2, p2 + b2, line2.ray);\n\tvec2 incenter = intersect(abisector1, abisector2);\n\tcircle2d incircle = circle2d(incenter, dot(incenter - base, line1.normal));\n\tcircle2d circumcircle = circle2d(circumcenter, length(circumcenter - base));\n\treturn triangle2d(\n\t\tbase, // base\n\t\tlined, // leg0\n\t\tline1, // leg1\n\t\tline2, // leg2\n\t\tmedian0, // median0\n\t\tmedian1, // median1\n\t\tmedian2, // median2\n\t\tpbisector0, // pbisector0\n\t\tpbisector1, // pbisector1\n\t\tpbisector2, // pbisector2\n\t\taltitude0, // altitude0\n\t\taltitude1, // altitude1\n\t\taltitude2, // altitude2\n\t\tabisector0, // abisector0\n\t\tabisector1, // abisector1\n\t\tabisector2, // abisector2\n\t\torthocenter, // orthocenter\n\t\t//incenter, // incenter\n\t\t//circumcenter, // circumcenter\n\t\tcentroid, // centroid\n\t\tincircle,\n\t\tcircumcircle\n\t);\n}",
    "dependencies": {
      "line2d": "simple",
      "circle2d": "simple",
      "intersect": "simple",
      "triangle2d": "simple"
    }
  },
  "Triangle2dPoint": {
    "code": "triangle2dPoint Triangle2dPoint(vec2 p, triangle2d tri) {\n\tvec2 vector = p - tri.base;\n\tmat2 A = transpose(mat2(tri.leg1.vector, tri.leg2.vector));\n\tmat2 i = inverse(A);\n\tvec2 coord = i * vector;\n\treturn triangle2dPoint (\n\t\ttri, // tri\n\t\tp, // point\n\t\tvector, // vector\n\t\tcoord, // coord\n\t\tvec3(0.0), // baryocentric\n\t\tlength(vector), // distance\n\t\tlength(p - tri.leg1.target), // majorDistance\n\t\tlength(p - tri.leg2.target), // minorDistance\n\t\t0, // inside\n\t\tivec3(0) // placement\n\t);\n}",
    "dependencies": {
      "triangle2d": "simple",
      "triangle2dPoint": "simple",
      "transpose": "simple",
      "inverse": "simple"
    }
  }
};

function addFunction(id, code, deps) {
	if(!id || !id.length || !code || !code.length || functions[id])
		return;
	var f = functions[id] = {};
	f.code = code;
	if(deps && deps.length) {
		f.dependencies = {};
		deps.forEach(d => {
			f.dependencies[d] = 'simple';
		});
	}
}

function addDependencies(id, deps) {
	if(!functions[id] || !deps || !deps.length)
		return;
	var f = functions[id];
	deps.forEach(d => {
		if(!f.dependencies)
			f.dependencies = {};
		f.dependencies[d] = 'simple';
	});
}

fs.writeFile('shaders/functions.json', JSON.stringify(functions, null, 2), 'utf8', (err) => {
	if(err)
		console.error(err);
});

var shaders = {};

fs.writeFile('shaders/shaders.json', JSON.stringify(shaders, null, 2), 'utf8', (err) => {
	if(err)
		console.error(err);
});

function setOrder(id, order) {
  var source = functions[id];
  if(!source)
    console.log(id);
  var o = source.order;
  if(o === undefined || o < order) {
    source.order = order;
    if(source.dependencies)
      Object.keys(source.dependencies).forEach(child => {
        setOrder(child, order + 1);
      });
  }
}

Object.keys(functions).forEach(id => setOrder(id, 0));

fs.writeFile('shaders/functions-ordered.json', JSON.stringify(functions, null, 2), 'utf8', (err) => {
	if(err)
		console.error(err);
});

function transform(input, func) {
  var source = functions[func];
  var out = source.code;
  if(!out)
    console.log(func);
  if (source.input) {
	  if(!source.input.forEach)
		  console.error(func + '.input is not an array');
    source.input.forEach(ivar => {
      //if(ivar.id === 'noisetype')
      //  console.log(JSON.stringify(Object.assign({val: input[ivar.id], input}, ivar), null, 2));
      if (ivar.type === 'option') {
        if (input[ivar.id] !== undefined)
          out = out.replace(RegExp('\\$' + ivar.id, 'g'), ivar.options[input[ivar.id]]);
	    else if(ivar.defaultValue !== undefined)
          out = out.replace(RegExp('\\$' + ivar.id, 'g'), ivar.options[ivar.defaultValue]);
      }
	  else if(ivar.type === 'int') {
		  if(input[ivar.id] !== undefined) {
			  console.log(input[ivar.id]);
			  var ival = parseInt(input[ivar.id], 10);
			  console.log(ivar);
			  if(!ivar.range || ivar.range[0] <= ival && ivar.range[1] >= ival)
				  out = out.replace(RegExp('\\$' + ivar.id, 'g'), ival);
		  }
		  else if(ivar.defaultValue !== undefined)
			  out = out.replace(RegExp('\\$' + ivar.id, 'g'), ivar.defaultValue);
	  }
    });
  }
  out = [out];
  if (source.parameters)
    source.parameters.forEach((param, i) => {
      out = out.reduce((o, c) => {
        return o.concat(param.values.map(val => {
          return c.replace(RegExp('\\$' + param.id, 'g'), val)
            .replace(/\$\$for ([^:]+):([^:]+):([^:]+):(.+)\$\$/g, (match, p1, p2, p3, p4) => {
              if (p2 == param.id)
                return `$$for ${p1}:${val}:${p3}:${p4}$$`;
              else
                return match;
            });
        }));
      }, []);
    });
  out = out.map(c => c.replace(/\$\$for ([^:]+):([^:]+):([^:]+):(.+)\$\$/g, (match, p1, p2, p3, p4) => {
    var len = p2;
    if (len.match(/[0-9]+/))
      len = parseInt(len, 10);
    else
      return match;
    return times(len, i => {
      return p4.replace(RegExp('\\$' + p1, 'g'), i);
    }).join(p3);
  }));
  return out;
}

function depend(input, fns) {
  var master = {}, arr = [];
  fns.forEach(f => {
        if(!master[f]) {
          master[f] = true;
          arr.push(f);
        }
	  if(!functions[f])
		  console.error(f);
    var ds = functions[f].dependencies;
    if(ds)
      Object.keys(ds).forEach(df => {
        if(!master[df]) {
          master[df] = true;
          arr.push(df);
        }
      });
  });
  var i = fns.length;
  while(i < arr.length) {
        if(!master[arr[i]]) {
          master[arr[i]] = true;
          arr.push(arr[i]);
        }
	  if(!functions[arr[i]])
		  console.error(arr[i]);
    var ds = functions[arr[i]].dependencies;
    if(ds)
      Object.keys(ds).forEach(f => {
        if(!master[f]) {
          master[f] = true;
          arr.push(f);
        }
      });
    i++;
  }
  return arr.sort((a, b) => {
    return functions[b].order - functions[a].order;
  }).reduce((a, f) => a.concat(transform(input, f)), []);
}

fs.writeFile('shaders/functions-all.glsl', depend({}, Object.keys(functions)).join('\n\n'), 'utf8', (err) => {
	if(err)
		console.error(err);
});

module.exports = {
  depend
};
