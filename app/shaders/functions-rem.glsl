#define CASTFUNC(f, to, t1, t2) to f(t2 x) { return f(t1(x)); }
CASTFUNC(sum_e, float, vec2, ivec2)
CASTFUNC(sum_e, float, vec3, ivec3)
CASTFUNC(sum_e, float, vec4, ivec4)
CASTFUNC(prod_e, float, vec2, ivec2)
CASTFUNC(prod_e, float, vec3, ivec3)
CASTFUNC(prod_e, float, vec4, ivec4)


vec2 hexvoronoi(in vec2 p, float w, float a, vec2 d1, mat2 d2, vec4 s) {
    float skew = (sqrt(3.0) - 1.0) / 2.0, unskew = (1.0 - 1.0 / sqrt(3.0)) / 2.0;
    vec2 P = p + sum_e(p) * skew;
    ivec2 L = ivec2(floor(P));
    vec2 f = fract(P);
    ivec2 c1 = L;
    ivec2 c2 = c1 + (f.x >= f.y ? I2 : J2);
    ivec2 c3 = L + 1;
    ivec2 c;
    int b = L.y - L.x * 2;
    b -= int(floor(float(b) / 3.0) * 3.0);
    if(b == 0) c = c3;
    if(b == 1) c = c2;
    if(b == 2) c = c1;
    vec2 C = vec2(c) - sum_e(c) * unskew;
    f = p - C;

    ivec2 mb;
    vec2 mr;
    float id = 1.0e20;
    const int range = 3;
    for( int j=-VORORANGE; j<=VORORANGE; j++ )
    for( int i=-VORORANGE; i<=VORORANGE; i++ )
    {
        if(abs(i + j) < VORORANGE + 1) {
            ivec2 b = ivec2( i * 2 + j, i + j * 2 );
            vec2 B = vec2(c + b) - sum_e(c + b) * unskew;
            vec2 rv = rand2(B, 0.0, 1.0, d2, s );
            vec2 r = B - C - f + rv;
            float R = a * perlinGradient1(B * w, d1, s);
            float dis = length( r ) + R;

            if(dis < id) {
                mb = ivec2(i, j);
                mr = r;
                id = dis;
            }
        }
    }
    float bd = 1.0e20;
    for( int j=-VORORANGE; j<=VORORANGE; j++ )
    for( int i=-VORORANGE; i<=VORORANGE; i++ )
    {
        if(abs(i + j) < 2) {
            ivec2 b = ivec2( (i + mb.x) * 2 + (j + mb.y), (i + mb.x) + (j + mb.y) * 2 );
            vec2 B = vec2(c + b) - sum_e(c + b) * unskew;
            vec2 rv = rand2(B, 0.0, 1.0, d2, s );
            vec2 r = B - C - f + rv;
            float R = a * perlinGradient1(B * w, d1, s);
        	float dis = dot( 0.5*(mr+r), normalize(r-mr) );

        bd = min(bd, dis);
        }
    }
    return vec2(id, bd);
}
vec2 hexvoronoi(in vec2 p, float t, float w, float a, mat3 ss, float as, vec2 d1, mat3 d2, mat3 d3, vec4 s) {
    float skew = (sqrt(3.0) - 1.0) / 2.0, unskew = (1.0 - 1.0 / sqrt(3.0)) / 2.0;
    vec2 P = p + sum_e(p) * skew;
    ivec2 L = ivec2(floor(P));
    vec2 f = fract(P);
    ivec2 c1 = L;
    ivec2 c2 = c1 + (f.x >= f.y ? I2 : J2);
    ivec2 c3 = L + 1;
    ivec2 c;
    int b = L.y - L.x * 2;
    b -= int(floor(float(b) / 3.0) * 3.0);
    if(b == 0) c = c3;
    if(b == 1) c = c2;
    if(b == 2) c = c1;
    vec2 C = vec2(c) - sum_e(c) * unskew;
    f = p - C;

    ivec2 mb;
    vec2 mr;
    float id = 1.0e20;
    const int range = 3;
    for( int j=-VORORANGE; j<=VORORANGE; j++ )
    for( int i=-VORORANGE; i<=VORORANGE; i++ )
    {
        if(abs(i + j) < VORORANGE + 1) {
            ivec2 b = ivec2( i * 2 + j, i + j * 2 );
            vec2 B = vec2(c + b) - sum_e(c + b) * unskew;
            vec2 rv = fbm2(vec3(B, t), ss, as, d2, d3, s );
            vec2 r = B - C - f + rv;
            float R = a * perlinGradient1(B * w, d1, s);
            float dis = length( r ) + R;

            if(dis < id) {
                mb = ivec2(i, j);
                mr = r;
                id = dis;
            }
        }
    }
    float bd = 1.0e20;
    for( int j=-VORORANGE; j<=VORORANGE; j++ )
    for( int i=-VORORANGE; i<=VORORANGE; i++ )
    {
        if(abs(i + j) < 2) {
            ivec2 b = ivec2( (i + mb.x) * 2 + (j + mb.y), (i + mb.x) + (j + mb.y) * 2 );
            vec2 B = vec2(c + b) - sum_e(c + b) * unskew;
            vec2 rv = fbm2(vec3(B, t), ss, as, d2, d3, s );
            vec2 r = B - C - f + rv;
            float R = a * perlinGradient1(B * w, d1, s);
        	float dis = dot( 0.5*(mr+r), normalize(r-mr) );

        bd = min(bd, dis);
        }
    }
    return vec2(id, bd);
}