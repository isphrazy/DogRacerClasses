//
//  FileManger.m
//  GOstrich
//
//  Created by Pingyang He on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

static NSString *general_settings_path;
static NSString *achievementPath;

+(void) setupFiles{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    general_settings_path = [documentsDirectory stringByAppendingPathComponent:@"general_settings.plist"]; 
    
    achievementPath = [documentsDirectory stringByAppendingPathComponent:@"achievementPath.plist"];


    if (![fileManager fileExistsAtPath: general_settings_path]){
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"general_settings" 
                                                           ofType:@"plist"]; 
        
        [fileManager copyItemAtPath:bundle 
                             toPath:general_settings_path 
                              error:&error];
    }
    
    if (![fileManager fileExistsAtPath: achievementPath]){
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"achievementPath" 
                                                           ofType:@"plist"]; 
        
        [fileManager copyItemAtPath:bundle 
                             toPath:achievementPath 
                              error:&error];
    }
    
}

+(NSMutableDictionary *)getGeneralSettings{
    if (general_settings_path == NULL)
        return NULL;
    return [[NSMutableDictionary alloc] initWithContentsOfFile:general_settings_path];
}

+(void)saveGeneralSettings: (NSMutableDictionary *) file{
    [file writeToFile: general_settings_path atomically: YES];
    [file release];
  
}

+(NSMutableDictionary *)getAchievements{
    if (achievementPath == NULL)
        return NULL;
    return [[NSMutableDictionary alloc] initWithContentsOfFile:achievementPath];
}

+(void)saveAchievements: (NSMutableDictionary *) file{
    [file writeToFile: achievementPath atomically: YES];
    [file release];
  
}
@end
