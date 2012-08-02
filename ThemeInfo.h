#import <Foundation/Foundation.h>

@interface ThemeInfo : NSObject{
    NSString *pic_name, *map_name, *map_type;
}

@property (readwrite, assign) NSString *pic_name, *map_name, *map_type;

@end
