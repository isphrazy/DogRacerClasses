//
//  WorldSelectionPage.h
//  GOstrich
//
//  Created by Pingyang He on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"


FOUNDATION_EXPORT NSString *const backgroundsFilesName[];
FOUNDATION_EXPORT NSString *const circlesFilesName[];

typedef enum WorldSelectionMode{
    
    NORMAL, SWITCHING_WORLD_RIGHT, SWITCHING_WORLD_LEFT
    
}WorldSelectionMode;

@interface WorldSelectionPage : CCLayer{
    
    NSMutableArray *backgroundsSpritesArr;
    NSMutableArray *circlesSpriteArr;

    CCSprite *currentRotatingCircles;
    CCSprite *nextCircle;
    CGPoint startPoint;
    CGPoint endPoint;
    CCSprite *dogButton;
    
    CCSprite *dogRotatingCircle;
    
    CCSprite *currentBackground;
    CCSprite *nextBackground;
    
    int worldIndex;
    WorldSelectionMode mode;
    
    float screenHeight;
    float screenWidth;
//    NSString *backgroundsFilesName[2];
    
    
    
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
//= {@"1green_background.png", @"2winter_background.png"};
+(CCScene *) scene;
@end
