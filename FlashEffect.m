#import "FlashEffect.h"

@implementation FlashEffect

+(FlashEffect*)init_from:(PlayerEffectParams*)base time:(int)time {
    FlashEffect *e = [[FlashEffect alloc] init];
    [PlayerEffectParams copy_params_from:base to:e];
    e.time_left = time;
    return e;
}

-(void)update:(Player*)p g:(GameEngineLayer *)g {
    ct++;
    if (ct%3==0) {
        toggle = !toggle;
        if(toggle) {
            [p setOpacity:140];
        } else {
            [p setOpacity:255];
        }
    }
}

-(void)effect_end:(Player *)p g:(GameEngineLayer *)g {
    [p setOpacity:255];
}

-(NSString*)info {
    return [NSString stringWithFormat:@"FlashEffect(minspd:%1.1f,timeleft:%i)",cur_min_speed,time_left];
}

@end
