#import <Foundation/Foundation.h>

@class GameRenderState;
@interface GameRenderState : NSObject {
    float cx,cy,cz,ex,ey,ez;
}


@property(readwrite,assign) float cx,cy,cz,ex,ey,ez;


@end
