#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "Island.h"
#import "GameObject.h"
#import "GameRenderState.h"
#import "PlayerEffectParams.h"


@interface GameRenderImplementation:NSObject

+(void)update_render_on:(CCLayer*)layer 
                 player:(Player*)player 
                islands:(NSMutableArray*)islands 
                objects:(NSMutableArray*)objects
                state:(GameRenderState*)state;

+(void)update_camera_on:(CCLayer*)layer state:(GameRenderState*)state;

+(int)GET_RENDER_FG_ISLAND_ORD;
+(int)GET_RENDER_PLAYER_ORD;
+(int)GET_RENDER_ISLAND_ORD;
+(int)GET_RENDER_GAMEOBJ_ORD;

@end
