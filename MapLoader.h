#import <Foundation/Foundation.h>
#import "CJSONDeserializer.h"
#import "LineIsland.h"
#import "Island.h"

#import "Coin.h"
#import "GroundDetail.h"
#import "DogCape.h"
#import "DogRocket.h"
#import "CheckPoint.h"
#import "GameEndArea.h"
#import "Spike.h"
#import "Water.h"
#import "JumpPad.h"

@interface MapLoader : NSObject

typedef struct GameMap {
    NSMutableArray *n_islands, *game_objects;
    CGPoint player_start_pt;
    int assert_links;
} GameMap;

+(GameMap) load_map: (NSString *)map_file_name oftype:(NSString *) map_file_type;
+(NSArray*) load_themes_info;

@end
