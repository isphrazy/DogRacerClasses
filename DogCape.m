#import "DogCape.h"

@implementation DogCape


+(DogCape*)init_x:(float)x y:(float)y {
    DogCape *new_cape = [DogCape node];
    new_cape.active = YES;
    new_cape.position = ccp(x,y);
    
    CCTexture2D *texture = [Resource get_tex:TEX_DOG_CAPE];
    new_cape.img = [CCSprite spriteWithTexture:texture];
    [new_cape addChild:new_cape.img];
    
    return new_cape;
}

-(GameObjectReturnCode)update:(Player*)player g:(GameEngineLayer *)g {
    if (!active) {
        return GameObjectReturnCode_NONE;
    }
    
    float rot = [self rotation];
    if (anim_toggle) {
        rot+=0.5;
        if (rot > 10) {
            anim_toggle = !anim_toggle;
        }
    } else {
        rot-=0.5;
        if (rot < -10) {
            anim_toggle = !anim_toggle;
        }
    }
    [self setRotation:rot];
    
    
    if ([Common hitrect_touch:[self get_hit_rect] b:[player get_hit_rect]]) {
        PlayerEffectParams *e = [DogCapeEffect init_from:[player get_default_params]];
        [player add_effect:e];
        [self set_active:NO];
    }
    
    return GameObjectReturnCode_NONE;
}


-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:[self position].x-10 y1:[self position].y-10 wid:20 hei:20];
}

-(void)set_active:(BOOL)t_active {
    if (t_active) {
        visible_ = YES;
    } else {
        visible_ = NO;
    }
    active = t_active;
}

@end
