#import "cocos2d.h"

@interface Resource : NSObject

+(void)init_bg1_textures;
+(CCTexture2D*)get_tex:(NSString*)key;
+(CCTexture2D*)get_aa_tex:(NSString*)key;
+(void)dealloc_textures;
+(void)init_menu_textures:(NSArray *)pic_names;
+(void)load_tex_from_array:(NSArray*)temp;

#define TEX_GROUND_TEX_1 @"GroundTexture1"
#define TEX_GROUND_TOP_1 @"GroundTop1"
#define TEX_TOP_EDGE @"GroundTopEdge"

#define TEX_ISLAND_BORDER @"IslandBorder"
#define TEX_CLOUD @"CloudTex"
#define TEX_DOG_RUN_1 @"Dog1RunSSheet"
#define TEX_BG_SKY @"BgSky"
#define TEX_BG_LAYER_1 @"BgLayer1"
#define TEX_BG_LAYER_2 @"BgLayer2"
#define TEX_BG_LAYER_3 @"BgLayer3"
#define TEX_GOLDEN_BONE @"GoldenBone"
#define TEX_DOG_CAPE @"DogCape"
#define TEX_DOG_ROCKET @"DogRocket"
#define TEX_SPIKE @"Spike"
#define TEX_WATER @"Water"
#define TEX_JUMPPAD @"JumpPad"

#define TEX_CHECKPOINT_1 @"CheckPointPre"
#define TEX_CHECKPOINT_2 @"CheckPointPost"
#define TEX_CHECKERFLOOR @"CheckerFloor"

#define TEX_GROUND_DETAIL_1 @"GroundDetail1"
#define TEX_GROUND_DETAIL_2 @"GroundDetail2"
#define TEX_GROUND_DETAIL_3 @"GroundDetail3"

#define TEX_UI_COINCOUNT @"UICoinCount"
#define TEX_UI_PAUSEICON @"UIPauseIcon"

#define TEX_UI_PAUSEMENU_RETURN @"PauseMenuReturn"
#define TEX_UI_PAUSEMENU_PLAY @"PauseMenuPlay"
#define TEX_UI_PAUSEMENU_BACK @"PauseMenuBack"

#define TEX_UI_STARTGAME_GO @"UIStartGameGo"
#define TEX_UI_STARTGAME_READY @"UIStartGameReady"



@end
