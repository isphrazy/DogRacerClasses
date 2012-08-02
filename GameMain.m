#import "GameMain.h"

@implementation GameMain

#define USE_BG NO

+(void)main {
    [[CCDirector sharedDirector] setDisplayFPS:NO];
    [[CCDirector sharedDirector] runWithScene:[CoverPage scene]];
}

+(BOOL)GET_USE_BG {
    return USE_BG;
}

@end
