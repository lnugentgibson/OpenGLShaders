parallelogram2dPoint squares(vec2 p) {
	vec2 f = floor(p);
	parallelogram2d rect = Square_corner_size(f, 1.0);
	return Parallelogram2dPoint(p, rect);
}

parallelogram2dPoint diamonds(vec2 p, float size) {
	vec2 f = floor(p);
	parallelogram2d rect = Square_center_size_angle(f + 0.5, size, 3.1415926535 * 0.25);
	return Parallelogram2dPoint(p, rect);
}

struct point_snubsquare_2d {
	parallelogram2dPoint square;
	triangle2dPoint triangle;
};

point_snubsquare_2d snubsquare(vec2 p) {
	vec2 f = floor(p);
	ivec2 i = ivec2(f);
	int d = i.x + i.y, q = d - 2 * (d / 2);
	parallelogram2d rect = Square_center_size_angle(f + 0.5, 2.0 / (sqrt(3.0) + 1.0), (q > 0 ? 1.0 : -1.0) * 3.1415926535 / 6.0);
	parallelogram2dPoint rectP = Parallelogram2dPoint(p, rect);
	triangle2d tri;
	triangle2dPoint triP;
	if(rectP.inside > 0) {
		if(rectP.placement.x < 0) {
			if(q < 0)
			tri = Triangle_3point(rect.base, 0.5 * (sqrt(3.0) + 1.0) * (rect.base + rect.minorCorner) - sqrt(3.0) * rect.centerPoint, rect.minorCorner);
			else
			tri = Triangle_3point(0.5 * (sqrt(3.0) + 1.0) * (rect.base + rect.minorCorner) - sqrt(3.0) * rect.centerPoint, rect.minorCorner, rect.base);
		}
		else if(rectP.placement.x > 0)
			tri = Triangle_3point(rect.majorCorner, rect.diagonalCorner, 0.5 * (sqrt(3.0) + 1.0) * (rect.majorCorner + rect.diagonalCorner) - sqrt(3.0) * rect.centerPoint);
		else if(rectP.placement.y < 0)
			tri = Triangle_3point(rect.base, rect.majorCorner, 0.5 * (sqrt(3.0) + 1.0) * (rect.base + rect.majorCorner) - sqrt(3.0) * rect.centerPoint);
		else if(rectP.placement.y > 0)
			tri = Triangle_3point(rect.minorCorner, rect.diagonalCorner, 0.5 * (sqrt(3.0) + 1.0) * (rect.minorCorner + rect.diagonalCorner) - sqrt(3.0) * rect.centerPoint);
		triP = Triangle2dPoint(p, tri);
	}
	point_snubsquare_2d ss = point_snubsquare_2d(rectP, triP);
	return ss;
}
