#import "cocos2d.h"
#import "Resource.h"
#import "BackgroundObject.h"
#import "CloudGenerator.h"
#import "GameEngineLayer.h"
#import "GameMain.h"


@interface BGLayer : CCLayer {
	NSMutableArray *bg_elements;
    GameEngineLayer* game_engine_layer;
}

+(BGLayer*)init_with_gamelayer:(GameEngineLayer*)g;
-(void)set_gameengine:(GameEngineLayer*)ref;

@end
