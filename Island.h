#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Common.h"

@interface Island : CCSprite {
	float startX, startY, endX, endY, ndir;
    float t_min,t_max;
    
    BOOL can_land,has_prev;
    Island* next;
    
    float fill_hei;
    Vec3D* normal_vec;
}


@property(readwrite,assign) float startX, startY, endX, endY, fill_hei, ndir, t_min, t_max;
@property(readwrite,assign) Island* next;
@property(readwrite,assign) BOOL can_land,has_prev;

+(float) NO_VALUE;
+(int)link_islands:(NSMutableArray*)islands;

-(void)link_finish;
-(Vec3D*)get_normal_vec;
-(line_seg)get_line_seg;
-(float)get_t_given_position:(CGPoint)position;
-(CGPoint)get_position_given_t:(float)t;
-(Vec3D*)get_tangent_vec;

-(void)cleanup_anims;





@end
