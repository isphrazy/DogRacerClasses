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
        snowing = NO;
        [self schedule:@selector(update)];
        worldIndex = 0;
        screenHeight = [UIScreen mainScreen].bounds.size.width;
        screenWidth = [UIScreen mainScreen].bounds.size.height;
        worldWrapperArr = [[NSMutableArray alloc] init];
        for(int i = 0; i < WORLD_COUNT; i++){
            [worldWrapperArr addObject: [[WorldWrapper alloc] init]];
        }
    }
    return self;
}

//update loop
-(void) update{
    currentRotatingCircles.rotation += CIRCLE_ROTATION_SPEED;
    dogRotatingCircle.rotation -= DOG_CIRCLE_ROTATION_SPEED;
    dogRotatingCircleBig.rotation -= DOG_CIRCLE_ROTATION_SPEED;
    
    [currentCloud update_posx:2 posy:2];
    if(mode == SWITCHING_WORLD_RIGHT || mode == SWITCHING_WORLD_LEFT){
        BOOL end = NO;
        if(mode == SWITCHING_WORLD_RIGHT){
            if(nextCircle.position.x <= screenWidth / 2 + SWITCH_WORLD_SPEED){
                end = YES;
//                
            }else{
                currentBackground.opacity -= BACKGROUND_OPACITY_SPEED;
                nextBackground.opacity += BACKGROUND_OPACITY_SPEED;
                CGPoint currentCirclePos = currentRotatingCircles.position;
                currentRotatingCircles.position = ccp(currentCirclePos.x - SWITCH_WORLD_SPEED, currentCirclePos.y);
                
                CGPoint nextCirclePos = nextCircle.position;
                nextCircle.position = ccp(nextCirclePos.x - SWITCH_WORLD_SPEED, nextCirclePos.y);
            }
            
            
        }else{
            if(nextCircle.position.x >= screenWidth / 2 - SWITCH_WORLD_SPEED){
                end = YES;
            }else{
                currentBackground.opacity -= BACKGROUND_OPACITY_SPEED;
                nextBackground.opacity += BACKGROUND_OPACITY_SPEED;
                CGPoint currentCirclePos = currentRotatingCircles.position;
                currentRotatingCircles.position = ccp(currentCirclePos.x + SWITCH_WORLD_SPEED, currentCirclePos.y);
                
                CGPoint nextCirclePos = nextCircle.position;
                nextCircle.position = ccp(nextCirclePos.x + SWITCH_WORLD_SPEED, nextCirclePos.y);
            }
        }
        
        if (end){
            nextCircle.position = ccp(screenWidth / 2, screenHeight / 2);
            
            nextBackground.opacity = 255;
            mode = NORMAL;
            [circleMenu removeChild:currentRotatingCircles cleanup:NO];
            currentRotatingCircles = nextCircle;
            
            [worldSelectionPage removeChild:currentBackground cleanup:NO];
            
            currentBackground = nextBackground;
            
            if(worldIndex == SNOW_WORLD_INDEX){
                snowing = YES;
                snows.visible = YES;
            }else if(snowing){
                snowing = NO;
                snows.visible = NO;
            }
            
            if(worldIndex ==  STARS_WORLD_INDEX){
                [worldSelectionPage reorderChild:stars z:4];
                staring = YES;
                stars.visible = YES;
            }else if(staring){
                staring = NO;
                stars.visible = NO;
            }
        }
        
    }
    if(snowing){
        CCArray * snowArr = [snows children];
        for (int i = 0; i < [snowArr count]; i++){
            
            CCSprite *snow = [snowArr objectAtIndex:i];
            if(snow.position.y < 0){
                int randX = arc4random() % (int)screenWidth;
                snow.position = ccp(randX, screenHeight + 10);
            }
            snow.position = ccp(snow.position.x, snow.position.y - SNOW_SPEED);
        }
        
    }

}

-(CCSprite *) setupSnow{
    snows = [[CCSprite alloc] init ];
    snows.visible = NO;
    for (int i = 0; i < SNOW_COUNT; i++) {
        CCSprite *snow = [[CCSprite alloc] initWithFile:SNOW_FILE];
        
        [snows addChild:snow];
        
        int randX = arc4random() % (int)screenWidth;
        int randY = arc4random() % (int)screenHeight;
        
        snow.position = ccp(randX, randY);
        
    }
    
    return snows;
}

//init background sprites
-(CCSprite *) setupWorldBackgroud{  
    
    for (int i = 0; i < WORLD_COUNT; i ++) {
        
        WorldWrapper *currentWrapper = [worldWrapperArr objectAtIndex:i];
        currentWrapper.backgroundSprite = [[CCSprite alloc] initWithFile:backgroundsFilesName[i]];
        currentWrapper.backgroundSprite.anchorPoint = CGPointZero;
        currentWrapper.backgroundSprite.position = CGPointZero;
        
        //[backgroundsSpritesArr addObject:backgroundSprite];
      
    }
     
    WorldWrapper *currentWrapper = [worldWrapperArr objectAtIndex:0];
    currentBackground = currentWrapper.backgroundSprite;
    return currentBackground;
}


//init center circles
-(CCMenu *) setupCircles{

    
    for (int i = 0; i < WORLD_COUNT; i++) {
        WorldWrapper *currentWrapper = [worldWrapperArr objectAtIndex:i];
        currentWrapper.circle = [[self makeMenu:circlesFilesName[i] imgsel:circlesFilesName[i] onclick_target:self selector:@selector(selectWorld)] retain];

    }
    WorldWrapper *currentWrapper = [worldWrapperArr objectAtIndex:0];
    currentRotatingCircles = currentWrapper.circle;
    circleMenu = [CCMenu menuWithItems:currentWrapper.circle, nil];
    currentWrapper.circle.position = ccp(screenWidth/2, screenHeight/2);
    circleMenu.position = CGPointZero;

    return circleMenu;
}

-(CCMenu *) setupDog{
    
    CCSprite *dog = [[CCSprite alloc ] initWithFile:@"2Dog_big-80px.png"];
    CCSprite *bigDog = [[CCSprite alloc ] initWithFile:@"2Dog_big-80px.png"];

    dogRotatingCircle = [[CCSprite alloc] initWithFile:@"1green_dog1_indicator(white-transparent).png"];
    dogRotatingCircleBig = [[CCSprite alloc] initWithFile:@"1green_dog1_indicator(white-transparent).png"];
    dogRotatingCircle.position = ccp(DOG_POS_X - DOG_CIRCLE_OFFSET_X, 
                                     DOG_POS_Y - DOG_CIRCLE_OFFSET_Y);
    dogRotatingCircleBig.position = ccp(DOG_POS_X - DOG_CIRCLE_OFFSET_X,
                                        DOG_POS_Y - DOG_CIRCLE_OFFSET_Y);
    
    
    [dog addChild: dogRotatingCircle];
    [bigDog addChild:dogRotatingCircleBig];
    
    [self set_zoom_pos_align:dog zoomed:bigDog scale:1.2];
    dogButton = [CCMenuItemImage itemFromNormalSprite:dog selectedSprite:bigDog target:self selector:@selector(selectDog)];
    
        
    dogMenu = [CCMenu menuWithItems:dogButton, nil];
    dogMenu.position = ccp(DOG_POS_X, DOG_POS_Y);
    return dogMenu;
}

-(CCSprite *) setupDots{
    dots = [[CCSprite alloc] init ];
    
    for (int i = 0; i < WORLD_COUNT; i++) {
        CCSprite *dot = [[CCSprite alloc] initWithFile:@"1green_dot_small.png"];
        [dots addChild:dot z:0 tag:i];
        dot.position = ccp((i - 1.0 * (WORLD_COUNT - 1) / 2) * DOT_GAP, 0);

    }
    CCSprite *bigDot = [[CCSprite alloc] initWithFile:@"1green_dot_big.png"] ;
    bigDot.position = [dots getChildByTag:0].position;

    [dots addChild:bigDot z:1 tag:WORLD_COUNT];
    dots.position = ccp(screenWidth / 2, DOT_HEIGHT);
    return dots;
}

-(BackgroundObject *) setupClouds{
    CCTexture2D *cloudText = [[CCTextureCache sharedTextureCache] addImage:@"1green_cloud.png"];

    currentCloud = [BackgroundObject backgroundFromTex:cloudText scrollspd_x:2 scrollspd_y:2];
    currentCloud.position = ccp(screenWidth / 2, 200);
    return currentCloud;
}

-(CCSprite *) setupStars{
    stars = [[CCSprite alloc] initWithFile:@"3autumn_stars.png"];
    stars.anchorPoint = CGPointZero;
    stars.visible = NO;
    return stars;
}

-(CCSprite *) setupLevelSelection{
    levelSelection = [[CCSprite alloc ] init ];
    CCMenu *lsMenu = [CCMenu menuWithItems:nil];
//    lsMenu.anchorPoint = ccp([lsMenu boundingBox].size.width, [lsMenu boundingBox].size.height);
    [levelSelection addChild:lsMenu];
//    levelSelection = [CCMenu menuWithItems:nil];
    
    for(int i = 0; i < LEVEL_COUNT; i++){
        NSString *fileName = [NSString stringWithFormat: @"Level-Selection_%d.png", i + 1];
        CCMenuItem *levelButton = [self makeMenu:fileName imgsel:fileName onclick_target:self selector:@selector(selectLevel)];
        
//        [levelSelection addChild:levelButton];
        [lsMenu addChild:levelButton z:1 tag:i];
        
        float x = (i % LEVEL_SELECTION_WIDTH - (1.0 * LEVEL_SELECTION_WIDTH - 1) / 2) * LEVEL_SELECTION_X_GAP;
        float y = - (i / LEVEL_SELECTION_WIDTH - (1.0 * LEVEL_SELECTION_HEIGHT - 1) / 2) * LEVEL_SELECTION_Y_GAP + 40;
        
        levelButton.position = ccp(x - 240, y - 190);
        
        CCSprite *levelScore = [[CCSprite alloc ] init ];
        for (int j = 0; j < LEVEL_SCORE_COUNT; j++) {
            CCSprite *levelScoreDot = [[CCSprite alloc] initWithFile:@"Level-Selection_gold-star.png"];
            [levelScore addChild:levelScoreDot];
            int sdx = (j - (1.0 * LEVEL_SCORE_COUNT - 1) / 2) * LEVEL_SCORE_DOT_X_GAP;
            levelScoreDot.position = ccp(sdx, 0);
        }
        [levelSelection addChild:levelScore];
        levelScore.position = ccp(x, y - 55);
        
    }
//    lsMenu.position = ccp(screenWidth / 2, screenHeight / 2 + 20);
    levelSelection.position = ccp(screenWidth / 2, screenHeight / 2 + 20);
  
    levelSelection.visible = NO;
    return levelSelection;
}

+(CCScene *) scene{
    CCScene *scene = [CCScene node];
   
    worldSelectionPage = [WorldSelectionPage node];
       
    [worldSelectionPage addChild:[worldSelectionPage setupWorldBackgroud]];
    [worldSelectionPage addChild:[worldSelectionPage setupCircles]];
    [worldSelectionPage addChild:[worldSelectionPage setupDog]];
    [worldSelectionPage addChild:[worldSelectionPage setupDots]];
    [worldSelectionPage addChild:[worldSelectionPage setupClouds]];
    [worldSelectionPage addChild:[worldSelectionPage setupSnow]];
    [worldSelectionPage addChild:[worldSelectionPage setupStars]];
    [worldSelectionPage addChild:[worldSelectionPage setupLevelSelection]];
    
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
//    [backgroundsSpritesArr release];
//    [circlesSpriteArr release];
    for(int i = 0; i < [worldWrapperArr count]; i++){
        [[worldWrapperArr objectAtIndex:i] release];
    }
    [worldWrapperArr release];
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
                WorldWrapper *world = [worldWrapperArr objectAtIndex:worldIndex];
                nextCircle = world.circle;
                mode = SWITCHING_WORLD_RIGHT;
                [circleMenu addChild:nextCircle z:1 tag:1];
                nextCircle.position = ccp(screenWidth + [nextCircle boundingBox].size.width / 2, screenHeight / 2);
                

            }else{
                NSLog(@"go left");
                worldIndex --;
                if(worldIndex < 0) 
                    worldIndex = WORLD_COUNT + worldIndex;
                WorldWrapper *world = [worldWrapperArr objectAtIndex:worldIndex];
                nextCircle = world.circle;
                mode = SWITCHING_WORLD_LEFT;
                [circleMenu addChild:nextCircle];
                nextCircle.position = ccp(-[nextCircle boundingBox].size.width / 2, screenHeight / 2);
             
//                nextBackground = [backgroundsSpritesArr objectAtIndex:worldIndex];
                
            }
            
            [dots getChildByTag:WORLD_COUNT].position = [dots getChildByTag:worldIndex].position;
            
            WorldWrapper *world = [worldWrapperArr objectAtIndex:worldIndex];
            nextBackground = world.backgroundSprite;
            
            [worldSelectionPage addChild:nextBackground];
            nextBackground.position = CGPointZero;
            nextBackground.opacity = BACKGROUND_INITIAL_OPACITY;
            [worldSelectionPage reorderChild:currentBackground z:1];
            [worldSelectionPage reorderChild:nextBackground z:0];
//            [worldSelectionPage reorderChild:currentRotatingCircles z:3];
            [worldSelectionPage reorderChild:circleMenu z:3];
            [worldSelectionPage reorderChild:dogMenu z:5];
            [worldSelectionPage reorderChild:dots z:4];
        }
    }
}

//will be called when a circle is clicked
-(void) selectWorld{
    NSLog(@"select world");
}


//will be called when the dog is clicked
-(void) selectDog{
    NSLog(@"dog clicked");
}

-(void) selectLevel{
    NSLog(@"select level");
}

-(CCMenuItem*)makeMenu:(NSString*)imgfile imgsel:(NSString*)imgselfile onclick_target:(NSObject*)tar selector:(SEL)sel {
    CCSprite *img = [CCSprite spriteWithFile:imgfile];
    CCSprite *img_zoom = [CCSprite spriteWithFile:imgselfile];
    [self set_zoom_pos_align:img zoomed:img_zoom scale:1.2];
    return [CCMenuItemImage itemFromNormalSprite:img selectedSprite:img_zoom target:tar selector:sel];
}

-(void)set_zoom_pos_align:(CCSprite*)normal zoomed:(CCSprite*)zoomed scale:(float)scale {
   
    zoomed.scale = scale;
    zoomed.position = ccp((-[zoomed contentSize].width * zoomed.scale + [zoomed contentSize].width)/2
                          ,(-[zoomed contentSize].height * zoomed.scale + [zoomed contentSize].height)/2);
}

@end
