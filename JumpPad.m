#import "JumpPad.h"
#import "Player.h"

#define JUMP_POWER 20
#define RECHARGE_TIME 15

@implementation JumpPad

+(JumpPad*)init_x:(float)x y:(float)y islands:(NSMutableArray*)islands{
    JumpPad *j = [JumpPad node];
    j.position = ccp(x,y);
    [j initialize_anim];
    [j attach_toisland:islands];
    [j setActive:YES];
    return j;
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:[self position].x-10 y1:[self position].y-10 wid:20 hei:20];
}

-(GameObjectReturnCode)update:(Player*)player g:(GameEngineLayer *)g{
    if (recharge_ct >= 0) {
        recharge_ct--;
        if (recharge_ct == 0) {
            [self set_active:YES];
        }
    }
    if(!active) {
        return GameObjectReturnCode_NONE;
    }
    
    if ([Common hitrect_touch:[self get_hit_rect] b:[player get_hit_rect]]) {
        [self set_active:NO];
        recharge_ct = RECHARGE_TIME;
        [self boostjump:player];
    }
    
    return GameObjectReturnCode_NONE;
}

-(void)boostjump:(Player*)player {
    float mov_speed = sqrtf(powf(player.vx, 2) + powf(player.vy, 2));
    
    Vec3D *tangent = [[Vec3D Z_VEC] crossWith:normal_vec];
    Vec3D *cur_tangent_vec = [[Vec3D Z_VEC] crossWith:normal_vec];
    Vec3D *up = [Vec3D init_x:normal_vec.x y:normal_vec.y z:0];
    [tangent normalize];
    [up normalize];
    
    if (player.current_island != NULL) {
        [tangent scale:-player.current_island.ndir];
        player.current_island = NULL;
    }
    
    [tangent scale:mov_speed];
    [up scale:JUMP_POWER];
    
    Vec3D *combined = [up add:tangent];
    
    Vec3D *calc_up = [[Vec3D Z_VEC] crossWith:cur_tangent_vec];
    [calc_up scale:2];
    player.position = [calc_up transform_pt:player.position];
    
    player.vx = combined.x;
    player.vy = combined.y;
    
    
    [calc_up dealloc];
    [up dealloc];
    [combined dealloc];
    [tangent dealloc];
    [cur_tangent_vec dealloc];
}

-(int)get_render_ord {
    return [GameRenderImplementation GET_RENDER_ISLAND_ORD];
}

-(void)initialize_anim {
    anim = [self init_anim_ofspeed:0.3];
    [self runAction:anim];
}

-(id)init_anim_ofspeed:(float)speed {
	CCTexture2D *texture = [Resource get_aa_tex:TEX_JUMPPAD];
	NSMutableArray *animFrames = [NSMutableArray array];
    
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[JumpPad spritesheet_rect_tar:@"jumppad1"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[JumpPad spritesheet_rect_tar:@"jumppad2"]]];
	[animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[JumpPad spritesheet_rect_tar:@"jumppad3"]]];
    
    return [JumpPad make_anim_frames:animFrames speed:speed];
}



+(id)make_anim_frames:(NSMutableArray*)animFrames speed:(float)speed {
	id animate = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:animFrames delay:speed] restoreOriginalFrame:YES];
    id m = [CCRepeatForever actionWithAction:animate];
    
    [m retain];    
	return m;
}


#define JUMPPAD_SS_FILENAME @"jumppadss"
NSDictionary *jumppad_ss_plist_dict;

+(CGRect)spritesheet_rect_tar:(NSString*)tar {
    NSDictionary *dict;
    if (jumppad_ss_plist_dict == NULL) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:JUMPPAD_SS_FILENAME ofType:@"plist"];
        jumppad_ss_plist_dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    dict = jumppad_ss_plist_dict;
    
    NSDictionary *frames_dict = [dict objectForKey:@"frames"];
    NSDictionary *obj_info = [frames_dict objectForKey:tar];
    NSString *txt = [obj_info objectForKey:@"textureRect"];
    CGRect r = CGRectFromString(txt);
    return r;
}

-(void)attach_toisland:(NSMutableArray*)islands {
    Island *i = [self get_connecting_island:islands];
    
    if (i != NULL) {
        Vec3D *tangent_vec = [i get_tangent_vec];
        [tangent_vec scale:[i ndir]];
        float tar_rad = -[tangent_vec get_angle_in_rad];
        float tar_deg = [Common rad_to_deg:tar_rad];
        rotation_ = tar_deg;
        
        normal_vec = [[Vec3D Z_VEC] crossWith:tangent_vec];
        [normal_vec normalize];
        [normal_vec retain];
        
        [tangent_vec dealloc];
    } else {
        normal_vec = [Vec3D init_x:0 y:1 z:0];
        [normal_vec retain];
    }
}

-(void)set_active:(BOOL)t_active {
    if (t_active) {
        [self setOpacity:255];
    } else {
        [self setOpacity:0];
    }
    active = t_active;
}

- (void)setOpacity:(GLubyte)opacity {
	[super setOpacity:opacity];
	for(CCSprite *sprite in [self children]) {
		sprite.opacity = opacity;
	}
}

@end
