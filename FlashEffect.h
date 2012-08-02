#import "PlayerEffectParams.h"

@interface FlashEffect : PlayerEffectParams {
    BOOL toggle;
    int ct;
}

+(FlashEffect*)init_from:(PlayerEffectParams*)base time:(int)time;

@end
