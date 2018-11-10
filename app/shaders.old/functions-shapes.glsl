struct line2d {
	vec2 base;
	vec2 target;
	vec2 midpoint;
	vec2 vector;
	vec2 ray;
	float length;
	vec2 normal;
};

line2d Line_point_point(vec2 base, vec2 target, vec2 other) {
	vec2 vector = target - base;
	vec2 ray = normalize(vector);
	return line2d(
		base,
		target,
		(base + target) * 0.5,
		vector,
		ray,
		length(vector),
		normalize(other - base - dot(other - base, ray) * ray)
	);
}

vec2 intersect(line2d l1, line2d l2) {
	vec2 d = l2.base - l1.base;
	mat2 A = mat2(l1.ray, -l2.ray);
	mat2 A1 = mat2(d, -l2.ray);
	return determinant(A1) / determinant(A) * l1.ray + l1.base;
}

float drawline(vec2 p, line2d line, float thickness) {
	vec2 vector = p - line.base;
	return pulse(-thickness * 0.5, thickness * 0.5, dot(line.normal, vector));
}

float drawline(vec2 p, vec2 base, vec2 target, vec2 other, float thickness) {
	return drawline(p, Line_point_point(base, target, other), thickness);
}

float drawray(vec2 p, line2d line, float thickness) {
	vec2 vector = p - line.base;
	return pulse(-thickness * 0.5, thickness * 0.5, dot(line.normal, vector)) * step(0.0, dot(vector, line.ray));
}

float drawray(vec2 p, vec2 base, vec2 target, vec2 other, float thickness) {
	return drawray(p, Line_point_point(base, target, other), thickness);
}

float drawlinesegment(vec2 p, line2d line, float thickness) {
	vec2 vector = p - line.base;
	//return smoothpulse(-thickness * 0.5, 0.0, 0.0, thickness * 0.5, dot(line.normal, vector)) * pulse(0.0, line.length, dot(vector, line.ray));
	return pulse(-thickness * 0.5, thickness * 0.5, dot(line.normal, vector)) * pulse(0.0, line.length, dot(vector, line.ray));
}

float drawlinesegment(vec2 p, vec2 base, vec2 target, vec2 other, float thickness) {
	return drawlinesegment(p, Line_point_point(base, target, other), thickness);
}

float drawdashedlinesegment(vec2 p, line2d line, float thickness, float freq) {
	vec2 vector = p - line.base;
	//return smoothpulse(-0.5, 0.0, 0.0, 0.5, dot(line.normal, vector)) * pulse(0.0, line.length, dot(vector, line.ray));// * step(0.0, sin(dot(vector, line.ray)));
	return pulse(-thickness * 0.5, thickness * 0.5, dot(line.normal, vector)) * pulse(0.0, line.length, dot(vector, line.ray)) * step(0.0, sin(dot(vector, freq * line.ray)));
}

float drawdashedlinesegment(vec2 p, vec2 base, vec2 target, vec2 other, float thickness, float freq) {
	return drawdashedlinesegment(p, Line_point_point(base, target, other), thickness, freq);
}

struct circle2d {
	vec2 center;
	float radius;
};

float drawcircle(vec2 p, circle2d circle, float thickness) {
	vec2 vector = p - circle.center;
	return pulse(-thickness * 0.5, thickness * 0.5, length(vector) - circle.radius);
}

struct parallelogram2d {
	vec2 base;
	float majorLength;
	float minorLength;
	float diagonalLength;
	vec2 majorRay;
	vec2 minorRay;
	vec2 diagonalRay;
	vec2 majorVector;
	vec2 minorVector;
	vec2 majorCorner;
	vec2 minorCorner;
	vec2 diagonalCorner;
	vec2 centerPoint;
};

struct parallelogram2dPoint {
	parallelogram2d rect;
	vec2 point;
	vec2 vector;
	vec2 ray;
	vec2 coord;
	float distance;
	float majorDistance;
	float minorDistance;
	float diagonalDistance;
	float radius;
	int inside;
	ivec2 placement;
};

parallelogram2d Rectangle_corner_size(vec2 base, vec2 size) {
	int x = size.y > size.x ? 2 : 1;
	float majorLength = x == 2 ? size.y : size.x;
	float minorLength = x == 1 ? size.y : size.x;
	vec2 majorRay = x == 2 ? j2 : i2;
	vec2 minorRay = x == 1 ? j2 : i2;
	return parallelogram2d(
		base, // base
		majorLength, // majorLength
		minorLength, // minorLength
		length(size), //diagonalLength
		majorRay, // majorRay
		minorRay, // minorRay
		normalize(size), // diagonalRay
		majorRay * majorLength, // majorVector
		minorRay * minorLength, // minorVector
		base + majorLength * majorRay, // majorCorner
		base + minorLength * minorRay, // minorCorner
		base + size, // diagonalCorner
		base + size * 0.5 // centerPoint
	);
}

parallelogram2d Square_corner_size(vec2 base, float size) {
	return parallelogram2d(
		base, // base
		size, // majorLength
		size, // minorLength
		size * sqrt(2.0), //diagonalLength
		i2, // majorRay
		j2, // minorRay
		vec2(size), // diagonalRay
		i2 * size, // majorVector
		j2 * size, // minorVector
		base + size * i2, // majorCorner
		base + size * j2, // minorCorner
		base + size, // diagonalCorner
		base + size * 0.5 // centerPoint
	);
}

parallelogram2d Square_corner_size_angle(vec2 base, float size, float angle) {
	vec2 x = vec2(cos(angle), sin(angle));
	vec2 y = vec2(-sin(angle), cos(angle));
	vec2 xy = x + y;
	return parallelogram2d(
		base, // base
		size, // majorLength
		size, // minorLength
		size * sqrt(2.0), //diagonalLength
		x, // majorRay
		y, // minorRay
		vec2(size), // diagonalRay
		x * size, // majorVector
		y * size, // minorVector
		base + size * x, // majorCorner
		base + size * y, // minorCorner
		base + size * xy, // diagonalCorner
		base + size * xy * 0.5 // centerPoint
	);
}

parallelogram2d Square_center_size_angle(vec2 center, float size, float angle) {
	vec2 x = vec2(cos(angle), sin(angle));
	vec2 y = vec2(-sin(angle), cos(angle));
	return Square_corner_size_angle(center - (x + y) * size * 0.5, size, angle);
}

parallelogram2dPoint Parallelogram2dPoint(vec2 p, parallelogram2d rect) {
	vec2 vector = p - rect.base;
	vec2 ray = p - rect.centerPoint;
	mat2 A = transpose(mat2(rect.majorVector, rect.minorVector));
	mat2 i = inverse(A);
	vec2 coord = i * vector;
	return parallelogram2dPoint (
		rect, // rect
		p, // point
		vector, // vector
		ray, // ray
		coord, // coord
		length(vector), // distance
		length(p - rect.majorCorner), // majorDistance
		length(p - rect.minorCorner), // minorDistance
		length(p - rect.diagonalCorner), // diagonalDistance
		length(ray), // radius
		coord.x >= 0.0 && coord.y >= 0.0 && coord.x <= 1.0 && coord.y <= 1.0 ? 0 : 1, // inside
		ivec2(coord.x < 0.0 ? -1 : (coord.x > 1.0 ? 1 : 0), coord.y < 0.0 ? -1 : (coord.y > 1.0 ? 1 : 0)) // placement
	);
}

struct triangle2d {
	vec2 base;
	line2d leg0;
	line2d leg1;
	line2d leg2;
	line2d median0;
	line2d median1;
	line2d median2;
	line2d pbisector0;
	line2d pbisector1;
	line2d pbisector2;
	line2d altitude0;
	line2d altitude1;
	line2d altitude2;
	line2d abisector0;
	line2d abisector1;
	line2d abisector2;
	vec2 orthocenter;
	vec2 centroid;
	circle2d incircle;
	circle2d circumcircle;
};

struct triangle2dPoint {
	triangle2d tri;
	vec2 point;
	vec2 vector;
	vec2 coord;
	vec3 baryocentric;
	float distance;
	float majorDistance;
	float minorDistance;
	int inside;
	ivec3 placement;
};

triangle2d Triangle_3point(vec2 base, vec2 p1, vec2 p2) {
	vec2 centroid = (base + p1 + p2) / 3.0;
	line2d lined = Line_point_point(p1, p2, base - p2);
	line2d line1 = Line_point_point(base, p1, lined.vector);
	line2d line2 = Line_point_point(base, p2, -lined.vector);
	vec2 b0 = normalize(line1.ray + line2.ray);
	vec2 b1 = normalize(-line1.ray + lined.ray);
	vec2 b2 = normalize(-line2.ray - lined.ray);
	line2d median0 = Line_point_point(lined.midpoint, base, lined.ray);
	line2d median1 = Line_point_point(line1.midpoint, p2, line1.ray);
	line2d median2 = Line_point_point(line2.midpoint, p1, line2.ray);
	line2d pbisector0 = Line_point_point(lined.midpoint, lined.midpoint + lined.normal, lined.ray);
	line2d pbisector1 = Line_point_point(line1.midpoint, line1.midpoint + line1.normal, line1.ray);
	line2d pbisector2 = Line_point_point(line2.midpoint, line2.midpoint + line2.normal, line2.ray);
	vec2 circumcenter = intersect(pbisector1, pbisector2);
	line2d altitude0 = Line_point_point(base, base - dot(-line1.vector, lined.normal) * lined.normal, lined.ray);
	line2d altitude1 = Line_point_point(p1, p1 - dot(line1.vector, line2.normal) * line2.normal, line1.ray);
	line2d altitude2 = Line_point_point(p2, p2 - dot(line2.vector, line1.normal) * line1.normal, line2.ray);
	vec2 orthocenter = intersect(altitude1, altitude2);
	line2d abisector0 = Line_point_point(base, base + b0, lined.ray);
	line2d abisector1 = Line_point_point(p1, p1 + b1, line1.ray);
	line2d abisector2 = Line_point_point(p2, p2 + b2, line2.ray);
	vec2 incenter = intersect(abisector1, abisector2);
	circle2d incircle = circle2d(incenter, dot(incenter - base, line1.normal));
	circle2d circumcircle = circle2d(circumcenter, length(circumcenter - base));
	return triangle2d(
		base, // base
		lined, // leg0
		line1, // leg1
		line2, // leg2
		median0, // median0
		median1, // median1
		median2, // median2
		pbisector0, // pbisector0
		pbisector1, // pbisector1
		pbisector2, // pbisector2
		altitude0, // altitude0
		altitude1, // altitude1
		altitude2, // altitude2
		abisector0, // abisector0
		abisector1, // abisector1
		abisector2, // abisector2
		orthocenter, // orthocenter
		//incenter, // incenter
		//circumcenter, // circumcenter
		centroid, // centroid
		incircle,
		circumcircle
	);
}

triangle2dPoint Triangle2dPoint(vec2 p, triangle2d tri) {
	vec2 vector = p - tri.base;
	mat2 A = transpose(mat2(tri.leg1.vector, tri.leg2.vector));
	mat2 i = inverse(A);
	vec2 coord = i * vector;
	return triangle2dPoint (
		tri, // tri
		p, // point
		vector, // vector
		coord, // coord
		vec3(0.0), // baryocentric
		length(vector), // distance
		length(p - tri.leg1.target), // majorDistance
		length(p - tri.leg2.target), // minorDistance
		0, // inside
		ivec3(0) // placement
	);
}
