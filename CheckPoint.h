#import "GameObject.h"

@interface CheckPoint : GameObject {
    CCSprite *inactive_img,*active_img;
}

+(CheckPoint*)init_x:(float)x y:(float)y;
-(void)init_img;

@end
