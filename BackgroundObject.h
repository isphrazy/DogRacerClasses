
#import "cocos2d.h"
#import "CCSprite.h"

@interface BackgroundObject : CCSprite {
    float scrollspd_x;
    float scrollspd_y;
}

@property(readwrite,assign) float scrollspd_x, scrollspd_y;

+(BackgroundObject*) backgroundFromTex:(CCTexture2D *)tex scrollspd_x:(float)spdx scrollspd_y:(float)spdy;
-(void) update_posx:(float)posx posy:(float)posy;

@end
