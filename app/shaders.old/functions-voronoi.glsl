struct voro2 {
	float dis;
	float blend;
	float edge;
	vec2 gen;
	vec3 color;
};
voro2 voronoi( in vec2 x, mat2 dm, vec2 dv, vec2 delta, vec4 s ) {
    ivec2 p = ivec2(floor( x ));
    vec2 f = fract( x );

    float res = 1.0e20;
    float res2 = 1.0e20;
    float eres = 0.0;
    ivec2 center;
    vec2 ray;
    const int range = 2;
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        //ivec2 b = ivec2( i, j );
        //ivec2 c = b + p;
        ivec2 c = ivec2( i, j ) + p;
        vec2 v = rand2( vec2(c), dm, dv, delta, s );
        vec2 r = vec2(c) + v;
        vec2 d = r - x;
        float dis = length( d );

		if(dis < res) {
			center = c;
			ray = r;
		}
		res2 = min(max(res, dis), res2);
        res = min(res, dis);
        eres += exp( -FALLOUT*dis );
    }
    float edge = 1.0e20;
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        //ivec2 b = ivec2( i, j );
        //ivec2 c = b + center;
        ivec2 c = ivec2( i, j ) + center;
        vec2 v = rand2( vec2(c), dm, dv, delta, s );
        vec2 r = vec2(c) + v;
        float dis = abs(dot(0.5 * (r + ray) - x, normalize(r - ray) ));

        edge = min(edge, dis);
    }
    vec3 c = rand3(vec2(center), dm, dv, delta, s);
    c /= max_e(c);
    return voro2(
    	res,
		1.0 +(1.0/FALLOUT)*log( res ),
		edge,
		ray,
		c
	);
}
voro2 voronoi( in vec2 x, sampler2D n1, vec2 r1, float scale, float amp ) {
    ivec2 p = ivec2(floor( x ));
    vec2 f = fract( x );

    float res = 1.0e20;
    float res2 = 1.0e20;
    float eres = 0.0;
    ivec2 center;
    vec2 ray;
    const int range = 2;
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        //ivec2 b = ivec2( i, j );
        //ivec2 c = b + p;
        ivec2 c = ivec2( i, j ) + p;
        vec2 v = (texture2D(n1, scale * vec2(c) / r1).rg - 0.5) * amp;
        vec2 r = vec2(c) + v;
        vec2 d = r - x;
        float dis = length( d );

		if(dis < res) {
			center = c;
			ray = r;
		}
		res2 = min(max(res, dis), res2);
        res = min(res, dis);
        eres += exp( -FALLOUT*dis );
    }
    float edge = 1.0e20;
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        //ivec2 b = ivec2( i, j );
        //ivec2 c = b + center;
        ivec2 c = ivec2( i, j ) + center;
        vec2 v = texture2D(n1, scale * vec2(c) / r1).rg * amp;
        vec2 r = vec2(c) + v;
        float dis = abs(dot(0.5 * (r + ray) - x, normalize(r - ray) ));

        edge = min(edge, dis);
    }
    vec3 c = vec3(0.0);
    return voro2(
    	res,
		1.0 +(1.0/FALLOUT)*log( res ),
		edge,
		ray,
		c
	);
}
struct voro3 {
	float dis;
	float blend;
	float edge;
	vec3 gen;
	vec3 color;
};
voro3 voronoi( in vec3 x, mat3 dm, vec3 dv, vec3 delta, vec4 s ) {
    ivec3 p = ivec3(floor( x ));
    vec3 f = fract( x );

    float res = 1.0e20;
    float res2 = 1.0e20;
    float eres = 0.0;
    ivec3 center;
    vec3 ray;
    const int range = 2;
    for( int k=-range; k<=range; k++ )
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        //ivec3 b = ivec2( i, j, k );
        //ivec3 c = b + p;
        ivec3 c = ivec3( i, j, k ) + p;
        vec3 v = rand3( vec3(c), dm, dv, delta, s );
        vec3 r = vec3(c) + v;
        vec3 d = r - x;
        float dis = length( d );

		if(dis < res) {
			center = c;
			ray = r;
		}
		res2 = min(max(res, dis), res2);
        res = min(res, dis);
        eres += exp( -FALLOUT*dis );
    }
    float edge = 1.0e20;
    for( int k=-range; k<=range; k++ )
    for( int j=-range; j<=range; j++ )
    for( int i=-range; i<=range; i++ )
    {
        //ivec3 b = ivec2( i, j, k );
        //ivec3 c = b + center;
        ivec3 c = ivec3( i, j, k ) + center;
        vec3 v = rand3( vec3(c), dm, dv, delta, s );
        vec3 r = vec3(c) + v;
        float dis = abs(dot(0.5 * (r + ray) - x, normalize(r - ray) ));

        edge = min(edge, dis);
    }
    vec3 c = rand3(vec3(center), dm, dv, delta, s);
    c /= max_e(c);
    return voro3(
    	res,
		1.0 +(1.0/FALLOUT)*log( res ),
		edge,
		ray,
		c
	);
}
struct voro4 {
	float dis;
	float blend;
	float edge;
	vec4 gen;
	vec3 color;
};
voro4 voronoi( in vec4 x, mat4 dm, vec4 dv, vec4 delta, vec4 s ) {
	return voro4(0.0, 0.0, 0.0, vec4(0.0), vec3(0.0));
}
/*
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
*/
