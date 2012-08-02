#import "GameStartAnim.h"

#define ANIM_LENGTH 75.0

@implementation GameStartAnim

+(GameStartAnim*)init_endcallback:(SEL)sel on_target:(NSObject*)target {
    GameStartAnim *n = [GameStartAnim node];
    
    struct callback nca;
    nca.selector = sel;
    nca.target = target;
    n.anim_complete = nca;
    
    [n initanim];
    
    n.position = ccp([[UIScreen mainScreen] bounds].size.height/2, [[UIScreen mainScreen] bounds].size.width/2);
    
    return n;
}

-(void)initanim {
    readyimg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_STARTGAME_READY]];
    goimg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_STARTGAME_GO]];
    
    [self addChild:readyimg];
    [self addChild:goimg];
    
    [readyimg setOpacity:0];
    [goimg setOpacity:0];
    
    ct = ANIM_LENGTH;
    [self schedule:@selector(update)];
}

-(void)update {
    
    ct--;
    if (ct <= 0) {
        [self anim_finished];
        return;
    }
    
    if (ct > ANIM_LENGTH/2) {
        float o = ct-ANIM_LENGTH/2;
        o = (o/(ANIM_LENGTH/2))*200+55;
        
        [goimg setOpacity:0];
        [readyimg setOpacity:(int)o];
    } else {
        float o = ct;
        o = (o/(ANIM_LENGTH/2))*200+55;
        
        [readyimg setOpacity:0];
        [goimg setOpacity:(int)o];
    }
    
}

-(void)anim_finished {
    [self unschedule:@selector(update)];
    [self removeAllChildrenWithCleanup:YES];
    [Common run_callback:anim_complete];
}

@end
