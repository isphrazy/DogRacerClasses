#import "Vec3D.h"

@implementation Vec3D

@synthesize x,y,z;

static Vec3D* z_vec = NULL;
+(Vec3D*)Z_VEC {
    if (z_vec == NULL) {
        z_vec = [Vec3D init_x:0 y:0 z:1];
    }
    return z_vec;
}

+(Vec3D*) init_x:(float)x y:(float)y z:(float)z {
    Vec3D *v = [Vec3D alloc];
    v.x = x;
    v.y = y;
    v.z = z;
    return v;
}

+(float) rad_angle_between_a:(Vec3D*)a and_b:(Vec3D*)b {
    return acosf( [a dotWith:b] / ([a length]*[b length]) );
}


-(Vec3D*) add:(Vec3D*)v {
    return [Vec3D init_x:(x + v.x) y:(y+v.y) z:(z+v.z)];
}

-(Vec3D*) sub:(Vec3D*)v {
    return [Vec3D init_x:(x - v.x) y:(y-v.y) z:(z-v.z)];
}

-(void) scale:(float)sf {
    x *= sf;
    y *= sf;
    z *= sf;
}

-(BOOL) eq:(Vec3D*)v {
    return v.x == x && v.y == y && v.z == z;
}

-(void) negate {
    x = -x;
    y = -y;
    z = -z;
}

-(double) length {
    return sqrt((x * x) + (y * y) + (z * z));
}

-(void) normalize {
    float len = [self length];
    x /= len;
    y /= len;
    z /= len;
}

-(Vec3D*) crossWith:(Vec3D*)a{
	float x1, y1, z1;
    x1 = (y*a.z) - (a.y*z);
    y1 = -((x*a.z) - (z*a.x));
    z1 = (x*a.y) - (a.x*y);
    
    return [Vec3D init_x:(x1) y:(y1) z:(z1)];
}

-(float) dotWith:(Vec3D*)a {
	return ( x * a.x ) + ( y * a.y ) + ( z * a.z );
}

-(CGPoint) transform_pt:(CGPoint)p {
    return ccp(p.x+x,p.y+y);
}

-(Vec3D*)rotate_vec_by_rad:(float)rad {
    float mag = [self length];
    float ang = atan2f(y, x);
    ang += rad;
    return [Vec3D init_x:mag*cos(ang) y:mag*sin(ang) z:0];
}

-(float)get_angle_in_rad {
    return atan2f(y,x);
}

-(void) print {
    NSLog(@"<%f,%f,%f>",x,y,z);
}

@end
