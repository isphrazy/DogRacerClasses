//
//  WorldSelectionPage.m
//  GOstrich
//
//  Created by Pingyang He on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorldSelectionPage.h"

@implementation WorldSelectionPage

static WorldSelectionPage *worldSelectionPage;

NSString *const backgroundsFilesName[] = {@"1green_background.png", @"2winter_background.png", @"3autumn_background.png", @"4summer_background.png"};

NSString *const circlesFilesName[] = {@"1green_world.png", @"2winter_world.png", @"3autumn_world.png", @"4summer_world.png"};

-(id)init{
    self = [super init];
    if (self) {
        mode = NORMAL;
        [self schedule:@selector(update)];
        worldIndex = 0;
        screenHeight = [UIScreen mainScreen].bounds.size.width;
        screenWidth = [UIScreen mainScreen].bounds.size.height;
    }
    return self;
}

//update loop
-(void) update{
    currentRotatingCircles.rotation += CIRCLE_ROTATION_SPEED;
    dogRotatingCircle.rotation -= DOG_CIRCLE_ROTATION_SPEED;
    if(mode == SWITCHING_WORLD_RIGHT){
        if(nextCircle.position.x <= screenWidth / 2 + SWITCH_WORLD_SPEED){
            nextCircle.position = ccp(screenWidth / 2, screenHeight / 2);
//            currentBackground.opacity = 0;
            nextBackground.opacity = 255;
            mode = NORMAL;
            [worldSelectionPage removeChild:currentRotatingCircles cleanup:NO];
            currentRotatingCircles = nextCircle;
            
            [worldSelectionPage removeChild:currentBackground cleanup:NO];
            
            currentBackground = nextBackground;
        }else{
            currentBackground.opacity -= BACKGROUND_OPACITY_SPEED;
            nextBackground.opacity += BACKGROUND_OPACITY_SPEED;
            CGPoint currentCirclePos = currentRotatingCircles.position;
            currentRotatingCircles.position = ccp(currentCirclePos.x - SWITCH_WORLD_SPEED, currentCirclePos.y);
            
            CGPoint nextCirclePos = nextCircle.position;
            nextCircle.position = ccp(nextCirclePos.x - SWITCH_WORLD_SPEED, nextCirclePos.y);
        }

        
    }else if(mode == SWITCHING_WORLD_LEFT){
        if(nextCircle.position.x >= screenWidth / 2 - SWITCH_WORLD_SPEED){
            nextCircle.position = ccp(screenWidth / 2, screenHeight / 2);
//            currentBackground.opacity = 0;
            nextBackground.opacity = 255;
            mode = NORMAL;
            [worldSelectionPage removeChild:currentRotatingCircles cleanup:NO];
            currentRotatingCircles = nextCircle;
            
            [worldSelectionPage removeChild:currentBackground cleanup:NO];
            currentBackground = nextBackground;
        }else{
            currentBackground.opacity -= BACKGROUND_OPACITY_SPEED;
            nextBackground.opacity += BACKGROUND_OPACITY_SPEED;
            CGPoint currentCirclePos = currentRotatingCircles.position;
            currentRotatingCircles.position = ccp(currentCirclePos.x + SWITCH_WORLD_SPEED, currentCirclePos.y);
            
            CGPoint nextCirclePos = nextCircle.position;
            nextCircle.position = ccp(nextCirclePos.x + SWITCH_WORLD_SPEED, nextCirclePos.y);
        }
    }

}

//init background sprites
-(CCSprite *) initWorldBackgroud{  
    
    backgroundsSpritesArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < WORLD_COUNT; i ++) {
        
        CCSprite *backgroundSprite = [[CCSprite alloc] initWithFile:backgroundsFilesName[i]];
        backgroundSprite.anchorPoint = CGPointZero;
        backgroundSprite.position = CGPointZero;
        [backgroundsSpritesArr addObject:backgroundSprite];
      
    }
     
    currentBackground = [backgroundsSpritesArr objectAtIndex : 0];
    return currentBackground;
}


//init center circles
-(CCSprite *) initCircles{
    circlesSpriteArr = [[NSMutableArray alloc] init];

    for (int i = 0; i < WORLD_COUNT; i++) {
        CCSprite *circleSprite = [[CCSprite alloc] initWithFile:circlesFilesName[i]];
        circleSprite.position = ccp(screenWidth/2, screenHeight/2);
        
        [circlesSpriteArr addObject:circleSprite];
    }
    
    currentRotatingCircles = [circlesSpriteArr objectAtIndex:0];
    return currentRotatingCircles;
}

-(CCSprite *) initDog{
    dogButton = [[CCSprite alloc] init ];
    dogButton.position = ccp(DOG_POS_X, DOG_POS_Y);
    
    CCSprite *dog = [[CCSprite alloc ] initWithFile:@"2Dog_big-80px.png"];
    [dogButton addChild:dog];
    
    dogRotatingCircle = [[CCSprite alloc] initWithFile:@"1green_dog1_indicator(white-transparent).png"];
    [dogButton addChild: dogRotatingCircle];
    
    return dogButton;
}

+(CCScene *) scene{
    CCScene *scene = [CCScene node];
   
    worldSelectionPage = [WorldSelectionPage node];
   
    
    [worldSelectionPage addChild:[worldSelectionPage initWorldBackgroud]];
    [worldSelectionPage addChild:[worldSelectionPage initCircles]];
    [worldSelectionPage addChild:[worldSelectionPage initDog]];
    
    [scene addChild: worldSelectionPage];
    
    return scene;
}

- (void)onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

-(void) dealloc{
    [backgroundsSpritesArr release];
    [circlesSpriteArr release];
    [worldSelectionPage removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"begin");
    startPoint = [self convertTouchToNodeSpace:touch];

    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{

}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"end");
    if(mode == NORMAL){
        endPoint = [self convertTouchToNodeSpace:touch];
        float dx = startPoint.x - endPoint.x;
        float dy = startPoint.y - endPoint.y;
        if(abs(dx) > MINIMUM_SWIPE_LENGTH && abs(dx) > abs(dy)){//swiped
            if(dx > 0){
                NSLog(@"go right");
                worldIndex ++;
                worldIndex = worldIndex % WORLD_COUNT;
                nextCircle = [circlesSpriteArr objectAtIndex:worldIndex];
                mode = SWITCHING_WORLD_RIGHT;
                nextCircle.position = ccp(screenWidth + [nextCircle boundingBox].size.width / 2, screenHeight / 2);
                

            }else{
                NSLog(@"go left");
                worldIndex --;
                if(worldIndex < 0) 
                    worldIndex = WORLD_COUNT + worldIndex;
                
                nextCircle = [circlesSpriteArr objectAtIndex:worldIndex];
                mode = SWITCHING_WORLD_LEFT;
                nextCircle.position = ccp(-[nextCircle boundingBox].size.width / 2, screenHeight / 2);
                nextBackground = [backgroundsSpritesArr objectAtIndex:worldIndex];
                
            }
            [worldSelectionPage addChild:nextCircle];
            
            nextBackground = [backgroundsSpritesArr objectAtIndex:worldIndex];
            [worldSelectionPage addChild:nextBackground];
            nextBackground.position = CGPointZero;
            nextBackground.opacity = BACKGROUND_INITIAL_OPACITY;
            [worldSelectionPage reorderChild:currentBackground z:1];
            [worldSelectionPage reorderChild:nextBackground z:0];
            [worldSelectionPage reorderChild:currentRotatingCircles z:3];
            [worldSelectionPage reorderChild:nextCircle z:3];
            [worldSelectionPage reorderChild:dogButton z:3];
        }
    }
}




@end
