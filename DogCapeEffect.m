#import "DogCapeEffect.h"

@implementation DogCapeEffect

+(DogCapeEffect*)init_from:(PlayerEffectParams*)base {
    DogCapeEffect *n = [[DogCapeEffect alloc] init];
    [PlayerEffectParams copy_params_from:base to:n];
    n.time_left = 300;
    n.cur_airjump_count = 1;
    n.cur_min_speed = 14;
    n.cur_limit_speed = n.cur_min_speed + 2;
    return n;
}

-(void)update:(Player*)p g:(GameEngineLayer *)g{
    if(p.vx < 10) {
        p.vx = 10;
    }
}

-(player_anim_mode)get_anim {
    return player_anim_mode_CAPE;
}

-(void)decr_airjump_count {
}

-(NSString*)info {
    return [NSString stringWithFormat:@"DogCapeEffect(timeleft:%i)",time_left];
}


@end
