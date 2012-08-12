//
//  WorldSelectionPage.h
//  GOstrich
//
//  Created by Pingyang He on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdlib.h>

#import "cocos2d.h"
#import "WorldWrapper.h"
#import "BackgroundObject.h"


FOUNDATION_EXPORT NSString *const backgroundsFilesName[];
FOUNDATION_EXPORT NSString *const circlesFilesName[];


typedef enum WorldSelectionMode{
    
    NORMAL, 
    SWITCHING_WORLD_RIGHT, 
    SWITCHING_WORLD_LEFT, 
    SWITCHING_TO_LEVEL_SELECTION, 
    SWITCHING_BACK_FROM_LEVEL_SELECTION,
    LEVEL_SELECTION,
    
}WorldSelectionMode;

@interface WorldSelectionPage : CCLayer{
    
    NSMutableArray *worldWrapperArr;
//    NSMutableArray *backgroundsSpritesArr;
//    NSMutableArray *circlesSpriteArr;
    CCSprite *dots;

    CCMenuItem *currentRotatingCircles;
    CCMenuItem *nextCircle;
    CCMenu *circleMenu;
    CGPoint startPoint;
    CGPoint endPoint;
    CCMenu *dogMenu;
    CCMenuItem *dogButton;
    
    CCSprite *dogRotatingCircle;
    CCSprite *dogRotatingCircleBig;
    
    CCSprite *currentBackground;
    CCSprite *nextBackground;
    CCSprite *stars;
    int worldIndex;
    WorldSelectionMode mode;
    CCSprite *snows;
    
    float screenHeight;
    float screenWidth;
    
    BackgroundObject *currentCloud;  
    
    BOOL snowing;
    BOOL staring;
    
    CCSprite *currentLevelSelection;
    NSMutableArray *levels;
    
    CCMenu *returnMenu;
    CCMenuItem *returnButton;
}

#define MINIMUM_SWIPE_LENGTH 20
#define WORLD_COUNT 4
#define CIRCLE_ROTATION_SPEED 0.3
#define DOG_CIRCLE_ROTATION_SPEED 0.5
#define SWITCH_WORLD_SPEED 18
#define BACKGROUND_OPACITY_SPEED 10
#define BACKGROUND_INITIAL_OPACITY 0
#define DOG_POS_X 50
#define DOG_POS_Y 50
#define DOG_CIRCLE_OFFSET_X 8
#define DOG_CIRCLE_OFFSET_Y 9
#define DOG_CIRCLE_ANCHOR_OFFSET 1
#define DOT_GAP 15	
#define DOT_HEIGHT 60
#define SNOW_WORLD_INDEX 1
#define STARS_WORLD_INDEX 2
#define SNOW_COUNT 40
#define SNOW_FILE @"2winter_snow.png"
#define STARS_FILE @"3autumn_stars.png"
#define SNOW_SPEED 0.5
#define LEVEL_COUNT 12
#define LEVEL_SELECTION_WIDTH 4
#define LEVEL_SELECTION_HEIGHT 3
#define LEVEL_SELECTION_X_GAP 80
#define LEVEL_SELECTION_Y_GAP 70
#define LEVEL_SCORE_DOT_X_GAP 15
#define LEVEL_SCORE_COUNT 3

//= {@"1green_background.png", @"2winter_background.png"};
+(CCScene *) scene;
@end
