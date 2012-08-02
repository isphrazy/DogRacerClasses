#import "PlayerEffectParams.h"
@class FlashEffect;

@interface HitEffect : PlayerEffectParams

+(HitEffect*)init_from:(PlayerEffectParams*)base time:(int)time;

@end
