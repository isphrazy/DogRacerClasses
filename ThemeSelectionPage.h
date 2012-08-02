//
//  CCCircularSelector.h
//  PuzzlePack
//
//  Created by Tang Eric on 05/03/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#define MAX_ANGULAR_VELOCITY    360.0f*2.5f

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <math.h>
#import "Resource.h"

typedef enum{
    kCCCircularSelectorDecelerationModeLinear,
    kCCCircularSelectorDecelerationModeExponential
} CCCircularSelectorDecelerationMode;

typedef enum{
    kCCCircularSelectorRotationModeDrag             = 1,        // rotate by draging
    kCCCircularSelectorRotationModeTapItem          = 1 << 1,   // bring an item to frony by tapping the item
    kCCCircularSelectorRotationModeTapLeftRight     = 1 << 2    // rotate left/right by one item by tapping left/right space
} CCCircularSelectorRotationMode;

@class ThemeSelectionPage;

@protocol CCCircularSelectorDelagateProtocol

-(void)rotationBegan:(ThemeSelectionPage*)circularSelector;
-(void)rotationEnded:(ThemeSelectionPage*)circularSelector;
-(void)selectionDidChange:(int)index circularSelector:(ThemeSelectionPage*)circularSelector;
-(void)selectionDidDecide:(int)index circularSelector:(ThemeSelectionPage*)circularSelector;

@end


@interface ThemeSelectionPage : CCLayer {
    NSObject<CCCircularSelectorDelagateProtocol> *delegate_;
    CGPoint center_;
    BOOL isDragging_;
    int selectionIndex_;
    NSArray *choices_;
    float angle_;
    float frontScale_, backScale_;
    float radiusX_, radiusY_;
    float rotationSpeedFactor_; // this factor affect the rate between drag distance and rotation angle
    
    CCCircularSelectorRotationMode rotationMode_;
    CGRect touchArea_; // only accept touch within this area, this area is in world space
    
    // inertia related
    float dTheta_;
    float dThetaThreshold_;
    float deceleration_;
    CCCircularSelectorDecelerationMode decelerationMode_;
    // for linear deceleration, deceleration unit is angle per squared second (several hundred)
    // for exponential deceleration, deceleration unit is fraction of angular velocity to be decelerated per second (0 < deceleration <= 1)
    
    float targetAngle_;
    
    NSTimeInterval lastAngleTime_;
    float lastAngle_;
}

+(CCScene *) scene;
+(NSArray *) loadThemePic;

-(ThemeSelectionPage*)initWithChoices:(NSArray*)someChoices;
-(void)positionChoices;
-(float)getAngleForChoice:(int)index;
-(CGPoint)getNormalizedXZCoordinatesForAngle:(float)theta;
-(float)getTFromZ:(float)z;
-(float)getScaleFromT:(float)t;
-(float)getYFromT:(float)t;
-(float)correctAngle:(float)angle;
-(CCNode*)getSelectedNode;
-(float)getAngleForTouchPoint:(CGPoint)point;

-(void)decelerate:(ccTime)dt;
-(void)rotateToTargetAngle:(ccTime)dt;
-(void)stopInertia;

-(void)tapped:(UITouch *)touch;

-(void)rotateToIndex:(int)index;


@property (retain) NSObject<CCCircularSelectorDelagateProtocol> *delegate;
@property (readonly) int selectionIndex;
@property (readonly) NSArray *choices;

@property (readwrite) CCCircularSelectorRotationMode rotationMode;
@property (readwrite) CGRect touchArea;

@property (readwrite) CGPoint center;
@property (readwrite) float frontScale, backScale;
@property (readwrite) float radiusX, radiusY;

@property (assign) float deceleration;
@property (assign) CCCircularSelectorDecelerationMode decelerationMode;

@end
