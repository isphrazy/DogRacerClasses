

#import "BackgroundObject.h"

@implementation BackgroundObject
@synthesize scrollspd_x, scrollspd_y;

+(BackgroundObject*) backgroundFromTex:(CCTexture2D *)tex scrollspd_x:(float)spdx scrollspd_y:(float)spdy {
    BackgroundObject *bg = [BackgroundObject spriteWithTexture:tex];
    bg.scrollspd_x = spdx;
    bg.scrollspd_y = spdy;
    bg.anchorPoint = CGPointZero;
    bg.position = CGPointZero;
    ccTexParams par = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
    [bg.texture setTexParameters:&par];
    return bg;
}

-(void)update_posx:(float)posx posy:(float)posy {
    CGSize textureSize = [self textureRect].size;
    [self setTextureRect:CGRectMake(posx*scrollspd_x, 0, [[UIScreen mainScreen] bounds].size.width*2 , textureSize.height)];
    self.position = ccp(0,MIN(0,-posy*scrollspd_y));
}

@end
