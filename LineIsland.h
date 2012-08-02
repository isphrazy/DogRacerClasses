#import "Island.h"
#import "Common.h"
#import "Vec3D.h"
#import "Resource.h"



@interface LineIsland : Island {
    
	gl_render_obj main_fill,top_fill,corner_fill,corner_top_fill;
    gl_render_obj tl_top_corner,tr_top_corner;
    gl_render_obj bottom_line_fill,corner_line_fill,left_line_fill,right_line_fill;
    CGPoint toppts[3];
    
    CGPoint tl,bl,tr,br;
    CGPoint bl1,bl2,br1,br2;
}

@property(readwrite,assign) CGPoint tl,bl,tr,br,bl1,bl2,br1,br2;

+(LineIsland*)init_pt1:(CGPoint)start pt2:(CGPoint)end height:(float)height ndir:(float)ndir can_land:(BOOL)can_land;



@end
