#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Vec3D : NSObject {
    float x,y,z;
}

@property(readwrite, assign) float x,y,z;

+(Vec3D*) init_x:(float)x y:(float)y z:(float)z;
+(float) rad_angle_between_a:(Vec3D*)a and_b:(Vec3D*)b;
-(Vec3D*) add:(Vec3D*)v;
-(Vec3D*) sub:(Vec3D*)v;
-(void) scale:(float)sf;
-(BOOL) eq:(Vec3D*)v;
-(void) negate;
-(double) length;
-(void) normalize;
-(Vec3D*) crossWith:(Vec3D*)a;
-(float) dotWith:(Vec3D*)a;
-(CGPoint) transform_pt:(CGPoint)p;
-(Vec3D*)rotate_vec_by_rad:(float)rad;
-(float)get_angle_in_rad;
-(void) print;
+(Vec3D*)Z_VEC;

@end
