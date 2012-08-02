#import "GameObject.h"

@interface JumpPad : GameObject {
    id anim;
    Vec3D* normal_vec;
    int recharge_ct;
}

+(JumpPad*)init_x:(float)x y:(float)y islands:(NSMutableArray*)islands;

@end
