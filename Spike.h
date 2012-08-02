#import "GameObject.h"
#import "HitEffect.h"

@interface Spike : GameObject {
    gl_render_obj body;
}

+(Spike*)init_x:(float)posx y:(float)posy islands:(NSMutableArray*)islands;

@end
