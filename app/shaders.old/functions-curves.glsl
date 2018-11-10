#define CURVE1(a) (a)
#define CURVE3(a) (a * a * (3.0 - 2.0 * a))
#define CURVE3FUNC(t) t curve3(t a) { a = constrain(a, 0.0, 1.0); return CURVE3(a); }
CURVE3FUNC(float)
CURVE3FUNC(vec2)
CURVE3FUNC(vec3)
CURVE3FUNC(vec4)
#define CURVE5(a) (a * a * a * (10.0 + a * (6.0 * a - 15.0)))
#define CURVE5FUNC(t) t curve5(t a) { a = constrain(a, 0.0, 1.0); return CURVE5(a); }
CURVE5FUNC(float)
CURVE5FUNC(vec2)
CURVE5FUNC(vec3)
CURVE5FUNC(vec4)
