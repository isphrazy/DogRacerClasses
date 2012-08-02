#import "CloudGenerator.h"

#define MINSCALE 0.5
#define MAXSCALE 4

#define VARIANCE_Y 120
#define VARIANCE_NEG_Y 30

@implementation CloudGenerator

@synthesize base_hei;
@synthesize cloud_tex;

+(CloudGenerator*)init_from_tex:(CCTexture2D *)tex 
                    scrollspd_x:(float)spdx
                    scrollspd_y:(float)spdy 
                     baseHeight:(float)hei {
    
    CloudGenerator* c = [CloudGenerator node];
    c.cloud_tex = tex;
    c.scrollspd_x = spdx;
    c.scrollspd_y = spdy;
    c.anchorPoint = CGPointZero;
    c.position = CGPointZero;
    
    c.base_hei = hei;
    
    [c init_gen];
    
    return c;
}

-(void)init_gen {
    clouds = [[NSMutableArray alloc] init];
    float scrwid = [[UIScreen mainScreen] bounds].size.height;
    for (int i = 0; i < scrwid; i++) {
        float y = base_hei + arc4random_uniform(VARIANCE_Y) - VARIANCE_NEG_Y;
        float maxh = VARIANCE_Y-VARIANCE_NEG_Y;
        float minscale = 0.3;
        float scale = y >= base_hei ? ABS((1-minscale)*(maxh-(y-base_hei))/maxh+minscale) : 1.0;
        
        i+=120-30*((1-minscale)-scale);
        
        [self gen_cloud_x:i y:y scale:scale];
    }
    next = 85;
}

-(void)gen_cloud_x:(float)x y:(float)y scale:(float)scale {
    CCSprite* c = [CCSprite spriteWithTexture:cloud_tex];
    c.position = ccp(x,y);
    c.anchorPoint = ccp(0,0);
    c.scale = scale;
    [clouds addObject:c];
    [self addChild:c];
}

float ct = 0;
float next;
float prevx = 0;
float prevy = 0;

-(void)update_posx:(float)posx posy:(float)posy {
    float dx = posx - prevx;
    float dy = posy - prevy;
    prevx = posx;
    prevy = posy;
    
    for (CCSprite* c in clouds) {
        c.position = ccp(c.position.x - dx*scrollspd_x*c.scale,c.position.y - dy*scrollspd_y*c.scale);
    }
    ct += dx*scrollspd_x;
    
    
    if (ct > next) {
        float y = base_hei + arc4random_uniform(VARIANCE_Y) - VARIANCE_NEG_Y;
        float maxh = VARIANCE_Y-VARIANCE_NEG_Y;
        float minscale = 0.3;
        float scale = y >= base_hei ? ABS((1-minscale)*(maxh-(y-base_hei))/maxh+minscale) : 1.0;
        [self gen_cloud_x:[[UIScreen mainScreen] bounds].size.height + ct y:y scale:scale];
        
        next+=120-30*((1-minscale)-scale);
    }
}

@end
