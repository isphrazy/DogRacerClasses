#import "HitEffect.h"
#import "FlashEffect.h"
#import "GameEngineLayer.h"

@implementation HitEffect

+(HitEffect*)init_from:(PlayerEffectParams*)base time:(int)time {
    HitEffect *e = [[HitEffect alloc] init];
    [PlayerEffectParams copy_params_from:base to:e];
    e.time_left = time;
    return e;
}

-(player_anim_mode)get_anim {
    return player_anim_mode_HIT;
}

-(void)update:(Player*)p g:(GameEngineLayer *)g{
    g.current_mode = GameEngineLayerMode_OBJECTANIM;
    p.vx = 0;
    p.vy = 0;
}

-(void)effect_end:(Player*)p g:(GameEngineLayer*)g {
    [g player_reset];
    [p add_effect:[FlashEffect init_from:[p get_current_params] time:35]];
}

-(NSString*)info {
    return [NSString stringWithFormat:@"HitEffect(minspd:%1.1f,timeleft:%i)",cur_min_speed,time_left];
}



@end
