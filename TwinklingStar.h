//
//  TwinklingStar.h
//  GOstrich
//
//  Created by Pingyang He on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"

@interface TwinklingStar : CCSprite{
    int maxOpacity;
    int minOpacity;
    int opacitySpeed;
    
    BOOL opacityIncreasing;
}

@property(readwrite, assign) int maxOpacity;
@property(readwrite, assign) int opacitySpeed;
@property(readwrite, assign) int minOpacity;
@property(readwrite, assign) BOOL opacityIncreasing;
    
@end
