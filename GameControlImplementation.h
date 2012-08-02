#import <Foundation/Foundation.h>
#import "Player.h"
#import "Island.h"
#import "GameObject.h"
#import "GameControlState.h"
#import "Common.h"
#import "PlayerEffectParams.h"

@interface GameControlImplementation:NSObject

+(void)control_update_player:(Player*)player 
                       state:(GameControlState*)state  
                     islands:(NSMutableArray*)islands 
                     objects:(NSMutableArray*)game_objects;

+(void)touch_begin:(GameControlState*)state at:(CGPoint)pt;
+(void)touch_end:(GameControlState*)state at:(CGPoint)pt;

@end
