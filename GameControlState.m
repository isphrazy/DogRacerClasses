#import "GameControlState.h"

@implementation GameControlState

@synthesize is_touch_down;

@synthesize queue_jump;
@synthesize jump_hold_counter;


- (id)init {
    self = [super init];
    if (self) {
        is_touch_down = NO;
    }
    return self;
}

-(void)start_touch:(CGPoint)pt {
    is_touch_down = YES;
}

-(void)end_touch {
    is_touch_down = NO;
}

@end
