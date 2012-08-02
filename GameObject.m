
#import "GameObject.h"

@implementation GameObject

@synthesize active;
@synthesize img;

-(GameObjectReturnCode)update:(Player*)player g:(GameEngineLayer *)g {
    return GameObjectReturnCode_NONE;
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:0 y1:0 x2:0 y2:0];
}

-(void)set_active:(BOOL)t_active {
    return;
}

-(int)get_render_ord {
    return [GameRenderImplementation GET_RENDER_GAMEOBJ_ORD];
}

-(Island*)get_connecting_island:(NSMutableArray*)islands {
    CGPoint p = [self position];
    line_seg vert = [Common cons_line_seg_a:ccp(p.x,p.y-10) b:ccp(p.x,p.y+10)];
    line_seg horiz = [Common cons_line_seg_a:ccp(p.x-10,p.y) b:ccp(p.x+10,p.y)];
    
    for (Island* i in islands) {
        line_seg iseg = [i get_line_seg];
        CGPoint vert_ins = [Common line_seg_intersection_a:vert b:iseg];
        CGPoint horiz_ins = [Common line_seg_intersection_a:horiz b:iseg];
        if ((vert_ins.x != [Island NO_VALUE] && vert_ins.y != [Island NO_VALUE]) ||
            (horiz_ins.x != [Island NO_VALUE] && horiz_ins.y != [Island NO_VALUE])){
            
            return i;
            
        }
    }
    
    return NULL;
}



@end
