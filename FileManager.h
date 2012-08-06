//
//  FileManger.h
//  GOstrich
//
//  Created by Pingyang He on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject{
    
}

//call this method when game starts
+(void) setupFiles;

//get the file
+(NSMutableDictionary *)getGeneralSettings;
+(void)saveGeneralSettings: (NSMutableDictionary *) file;
+(NSMutableDictionary *)getAchievements;
+(void)saveAchievements: (NSMutableDictionary *) file;


@end
