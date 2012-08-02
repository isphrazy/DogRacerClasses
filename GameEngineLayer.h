#import "cocos2d.h"
#import "Island.h"
#import "Player.h"
#import "Common.h"
#import "GameObject.h"
@class BGLayer;
@class UILayer;
#import "Resource.h"
#import "MapLoader.h"
#import "GamePhysicsImplementation.h"
#import "GameRenderImplementation.h"
#import "GameControlImplementation.h"
#import "GameControlState.h"
#import "GameRenderState.h"

typedef enum {
    GameEngineLayerMode_UIANIM,
    GameEngineLayerMode_GAMEPLAY,
    GameEngineLayerMode_PAUSED,
    GameEngineLayerMode_ENDOUT,
    GameEngineLayerMode_ENDED,
    GameEngineLayerMode_OBJECTANIM
} GameEngineLayerMode;

@interface GameEngineLayer : CCLayer {
	NSMutableArray *islands;
    NSMutableArray *game_objects;

	Player *player;
    GameControlState *game_control_state;
    GameRenderState *game_render_state;
    
    CGPoint map_start_pt;
    CCFollow *follow_action;
    
    GameEngineLayerMode current_mode;
    
    callback bg_update;
    callback load_game_end_menu;
}


@property(readwrite,assign) GameEngineLayerMode current_mode;
@property(readwrite,assign) NSMutableArray *islands, *game_objects;
@property(readwrite,assign) Player* player;
@property(readwrite,assign) callback load_game_end_menu;

+(CCScene *) scene_with:(NSString *)map_file_name;
-(void)player_reset;
-(CGPoint)get_pos;

@end
