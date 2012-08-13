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
        levels = [[NSMutableArray alloc] init];
        for(int i = 0; i < WORLD_COUNT; i++){
            [worldWrapperArr addObject: [[WorldWrapper alloc] init]];
            [levels addObject:[NSNull null]];
        }
//        [self setupReturnButton];
    }
    return self;
}

-(void) gobackFromLevelSelection{
    
    mode = SWITCHING_BACK_FROM_LEVEL_SELECTION;
    dots.visible = YES;
    currentRotatingCircles.visible = YES;
//    [worldSelectionPage removeChild:returnMenu cleanup:NO];
}



-(void)switchingToLevelSelectionPage{
    
    if(currentLevelSelection.position.x - screenWidth / 2 <= SWITCH_WORLD_SPEED){
        
        currentLevelSelection.position = ccp(screenWidth / 2, screenHeight / 2);
        currentRotatingCircles.visible = NO;
        mode = LEVEL_SELECTION;
//        [worldSelectionPage addChild:returnMenu];
        
    }else{
        
        currentLevelSelection.position = ccp(currentLevelSelection.position.x - SWITCH_WORLD_SPEED, currentLevelSelection.position.y);
        currentRotatingCircles.position = ccp(currentRotatingCircles.position.x - SWITCH_WORLD_SPEED, currentRotatingCircles.position.y);
    }
    
}

-(void) switchingFromLevelSelectionPage{
    
    if (screenWidth / 2 - currentRotatingCircles.position.x <= SWITCH_WORLD_SPEED) {
        [worldSelectionPage removeChild:currentLevelSelection cleanup:NO];
        currentRotatingCircles.position = ccp(screenWidth / 2, screenHeight / 2);
        mode = NORMAL;
    }else{
        
        currentLevelSelection.position = ccp(currentLevelSelection.position.x + SWITCH_WORLD_SPEED, currentLevelSelection.position.y);
        currentRotatingCircles.position = ccp(currentRotatingCircles.position.x + SWITCH_WORLD_SPEED, currentRotatingCircles.position.y);
    }
}

-(void) switchingWorld{
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

//update loop
-(void) update{
    currentRotatingCircles.rotation += CIRCLE_ROTATION_SPEED;
    dogRotatingCircle.rotation -= DOG_CIRCLE_ROTATION_SPEED;
    dogRotatingCircleBig.rotation -= DOG_CIRCLE_ROTATION_SPEED;
    
    [currentCloud update_posx:2 posy:2];
    if(mode == SWITCHING_WORLD_RIGHT || mode == SWITCHING_WORLD_LEFT){
        [self switchingWorld];
                
    }else if(mode == SWITCHING_TO_LEVEL_SELECTION){
        [self switchingToLevelSelectionPage];

    }else if(mode == SWITCHING_BACK_FROM_LEVEL_SELECTION){
        [self switchingFromLevelSelectionPage];
        
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
//            snow.rotation += 0.3;
        }
        
    }
    
    if(staring){
        CCArray *starArr = [stars children];
        for (int i = 0; i < [starArr count]; i++) {
            TwinklingStar *star = [starArr objectAtIndex:i];
            if (star.opacityIncreasing) {
                if (star.maxOpacity - star.opacity <= star.opacitySpeed) {
                    star.opacity = star.maxOpacity;
                    star.opacityIncreasing = NO;
                }else{
                    star.opacity += star.opacitySpeed;
                }
            }else {
                if(star.opacity - star.opacitySpeed <= star.opacitySpeed){
                    star.opacity = star.minOpacity;
                    star.opacityIncreasing = YES;
                }else {
                    star.opacity -= star.opacitySpeed;
                }
            }
        }
    }

}

-(CCSprite *) setupSnow{
    snows = [CCSprite node];
    snows.visible = NO;
    for (int i = 0; i < SNOW_COUNT; i++) {
        CCSprite *snow = [CCSprite spriteWithFile: arc4random() % 10 < 7 ? SNOW_FILE_1 : SNOW_FILE_2];
        snow.scale = 0.65;
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
        currentWrapper.backgroundSprite = [[CCSprite spriteWithFile:backgroundsFilesName[i]] retain];
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
    
    CCSprite *dog = [CCSprite spriteWithFile:@"2Dog_big-80px.png"];
    CCSprite *bigDog = [CCSprite spriteWithFile:@"2Dog_big-80px.png"];

    dogRotatingCircle = [CCSprite spriteWithFile:@"dog_dots.png"];
    dogRotatingCircleBig = [CCSprite spriteWithFile:@"dog_dots.png"];
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
    dots = [CCSprite node];
    
    for (int i = 0; i < WORLD_COUNT; i++) {
        CCSprite *dot = [CCSprite spriteWithFile:@"1green_dot_small.png"];
        [dots addChild:dot z:0 tag:i];
        dot.position = ccp((i - 1.0 * (WORLD_COUNT - 1) / 2) * DOT_GAP, 0);

    }
    CCSprite *bigDot = [CCSprite spriteWithFile:@"1green_dot_big.png"] ;
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
//    stars = [CCSprite spriteWithFile:@"3autumn_stars.png"];
    stars = [CCSprite node];
    for (int i = 0; i < STARS_COUNT; i++) {
        int fileR = arc4random() % 100;
        NSString *fileName;
        if(fileR < 50){
            fileName = @"star_1.png";
        }else if(fileR < 80){
            fileName = @"star_2.png";
        }else{
            fileName = @"star_3.png";
        }
        TwinklingStar *star = [TwinklingStar spriteWithFile:fileName];
        
        int randX = arc4random() % (int) screenWidth;
        float x;
        float startXDecrementor = 1 - STARS_X_INCREMENTOR;
        if(randX > screenWidth / 2){
            x = screenWidth * STARS_X_INCREMENTOR + randX * startXDecrementor;
        }else{
            x = randX * startXDecrementor;
        }
        
//        int y  = 260 + arc4random() % 140 - 80;
        int randY = arc4random() % (int)screenHeight;
        int y = screenHeight * STARS_Y_INCREMENTOR + randY * (1 - STARS_Y_INCREMENTOR);
        
        star.position = ccp(x, y);
        
        star.maxOpacity = arc4random() % 205 + 50;
//        star.minOpacity = arc4random() % star.maxOpacity;
        star.minOpacity = arc4random() % 50;
        star.opacitySpeed = arc4random() % 5 + 2;
        star.opacity = arc4random() % (star.maxOpacity - star.minOpacity)+ star.minOpacity;
        //        star.startOpacity = arc4random() % star.maxOpacity;
        star.opacityIncreasing = arc4random() % 2;
        
        [stars addChild:star];
        
    }
    stars.anchorPoint = CGPointZero;
    stars.visible = NO;
    return stars;
}

-(CCSprite *) setupLevelSelection{
    CCSprite *levelSelection = [CCSprite node];
    CCMenu *lsMenu = [CCMenu menuWithItems:nil];

    [levelSelection addChild:lsMenu];

    int levelReached = arc4random() % LEVEL_COUNT;
    for(int i = 0; i < LEVEL_COUNT; i++){
        NSString *fileName = i < levelReached ? [NSString stringWithFormat: @"Level-Selection_%d.png", i + 1] : @"Level-Selection_lock.png";
        CCMenuItem *levelButton = [self makeMenu:fileName imgsel:fileName onclick_target:self selector:@selector(selectLevel)];
        

        [lsMenu addChild:levelButton z:1 tag:i];
        
        float x = (i % LEVEL_SELECTION_WIDTH - (1.0 * LEVEL_SELECTION_WIDTH - 1) / 2) * LEVEL_SELECTION_X_GAP;
        float y = - (i / LEVEL_SELECTION_WIDTH - (1.0 * LEVEL_SELECTION_HEIGHT - 1) / 2) * LEVEL_SELECTION_Y_GAP + 40;
        
        levelButton.position = ccp(x - 240, y - 190);
        
        CCSprite *levelScore = [CCSprite node];
        for (int j = 0; j < LEVEL_SCORE_COUNT; j++) {
            NSString *levelStar = i < levelReached ? @"Level-Selection_gold-star.png" : @"Level-Selection_blank-star.png";
            CCSprite *levelScoreDot = [CCSprite spriteWithFile:levelStar];
            [levelScore addChild:levelScoreDot];
            int sdx = (j - (1.0 * LEVEL_SCORE_COUNT - 1) / 2) * LEVEL_SCORE_DOT_X_GAP;
            levelScoreDot.position = ccp(sdx, 0);
        }
        [levelSelection addChild:levelScore];
        levelScore.position = ccp(x, y - 55);
        
//        [fileName release];
    }

    levelSelection.position = ccp(screenWidth / 2, screenHeight / 2 + 20);
  
    
    return levelSelection;
}

//-(CCMenu *) setupReturnPageButton{
//    returnPageButton = [self makeMenu:RETURN_BUTTON_IMG imgsel:RETURN_BUTTON_WITHLIGHT_IMG onclick_target:self selector:@selector(finishPage)];
//    
//    returnPageMenu  = [CCMenu menuWithItems:returnPageButton, nil];
//    
//    returnPageMenu.position = ccp(RETURN_BUTTON_X, RETURN_BUTTON_Y);
//    
//    return returnPageMenu;
//}

-(void) returnPage{
    if(mode == NORMAL){
        [[CCDirector sharedDirector] replaceScene: [CoverPage scene]];
    }else if(mode == LEVEL_SELECTION){
        [self gobackFromLevelSelection];
    }
}

-(CCMenu *) setupReturnButton{
    
    returnButton = [self makeMenu: RETURN_BUTTON_IMG imgsel:RETURN_BUTTON_WITHLIGHT_IMG onclick_target:self selector:@selector(returnPage)];
    returnMenu = [[CCMenu menuWithItems:returnButton, nil] retain];
    returnMenu.position = ccp(RETURN_BUTTON_X, RETURN_BUTTON_Y);
    
    return returnMenu;
}

+(CCScene *) scene{
    CCScene *scene = [CCScene node];
   
    worldSelectionPage = [WorldSelectionPage node];
       
    [worldSelectionPage addChild:[worldSelectionPage setupWorldBackgroud]];
    [worldSelectionPage addChild:[worldSelectionPage setupCircles]];
    [worldSelectionPage addChild:[worldSelectionPage setupDog]];
    [worldSelectionPage addChild:[worldSelectionPage setupDots]];
//    [worldSelectionPage addChild:[worldSelectionPage setupClouds]];
    [worldSelectionPage addChild:[worldSelectionPage setupSnow]];
    [worldSelectionPage addChild:[worldSelectionPage setupStars]];
    [worldSelectionPage addChild:[worldSelectionPage setupReturnButton]];
    
    
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
    
    [levels release];
//    [returnMenu removeAllChildrenWithCleanup:YES];
//    [returnMenu release];
//    
//    [snows removeAllChildrenWithCleanup:YES];
//    
//    [dogButton removeAllChildrenWithCleanup:YES];
//    [dogMenu removeAllChildrenWithCleanup:YES];
    
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
            [worldSelectionPage reorderChild:circleMenu z:5];
            [worldSelectionPage reorderChild:dogMenu z:5];
            [worldSelectionPage reorderChild:dots z:4];
            [worldSelectionPage reorderChild:returnMenu z:4];
        }
    }
}

//will be called when a circle is clicked
-(void) selectWorld{
    NSLog(@"select world");
    if([levels objectAtIndex:worldIndex] == [NSNull null]){
        
        [levels replaceObjectAtIndex:worldIndex withObject:[self setupLevelSelection]];
        
    }
    currentLevelSelection = [levels objectAtIndex:worldIndex];
    currentLevelSelection.position = ccp(screenWidth, screenHeight / 2);
    [worldSelectionPage addChild:currentLevelSelection];
    dots.visible = NO;
    mode = SWITCHING_TO_LEVEL_SELECTION;
    
}


//will be called when the dog is clicked
-(void) selectDog{
    NSLog(@"dog clicked");
}

-(void) selectLevel{
    NSLog(@"select level");
    [[CCDirector sharedDirector] replaceScene: [GameEngineLayer scene_with:@"test"]];
}

-(void) finishPage{
    NSLog(@"finish page");
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
