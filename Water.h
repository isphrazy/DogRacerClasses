#import "GameObject.h"
#import "HitEffect.h"
#import "GameRenderImplementation.h"

@interface Water : GameObject {
    gl_render_obj body;
    
    CGPoint* body_tex_offset;
    float bwidth, offset_ct;
}

+(Water*)init_x:(float)x y:(float)y width:(float)width;

@end
