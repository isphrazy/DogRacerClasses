//
//  WorldWrapper.h
//  GOstrich
//
//  Created by Pingyang He on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface WorldWrapper : NSObject{

    CCSprite *backgroundSprite;
    CCMenuItem *circle;
    CCSprite *cloud;
}

@property (readwrite, assign) CCSprite *backgroundSprite;
@property (readwrite, assign) CCMenuItem *circle;
@property (readwrite, assign) CCSprite *cloud;

@end
