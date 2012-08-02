#import "GameObject.h"
#import "cocos2d.h"
#import "Resource.h"

@interface Coin : GameObject {
    BOOL anim_toggle;
}

+(Coin*)init_x:(float)x y:(float)y;

@end
