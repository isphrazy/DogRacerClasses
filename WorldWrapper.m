//
//  WorldWrapper.m
//  GOstrich
//
//  Created by Pingyang He on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorldWrapper.h"

@implementation WorldWrapper

@synthesize backgroundSprite;
@synthesize circle;
@synthesize cloud;

-(void) dealloc{
    
    [backgroundSprite release];
    [circle release];
    [cloud release];
    
    [super dealloc];
}

@end
