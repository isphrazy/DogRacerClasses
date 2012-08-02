
#import "Common.h"
#import "Island.h"


@implementation Common

+(void)run_callback:(callback)c {
    if (c.target != NULL) {
        [c.target performSelector:c.selector];
    } else {
        NSLog(@"callback target is null");
    }
}

+(HitRect)hitrect_cons_x1:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2 {
    struct HitRect n;
    n.x1 = x1;
    n.y1 = y1;
    n.x2 = x2;
    n.y2 = y2;
    return n;
}

+(HitRect)hitrect_cons_x1:(float)x1 y1:(float)y1 wid:(float)wid hei:(float)hei {
    return [Common hitrect_cons_x1:x1 y1:y1 x2:x1+wid y2:y1+hei];
}

+(CGRect)hitrect_to_cgrect:(HitRect)rect {
    return CGRectMake(rect.x1, rect.y1, rect.x2-rect.x1, rect.y2-rect.y1);
}

+(CGPoint*)hitrect_get_pts:(HitRect)rect {
    CGPoint *pts = (CGPoint*) malloc(sizeof(CGPoint)*4);
    pts[0] = ccp(rect.x1,rect.y1);
    pts[1] = ccp(rect.x1+(rect.x2-rect.x1),rect.y1);
    pts[2] = ccp(rect.x2,rect.y2);
    pts[3] = ccp(rect.x1,rect.y1+(rect.y2-rect.y1));
    return pts;
    
}

+(BOOL)hitrect_touch:(HitRect)r1 b:(HitRect)r2 {
    return !(r1.x1 > r2.x2 ||
             r2.x1 > r1.x2 ||
             r1.y1 > r2.y2 ||
             r2.y1 > r1.y2);
}

+(CGPoint)line_seg_intersection_a1:(CGPoint)a1 a2:(CGPoint)a2 b1:(CGPoint)b1 b2:(CGPoint)b2 {//2 line segment intersection (seg a1,a2) (seg b1,b2)
    CGPoint null_point = CGPointMake([Island NO_VALUE], [Island NO_VALUE]);
    double Ax = a1.x; double Ay = a1.y;
	double Bx = a2.x; double By = a2.y;
	double Cx = b1.x; double Cy = b1.y;
	double Dx = b2.x; double Dy = b2.y;
	double X; double Y;
	double  distAB, theCos, theSin, newX, ABpos ;
	
	if ((Ax==Bx && Ay==By) || (Cx==Dx && Cy==Dy)) return null_point; //  Fail if either line segment is zero-length.
	if ((Ax==Cx && Ay==Cy) || (Bx==Cx && By==Cy) ||  (Ax==Dx && Ay==Dy) || (Bx==Dx && By==Dy)) return null_point; //  Fail if the segments share an end-point.
	
	Bx-=Ax; By-=Ay;//Translate the system so that point A is on the origin.
	Cx-=Ax; Cy-=Ay;
	Dx-=Ax; Dy-=Ay;
	
	distAB=sqrt(Bx*Bx+By*By);//Discover the length of segment A-B.
	
	theCos=Bx/distAB;//Rotate the system so that point B is on the positive X axis.
	theSin=By/distAB;
	newX=Cx*theCos+Cy*theSin;
	Cy  =Cy*theCos-Cx*theSin; Cx=newX;
	newX=Dx*theCos+Dy*theSin;
	Dy  =Dy*theCos-Dx*theSin; Dx=newX;
	
	if ((Cy<0. && Dy<0.) || (Cy>=0. && Dy>=0.)) return null_point;//  Fail if segment C-D doesn't cross line A-B.
	
	ABpos=Dx+(Cx-Dx)*Dy/(Dy-Cy);//Discover the position of the intersection point along line A-B.
	
	if (ABpos<0. || ABpos>distAB) return null_point;//  Fail if segment C-D crosses line A-B outside of segment A-B.
	
	X=Ax+ABpos*theCos;//Apply the discovered position to line A-B in the original coordinate system.
	Y=Ay+ABpos*theSin;
	
	return ccp(X,Y);//  Success.
}

+(CGPoint)line_seg_intersection_a:(line_seg)a b:(line_seg)b {
    return [Common line_seg_intersection_a1:a.a a2:a.b b1:b.a b2:b.b];
}

+(line_seg)cons_line_seg_a:(CGPoint)a b:(CGPoint)b {
    struct line_seg new;
    new.a = a;
    new.b = b;
    return new;
}

+(BOOL)point_fuzzy_on_line_seg:(line_seg)seg pt:(CGPoint)pt {
    Vec3D *b_m_a = [Vec3D init_x:seg.b.x-seg.a.x y:seg.b.y-seg.a.y z:0];
    Vec3D *c_m_a = [Vec3D init_x:pt.x-seg.a.x y:pt.y-seg.a.y z:0];
    Vec3D *ab_c_ac = [b_m_a crossWith:c_m_a];
    
    float val = [ab_c_ac length] / [b_m_a length];
    if (val <= 0.1) {
        return YES;
    } else {
        return NO;
    }
}

+(void)print_line_seg:(line_seg)l msg:(NSString*)msg {
    NSLog(@"%@ line segment (%f,%f) to (%f,%f)",msg,l.a.x,l.a.y,l.b.x,l.b.y);
}

+(BOOL)pt_fuzzy_eq:(CGPoint)a b:(CGPoint)b {
    return ABS(a.x-b.x) <= 0.1 && ABS(a.y-b.y) <= 0.1;
}

+(float)deg_to_rad:(float)degrees {
    return degrees * M_PI / 180.0;
}

+(float)rad_to_deg:(float)rad {
    return rad * 180.0 / M_PI;
}

+(float)shortest_dist_from_cur:(float)a1 to:(float)a2 {
    a1 = [Common deg_to_rad:a1];
    a2 = [Common deg_to_rad:a2];
    float res = atan2f(cosf(a1)*sinf(a2)-sinf(a1)*cosf(a2),
                       sinf(a1)*sinf(a2)+cosf(a1)*cosf(a2));
    
    res = [Common rad_to_deg:res];
    return res;
}

+(float)sig:(float)n {
    if (n > 0) {
        return 1;
    } else if (n < 0) {
        return -1;
    } else {
        return 0;
    }
}

+(void)draw_renderobj:(gl_render_obj)obj n_vtx:(int)n_vtx {
    glBindTexture(GL_TEXTURE_2D, obj.texture.name);
	glVertexPointer(2, GL_FLOAT, 0, obj.tri_pts); 
	glTexCoordPointer(2, GL_FLOAT, 0, obj.tex_pts);
    
	glDrawArrays(GL_TRIANGLES, 0, 3);
    if (n_vtx == 4)glDrawArrays(GL_TRIANGLES, 1, 3);
}

+(void)tex_map_to_tri_loc:(gl_render_obj)o len:(int)len {
    for (int i = 0; i < len; i++) {
        o.tex_pts[i] = ccp(o.tri_pts[i].x/o.texture.pixelsWide, o.tri_pts[i].y/o.texture.pixelsHigh);
    }
}

+(gl_render_obj)init_render_obj:(CCTexture2D*)tex npts:(int)npts {
    struct gl_render_obj n;
    n.texture = tex;
    n.tri_pts = calloc(npts, sizeof(CGPoint));
    n.tex_pts = calloc(npts, sizeof(CGPoint));
    n.isalloc = 1;
    return n;
}






@end
