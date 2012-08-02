#import "Island.h"


@implementation Island

static float NO_VAL = -99999.0;

+(float) NO_VALUE {
    return NO_VAL;
}

@synthesize startX, startY, endX, endY, fill_hei, ndir, t_min, t_max;
@synthesize next;
@synthesize can_land,has_prev;

+(int) link_islands:(NSMutableArray*)islands {
    int ct = 0;
    for(Island *i in islands) {
        for(Island *j in islands) {
            if ([Common pt_fuzzy_eq:ccp(i.endX,i.endY) b:ccp(j.startX,j.startY)]) {
                i.next = j;
                j.has_prev = YES;
                ct++;
                break;
            }
        }
    }
    for (Island *i in islands) {
        [i link_finish];
    }
    return ct;
}

-(void)link_finish {
}

-(Vec3D*)get_normal_vec {
    if (normal_vec == NULL) {
        Vec3D *line_vec = [Vec3D init_x:endX-startX y:endY-startY z:0];
        normal_vec = [[Vec3D Z_VEC] crossWith:line_vec];
        [normal_vec normalize];
        [line_vec dealloc];
        [normal_vec scale:ndir];
    }
    return normal_vec;
}

-(line_seg)get_line_seg {
    return [Common cons_line_seg_a:ccp(startX,startY) b:ccp(endX,endY)];
}

-(Vec3D*)get_tangent_vec {
    Vec3D *v = [Vec3D init_x:endX-startX y:endY-startY z:0];
    [v normalize];
    return v;
}

-(float)get_t_given_position:(CGPoint)position {
    float dx = powf(position.x - startX, 2);
    float dy = powf(position.y - startY, 2);
    float f = sqrtf( dx+dy );
    return f;
}

-(CGPoint)get_position_given_t:(float)t {
    if (t > t_max || t < t_min) {
        return ccp([Island NO_VALUE],[Island NO_VALUE]);
    } else {
        float frac = t/t_max;
        Vec3D *dir_vec = [Vec3D init_x:endX-startX y:endY-startY z:0];
        [dir_vec scale:frac];
        CGPoint pos = ccp(startX+dir_vec.x,startY+dir_vec.y);
        [dir_vec dealloc];
        return pos;
    }
}

-(void)cleanup_anims {
}

@end
