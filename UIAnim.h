#import "CCSprite.h"
#import "Common.h"

@interface UIAnim : CCSprite {
    callback anim_complete;
}

@property(readwrite,assign) callback anim_complete;

@end
