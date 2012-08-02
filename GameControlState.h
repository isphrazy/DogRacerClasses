#import <Foundation/Foundation.h>
#import "Vec3D.h"

@class GameControlState;
@interface GameControlState : NSObject {
    BOOL is_touch_down;
    BOOL queue_jump;
    int jump_hold_counter;

}

@property(readwrite,assign) BOOL is_touch_down;

@property(readwrite,assign) BOOL queue_jump;
@property(readwrite,assign) int jump_hold_counter;


-(void)start_touch:(CGPoint)pt;
-(void)end_touch;

@end
