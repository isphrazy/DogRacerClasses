#import "PlayerEffectParams.h"
#import "GameEngineLayer.h"

@implementation PlayerEffectParams

@synthesize cur_min_speed,cur_gravity,cur_limit_speed,cur_accel_to_min,cur_airjump_count,time_left;


+(PlayerEffectParams*)init_copy:(PlayerEffectParams*)p {
    PlayerEffectParams *n = [[PlayerEffectParams alloc] init];
    [PlayerEffectParams copy_params_from:p to:n];
    return n;
}

+(void)copy_params_from:(PlayerEffectParams *)a to:(PlayerEffectParams *)b {
    b.cur_accel_to_min = a.cur_accel_to_min;
    b.cur_gravity = a.cur_gravity;
    b.cur_limit_speed = a.cur_limit_speed;
    b.cur_min_speed = a.cur_min_speed;
    b.cur_airjump_count = a.cur_airjump_count;
}


-(BOOL)decrement_timer {
    if (time_left > 0) {
        time_left--;
        return YES;
    }
    return NO;
}

-(void)add_airjump_count {
    cur_airjump_count = 1;
}

-(void)decr_airjump_count {
    if (cur_airjump_count > 0) {
        cur_airjump_count--;
    }
}

-(player_anim_mode)get_anim {
    return player_anim_mode_RUN;
}

-(void)update:(Player*)p g:(GameEngineLayer *)g{
}

-(NSString*)info {
    return [NSString stringWithFormat:@"DefaultEffect(minspd:%1.1f,timeleft:%i)",cur_min_speed,time_left];
}

-(void)effect_end:(Player*)p g:(GameEngineLayer*)g{
}

@end
