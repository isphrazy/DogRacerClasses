//
//  FileProperty.h
//  GOstrich
//
//  Created by Pingyang He on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileProperty : NSObject{
    NSString *fileName;
    NSString *path;
}

@property(readwrite, assign) NSString *fileName;
@property(readwrite, assign) NSString *path;

@end
