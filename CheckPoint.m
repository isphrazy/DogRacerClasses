#import "CheckPoint.h"

@implementation CheckPoint

+(CheckPoint*)init_x:(float)x y:(float)y {
    CheckPoint *p = [CheckPoint node];
    p.position = ccp(x,y);

    [p init_img];
    
    p.active = YES;
    
    return p;
}

float texwid,texhei;

+(CCSprite*)makeimg:(CCTexture2D*)tex {
    CCSprite *i = [CCSprite spriteWithTexture:tex];
    i.position = ccp(0,[i boundingBoxInPixels].size.height / 2.0);
    return i;
}

-(CGPoint)get_center {
    HitRect r = [self get_hit_rect];
    return ccp((r.x2-r.x1)/2+r.x1,(r.y2-r.y1)/2+r.y1);
}

-(void)init_img {
    CCTexture2D *tex1 = [Resource get_tex:TEX_CHECKPOINT_1];
    CCTexture2D *tex2 = [Resource get_tex:TEX_CHECKPOINT_2];
    inactive_img = [CheckPoint makeimg:tex1];
    active_img = [CheckPoint makeimg:tex2];
    [self addChild:inactive_img];
    [self addChild:active_img];
    inactive_img.visible = YES;
    active_img.visible = NO;
    
    texwid = [tex1 contentSizeInPixels].width;
    texhei = [tex1 contentSizeInPixels].height;
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:position_.x-texwid/2 y1:position_.y wid:texwid hei:texhei];
}

-(GameObjectReturnCode)update:(Player*)player g:(GameEngineLayer *)g{
    if (self.active && [Common hitrect_touch:[self get_hit_rect] b:[player get_hit_rect]]) {
        self.active = NO;
        inactive_img.visible = NO;
        active_img.visible = YES;
        
        player.start_pt = [self get_center];
    }
    
    return GameObjectReturnCode_NONE;
}


@end
