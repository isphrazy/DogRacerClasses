//
//  CCCircularSelector.m
//  PuzzlePack
//
//  Created by Tang Eric on 05/03/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "ThemeSelectionPage.h"
#import "GameEngineLayer.h"
#import "MapLoader.h"
#import "ThemeInfo.h"

#define THEME_PAGE_BACKGROUND_FILE @"theme_selection_bg.jpg"          

static NSArray *maps_file;

float degreeToRadian(float degree){
    return degree/180.0f*M_PI;
}

float radianToDegree(float radian){
    return radian/M_PI*180.0f;
}

@implementation ThemeSelectionPage

@synthesize delegate=delegate_;
@synthesize selectionIndex=selectionIndex_;
@synthesize choices=choices_;

@synthesize rotationMode=rotationMode_;
@synthesize touchArea=touchArea_;

@synthesize center=center_;

// property with explicit setters
@synthesize frontScale=frontScale_, backScale=backScale_;
@synthesize radiusX=radiusX_, radiusY=radiusY_;

@synthesize deceleration=deceleration_;
@synthesize decelerationMode=decelerationMode_;

+(ThemeSelectionPage*)layerWithChoices:(NSArray*)someChoices{
    return [[[ThemeSelectionPage alloc] initWithChoices:someChoices] autorelease];
}


+(NSArray *) loadThemePic{
    NSArray *themes = [MapLoader load_themes_info];
    NSMutableArray *themes_pic_name = [[NSMutableArray alloc ] init ];
    NSMutableArray *m_map_file = [[NSMutableArray alloc] init ];
    [themes_pic_name addObject:THEME_PAGE_BACKGROUND_FILE];
    [themes_pic_name addObject:THEME_PAGE_BACKGROUND_FILE];
    for(ThemeInfo *theme in themes){
        [themes_pic_name addObject:theme.pic_name];
        [themes_pic_name addObject:theme.pic_name];
        [m_map_file addObject:theme.map_name];
        [m_map_file addObject:theme.map_type];
    }
    maps_file = [[NSArray alloc] initWithArray:m_map_file];
    
    [Resource init_menu_textures: [[NSArray alloc] initWithArray:themes_pic_name ]];
    NSMutableArray *theme_pic_sprite = [[NSMutableArray alloc] init ];
    for(ThemeInfo *theme in themes){
        CCTexture2D *texture= [Resource get_tex:theme.pic_name];
        CCSprite *img = [CCSprite spriteWithTexture:texture];
        
        img.anchorPoint = ccp(0, 0);
        [theme_pic_sprite addObject:img];
        
    }

    NSArray *result = [[NSArray alloc] initWithArray:theme_pic_sprite];
    return result;
}

-(CCLayer *) createBackground{
    CCLayer *background = [[CCLayer alloc] init];
    CCSprite *bg_sp = [CCSprite spriteWithTexture:[Resource get_tex:@"theme_selection_bg.jpg"]];
    
    bg_sp.anchorPoint = ccp(0, 0);
    [background addChild:bg_sp];
    return background;
}

+(CCScene *) scene{
    
    [[CCDirector sharedDirector] setDisplayFPS:NO];
    CCScene *scene = [CCScene node];
    //BGLayer *bglayer = [BGLayer node];
    
    
    ThemeSelectionPage *selector = [[ThemeSelectionPage alloc] initWithChoices:[ThemeSelectionPage loadThemePic]];
    [scene addChild:[selector createBackground]];
    [scene addChild: selector];
    return scene;
}


-(ThemeSelectionPage*)initWithChoices:(NSArray*)someChoices{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCNode *tempNode;
    NSMutableArray *tempChoices = [NSMutableArray arrayWithCapacity:0];
    id tempChoice;
    if ((self = [super init])) {
        if (someChoices == nil) {
            NSLog(@"[CCCircularSelector initWithChoices] choices must not be nil");
            return nil;
        }
        if (someChoices.count < 1) {
            NSLog(@"[CCCircularSelector initWithChoices] at least one choice should be provided");
            return nil;
        }
        for (int i = 0; i < someChoices.count; i++) {
            tempChoice = [someChoices objectAtIndex:i];
            if ([tempChoice isKindOfClass:[CCNode class]]) {
                tempNode = tempChoice;
            } else {
                NSLog(@"[CCCircularSelector initWithChoices] choices %d is not a CCNode, we will replace it with a blank CCNode", i);
                tempNode = [CCNode node];
            }
            [tempChoices addObject:tempNode];
            [self addChild:tempNode];
        }
        choices_ = [[NSArray alloc] initWithArray:tempChoices];
        
        isDragging_ = NO;
        selectionIndex_ = 0;
        angle_ = 0.0f;
        rotationSpeedFactor_ = 0.3f;
        
        rotationMode_ = kCCCircularSelectorRotationModeDrag | kCCCircularSelectorRotationModeTapItem | kCCCircularSelectorRotationModeTapLeftRight;
        touchArea_ = CGRectMake(0.0f, 0.0f, winSize.width, winSize.height);
        
        //center_ = CGPointZero;
        //get the center of the screen
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        center_.x = screenWidth / 2 + 60;
        center_.y = screenHeight / 2 - 30;
        
        radiusX_ = self.contentSize.width * 0.35f;
        radiusY_ = self.contentSize.height * 0.25f;
        frontScale_ = 1.0f;
        backScale_ = 0.6f;
        
        // inertia
        dTheta_ = 0.0f;
        deceleration_ = 800.0f;
        dThetaThreshold_ = 50.0f;
        decelerationMode_ = kCCCircularSelectorDecelerationModeLinear;
        
        self.isTouchEnabled = YES; 
        
        [self positionChoices];
    }
    return self;
}

-(void)dealloc{
    [choices_ release];
    [super dealloc];
}

-(CCNode*)getSelectedNode{
    return [choices_ objectAtIndex:selectionIndex_];
}

-(void)rotateToIndex:(int)newIndex{
    dTheta_ = 360.0f*0.75f;
    targetAngle_ = [self correctAngle:-((float)newIndex/(float)choices_.count)*360.0f];
    if (delegate_ && [delegate_ respondsToSelector:@selector(rotationBegan:)]) {
        [delegate_ rotationBegan:self];
    }
    [self schedule:@selector(rotateToTargetAngle:)];
}

#pragma mark -

-(NSArray*)getSortedChoices{
    // sort choices by their z
    NSMutableArray *sortedChoices = [NSMutableArray arrayWithCapacity:choices_.count];
    int i, j;
    float z1, z2;
    BOOL inserted;
    for (i = 0; i < choices_.count; i++) {
        inserted = NO;
        for (j = 0; j < sortedChoices.count; j++) {
            z1 = [self getNormalizedXZCoordinatesForAngle:[self getAngleForChoice:i]].y;
            z2 = [self getNormalizedXZCoordinatesForAngle:[self getAngleForChoice:[[sortedChoices objectAtIndex:j] intValue]]].y;
            if (z1 < z2) {
                [sortedChoices insertObject:[NSNumber numberWithInt:i] atIndex:j];
                inserted = YES;
                break;
            }
        }
        if (!inserted) {
            [sortedChoices addObject:[NSNumber numberWithInt:i]];
        }
    }
    return [NSArray arrayWithArray:sortedChoices];
}

-(void)positionChoices{
    CCNode *choice;
    CGPoint xzPoint;
    NSArray *sortedChoices;
    float t;
    int i, j;
    for (i = 0; i < choices_.count; i++) {
        xzPoint = [self getNormalizedXZCoordinatesForAngle:[self getAngleForChoice:i]];
        t = [self getTFromZ:xzPoint.y];
        choice = [choices_ objectAtIndex:i];
        choice.anchorPoint = ccp(0.5f, 0.5f);
        choice.position = ccp(center_.x + xzPoint.x*radiusX_, center_.y - xzPoint.y*radiusY_);
        choice.scale = [self getScaleFromT:t];
    }
    
    
    sortedChoices = [self getSortedChoices];
    j = 0;
    for (i = 0; i < sortedChoices.count; i++) { // count the nodes with negative Z
        if ([self getNormalizedXZCoordinatesForAngle:[self getAngleForChoice:i]].y > 0) {
            j++;
        }
    }
    j = -1*j;
    for (i = 0; i < sortedChoices.count; i++) { // nodes with negative z in modeling space get negative z in node space
        [self reorderChild:[choices_ objectAtIndex:[[sortedChoices objectAtIndex:i] intValue]] z:j++];
    }
    if (selectionIndex_ != [[sortedChoices lastObject] intValue]) {
        selectionIndex_ = [[sortedChoices lastObject] intValue];
        if (delegate_ && [delegate_ respondsToSelector:@selector(selectionDidChange:circularSelector:)]) {
            [delegate_ selectionDidChange:selectionIndex_ circularSelector:self];
        }
    }
}

-(float)getAngleForChoice:(int)index{
    return angle_+(360.0f*index/choices_.count);
}

-(CGPoint)getNormalizedXZCoordinatesForAngle:(float)theta{
    // this method return x and z coordinates of the node
    return CGPointMake(sinf(degreeToRadian(theta)), cosf(degreeToRadian(theta)));
}

-(float)getTFromZ:(float)z{
    // t: 0.0 - 1.0 inclusive
    // 1.0 = front
    // 0.0 = back
    return (z - -1.0f)/(1.0f - -1.0f);
}

-(float)getScaleFromT:(float)t{
    return t*frontScale_ + (1.0f-t)*backScale_;
}

-(float)getYFromT:(float)t{
    return center_.y+radiusY_ - radiusY_*t;
}

-(float)correctAngle:(float)angle{
    // keep the angle in 0 <= x < 360 range
    while (angle >= 360.0f) {
        angle -= 360.0f;
    }
    while (angle < 0) {
        angle += 360.0f;
    }
    return angle;
}

-(float)getAngleForTouchPoint:(CGPoint)point{
    CGPoint normalizedPoint = ccp((point.x-center_.x)/radiusX_, (point.y-center_.y)/radiusY_);
    return radianToDegree(atanf(-(normalizedPoint.x/normalizedPoint.y))) + (normalizedPoint.y>=0 ? 180.0f : 0.0f);
}

-(void)decelerate:(ccTime)dt{
    //NSLog(@"[CCCircularSelector decelerate:] dt: %f", dt);
    //NSLog(@"[CCCircularSelector decelerate:] deceleration: %f, dt: %f, dTheta: %f, ", deceleration_, dt, dTheta_);
    if (dt > 0.0f) {
        if (decelerationMode_ == kCCCircularSelectorDecelerationModeLinear) {
            if (deceleration_ > 0.0f) {
                if (dTheta_ > 0) {
                    if (dTheta_ > (deceleration_*dt)) {
                        dTheta_ -= (deceleration_*dt);
                    } else {
                        dTheta_ = 0.0f;
                    }
                } else {
                    if (dTheta_ < (deceleration_*dt)) {
                        dTheta_ += (deceleration_*dt);
                    } else {
                        dTheta_ = 0.0f;
                    }
                }
            } else {
                dTheta_ = 0.0f;
            }
        } else {
            if (deceleration_ > 0.0f && deceleration_ <= 1.0f) {
                dTheta_ *= pow((double)(1.0f-deceleration_), (double)dt);
            } else {
                dTheta_ = 0.0f;
            }
        }
        
        if (fabsf(dTheta_) < dThetaThreshold_) {
            dTheta_ = dThetaThreshold_;
            targetAngle_ = roundf(angle_/(360.0f/(float)choices_.count))*(360.0f/(float)choices_.count);
            [self unschedule:@selector(decelerate:)];
            [self schedule:@selector(rotateToTargetAngle:)];
        } else {
            angle_ = [self correctAngle:angle_+(dTheta_*dt)];
            [self positionChoices];
        }
    }
}

-(void)rotateToTargetAngle:(ccTime)dt{
    //NSLog(@"[CCCircularSelector rotateToTargetAngle:] dt: %f, targetAngle: %f, angle: %f, threshold*dt: %f", dt, targetAngle_, angle_, dThetaThreshold_*dt);
    targetAngle_ = [self correctAngle:targetAngle_];
    if (targetAngle_>angle_) {
        if (targetAngle_<angle_+180.0f) {
            // right
            dTheta_ = fabsf(dTheta_);
        } else {
            dTheta_ = -fabsf(dTheta_);
        }
    } else {
        if (targetAngle_>angle_-180.0f) {
            // right
            dTheta_ = -fabsf(dTheta_);
        } else {
            dTheta_ = fabsf(dTheta_);
        }
    }
    if (fabsf(targetAngle_-angle_) <= fabsf(dTheta_*dt)) {
        angle_ = targetAngle_;
        dTheta_ = 0.0f;
        [self unschedule:@selector(rotateToTargetAngle:)];
        if (delegate_ && [delegate_ respondsToSelector:@selector(rotationEnded:)]) {
            [delegate_ rotationEnded:self];
        }
    } else {
        angle_ += dTheta_*dt;
    }
    angle_ = [self correctAngle:angle_];
    [self positionChoices];
}

-(void)stopInertia{
    [self unschedule:@selector(decelerate:)];
    [self unschedule:@selector(rotateToTargetAngle:)];
    dTheta_ = 0.0f;
}

#pragma mark -
#pragma mark stage event


- (void)onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
}

- (void)onExit{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

#pragma mark -
#pragma mark touch event


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(touchArea_, [self convertToWorldSpace:[self convertTouchToNodeSpace:touch]])){
        // this touch in touchArea
        [self stopInertia];
        lastAngle_ = angle_;
        lastAngleTime_ = [[NSDate date] timeIntervalSince1970];
        return YES;
    }else {
        return NO;
    }
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ((rotationMode_ & kCCCircularSelectorRotationModeDrag) > 0) {
        if (!isDragging_ && delegate_ && [delegate_ respondsToSelector:@selector(rotationBegan:)]) {
            [delegate_ rotationBegan:self];
        }
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        
        
        CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
        CGPoint prevTouchPoint = [self convertToNodeSpace:[[CCDirector sharedDirector] convertToGL: [touch previousLocationInView:[CCDirector sharedDirector].openGLView]]];
        
        angle_ = angle_+[self getAngleForTouchPoint:touchPoint]-[self getAngleForTouchPoint:prevTouchPoint];
        dTheta_ = (angle_ - lastAngle_)/(currentTime - lastAngleTime_);
        if (MAX_ANGULAR_VELOCITY > 0.0f && fabsf(dTheta_) > MAX_ANGULAR_VELOCITY) {
            if (dTheta_ > 0) {
                dTheta_ = MAX_ANGULAR_VELOCITY;
            } else {
                dTheta_ = -MAX_ANGULAR_VELOCITY;
            }
            
        }
        
        angle_ = [self correctAngle:angle_];
        [self positionChoices];
        lastAngle_ = angle_;
        lastAngleTime_ = currentTime;
    }
    isDragging_ = YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isDragging_) {
        if ((rotationMode_ & kCCCircularSelectorRotationModeDrag) > 0) {
            [self schedule:@selector(decelerate:)];
        }
        isDragging_ = NO;
    } else {
        [self tapped:touch];
    }
}

-(void)tapped:(UITouch*)touch{
    CCNode *currentChoice = [choices_ objectAtIndex:selectionIndex_];
    CCNode *tempChoice, *tempTopChoice;
    
    // if the touch point is in the area of the node
    // no need to scale the area even if the node is scaled, because the touch point relative to the node is already scaled
    if (CGRectContainsPoint(CGRectMake(0, 0, currentChoice.contentSize.width,currentChoice.contentSize.height), [currentChoice convertTouchToNodeSpace:touch])) {
        
        // the selected choice is tapped
        if (delegate_ && [delegate_ respondsToSelector:@selector(selectionDidDecide:circularSelector:)]) {
            [delegate_ selectionDidDecide:selectionIndex_ circularSelector:self];
        }
        NSLog(@"index: %d", selectionIndex_);
        NSLog(@"%@", [maps_file objectAtIndex:selectionIndex_ * 2]);
        NSLog(@"%@", [maps_file objectAtIndex:selectionIndex_ * 2 + 1]);
        [[CCDirector sharedDirector] replaceScene:[GameEngineLayer scene_with: [maps_file objectAtIndex:selectionIndex_ * 2]  
                                                                      of_type:[maps_file objectAtIndex:selectionIndex_ * 2 + 1]]];
    } else {
        // other place is tapped
        tempTopChoice = nil;
        for (tempChoice in choices_) {
            
            if (tempChoice == currentChoice) {
                
                continue;
            }
            if (tempTopChoice && tempChoice.zOrder < tempTopChoice.zOrder) {
                continue;
            }
            if (CGRectContainsPoint(CGRectMake(tempChoice.position.x-tempChoice.contentSize.width*tempChoice.scaleX/2.0f, 
                                               tempChoice.position.y-tempChoice.contentSize.height*tempChoice.scaleY/2.0f, 
                                               tempChoice.contentSize.width*tempChoice.scaleX,
                                               tempChoice.contentSize.height*tempChoice.scaleY)
                                    , [self convertTouchToNodeSpace:touch])) {
                tempTopChoice = tempChoice;
            }
        }
        if (tempTopChoice && ((rotationMode_ & kCCCircularSelectorRotationModeTapItem) > 0)) { // a specific choice is tapped
            [self rotateToIndex:[choices_ indexOfObject:tempTopChoice]];
        } else if ((rotationMode_ & kCCCircularSelectorRotationModeTapLeftRight) > 0) { // empty space tapped, rotate left / right
            if ([self convertTouchToNodeSpace:touch].x > center_.x) {
                [self rotateToIndex:(selectionIndex_+1)%choices_.count];
            } else {
                [self rotateToIndex:(selectionIndex_+choices_.count-1)%choices_.count];
            }
        }
    }
}

#pragma mark -
#pragma mark explicit setters

-(void)setFrontScale:(float)newFrontScale{
    frontScale_ = newFrontScale;
    [self positionChoices];
}

-(void)setBackScale:(float)newBackScale{
    backScale_ = newBackScale;
    [self positionChoices];
}

-(void)setCenter:(CGPoint)newCenter{
    center_ = newCenter;
    [self positionChoices];
}

-(void)setradiusX:(float)newRadiusX{
    radiusX_ = newRadiusX;
    [self positionChoices];
}

-(void)setRadiusY:(float)newRadiusY{
    radiusY_ = newRadiusY;
    [self positionChoices];
}
@end
