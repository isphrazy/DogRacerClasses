#import "Player.h"
#import "PlayerEffectParams.h"
#import "GameEngineLayer.h"

#define IMGWID 64
#define IMGHEI 58
#define IMG_OFFSET_X -31
#define IMG_OFFSET_Y -3

#define DEFAULT_GRAVITY -0.5
#define DEFAULT_MIN_SPEED 6
#define DEFAULT_ACCEL_TO_MIN 5

#define MIN_SPEED_MAX 14
#define LIMITSPD_INCR 2
#define ACCEL_INCR 0.01

#define HITBOX_RESCALE 0.7


@implementation Player
@synthesize vx,vy;
@synthesize player_img;
@synthesize current_island;
@synthesize up_vec;
@synthesize start_pt;

//todo -- dealloc the plist dict, animations
- (id)init
{
    self = [super init];
    if (self) {
        [self reset_params];
    }
    return self;
}

+(Player*)init_at:(CGPoint)pt {
	Player *new_player = [Player node];
	CCSprite *player_img = [CCSprite node];
    new_player.player_img = player_img;
    
    new_player.current_island = NULL;
	player_img.anchorPoint = ccp(0,0);
	player_img.position = ccp(IMG_OFFSET_X,IMG_OFFSET_Y);
	
    new_player.up_vec = [Vec3D init_x:0 y:1 z:0];
	[new_player addChild:player_img];
	
    [new_player init_anim];
	
    new_player.start_pt = pt;
	new_player.anchorPoint = ccp(0,0);
    new_player.position = new_player.start_pt;
	return new_player;
}

- (void)setOpacity:(GLubyte)opacity {
	[super setOpacity:opacity];
    
	for(CCSprite *sprite in [self children]) {
        
		sprite.opacity = opacity;
	}
}

-(void)init_anim {
    
    _RUN_ANIM_SLOW = [self init_run_anim_speed:0.1];
    _RUN_ANIM_MED = [self init_run_anim_speed:0.075];
    _RUN_ANIM_FAST = [self init_run_anim_speed:0.05];
    _RUN_ANIM_NONE = [self init_run_anim_speed:1000];
    _ROCKET_ANIM = [self init_rocket_anim_speed:0.1];
    _CAPE_ANIM = [self init_cape_anim_speed:0.1];
    _HIT_ANIM = [self init_hit_anim_speed:0.1];
    
    [self start_anim:_RUN_ANIM_NONE];
}

-(id)init_hit_anim_speed:(float)speed {
    CCTexture2D *texture = [Resource get_tex:TEX_DOG_RUN_1];
    NSMutableArray *animFrames = [NSMutableArray array];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[Player spritesheet_rect_tar:@"hit_0"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[Player spritesheet_rect_tar:@"hit_1"]]];
    
    return [self make_anim_frames:animFrames speed:speed];
}

-(id)init_run_anim_speed:(float)speed {
	CCTexture2D *texture = [Resource get_aa_tex:TEX_DOG_RUN_1];
	NSMutableArray *animFrames = [NSMutableArray array];
	
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[Player spritesheet_rect_tar:@"run_0"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[Player spritesheet_rect_tar:@"run_1"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[Player spritesheet_rect_tar:@"run_2"]]];
   
	return [self make_anim_frames:animFrames speed:speed];
}

-(id)init_rocket_anim_speed:(float)speed {
	CCTexture2D *texture = [Resource get_aa_tex:TEX_DOG_RUN_1];
	NSMutableArray *animFrames = [NSMutableArray array];
    
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[Player spritesheet_rect_tar:@"rocket_0"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[Player spritesheet_rect_tar:@"rocket_1"]]];
	
    return [self make_anim_frames:animFrames speed:speed];
}

-(id)init_cape_anim_speed:(float)speed {
	CCTexture2D *texture = [Resource get_aa_tex:TEX_DOG_RUN_1];
	NSMutableArray *animFrames = [NSMutableArray array];
    
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[Player spritesheet_rect_tar:@"cape_0"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[Player spritesheet_rect_tar:@"cape_1"]]];
	
    return [self make_anim_frames:animFrames speed:speed];
}



-(id)make_anim_frames:(NSMutableArray*)animFrames speed:(float)speed {
	id animate = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:animFrames delay:speed] restoreOriginalFrame:YES];
    id m = [CCRepeatForever actionWithAction:animate];
    
    [m retain];
	return m;
}


#define DOG_1_SS_FILENAME @"dog1ss"
NSDictionary *dog_1_ss_plist_dict;

+(CGRect)spritesheet_rect_tar:(NSString*)tar {
    NSDictionary *dict;
    if (dog_1_ss_plist_dict == NULL) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:DOG_1_SS_FILENAME ofType:@"plist"];
        dog_1_ss_plist_dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    dict = dog_1_ss_plist_dict;
    
    NSDictionary *frames_dict = [dict objectForKey:@"frames"];
    NSDictionary *obj_info = [frames_dict objectForKey:tar];
    NSString *txt = [obj_info objectForKey:@"textureRect"];
    CGRect r = CGRectFromString(txt);
    return r;
}


-(void)start_anim:(id)anim {
    if (current_anim == anim) {
        return;
    } else if (current_anim != NULL) {
        [player_img stopAction:current_anim];
    }
    [player_img runAction:anim];
    current_anim = anim;
}



-(PlayerEffectParams*) get_current_params {
    if (temp_params != NULL) {
        return temp_params;
    } else {
        return current_params;
    }
}

-(PlayerEffectParams*) get_default_params {
    return current_params;
}

-(void) reset {
    position_ = start_pt;
    current_island = NULL;
    [up_vec dealloc];
    up_vec = [Vec3D init_x:0 y:1 z:0];
    vx = 0;
    vy = 0;
    rotation_ = 0;
    [self reset_params];
}

-(void) reset_params {
    if (temp_params != NULL) {
        [temp_params dealloc];
        temp_params = NULL;
    }
    if (current_params != NULL) {
        [current_params dealloc];
        current_params = NULL;
    }
    current_params = [[PlayerEffectParams alloc] init];
    current_params.cur_gravity = DEFAULT_GRAVITY;
    current_params.cur_accel_to_min = DEFAULT_ACCEL_TO_MIN;
    current_params.cur_limit_speed = DEFAULT_MIN_SPEED + LIMITSPD_INCR;
    current_params.cur_min_speed = DEFAULT_MIN_SPEED;
    current_params.cur_airjump_count = 1;
    current_params.time_left = -1;
}

-(void)add_effect:(PlayerEffectParams*)effect {
    if (temp_params != NULL) {
        [temp_params dealloc];
        temp_params = NULL;
    }
    temp_params = effect;
}

-(void) update:(GameEngineLayer*)g {
    float vel = sqrtf(powf(vx,2)+powf(vy,2));
    float tar = current_params.cur_min_speed;
    
    if (current_island == NULL) {
        Vec3D *dv = [Vec3D init_x:vx y:vy z:0];
        [dv normalize];
        [dv dealloc];
        
        float rot = -[Common rad_to_deg:[dv get_angle_in_rad]];
        float sig = [Common sig:rot];
        rot = sig*sqrtf(ABS(rot));
        //rot *=0.4;
        rotation_ = rot;
    }
    
    player_anim_mode cur_anim_mode = [[self get_current_params] get_anim];
    if (cur_anim_mode == player_anim_mode_RUN) {
        if (current_island == NULL) {
            [self start_anim:_RUN_ANIM_NONE];
        } else {
            if (vel > 13) {
                [self start_anim:_RUN_ANIM_FAST];
            } else if (vel > 10) {
                [self start_anim:_RUN_ANIM_MED];
            } else {
                [self start_anim:_RUN_ANIM_SLOW];
            }
        }
    } else if (cur_anim_mode == player_anim_mode_CAPE) {
        [self start_anim:_CAPE_ANIM];
    } else if (cur_anim_mode == player_anim_mode_ROCKET) {
        [self start_anim:_ROCKET_ANIM];
    } else if (cur_anim_mode == player_anim_mode_HIT) {
        [self start_anim:_HIT_ANIM];
    }
    
    if (temp_params != NULL) {
        [temp_params update:self g:g];
        //NSLog(@"%@",[temp_params info]);
        [temp_params decrement_timer];
        
        if (temp_params.time_left <= 0) {
            [temp_params effect_end:self g:g];
            if (temp_params.time_left <= 0) {
                [temp_params release];
                temp_params = NULL;
            }
        }
    } else {
        if (current_island != NULL) {
            if (current_params.cur_min_speed < MIN_SPEED_MAX && (vel >= tar || ABS(tar-vel) < tar * 0.4)  ) {
                current_params.cur_min_speed += ACCEL_INCR;
            } else if (current_params.cur_limit_speed > DEFAULT_MIN_SPEED && current_params.cur_min_speed*0.9 > DEFAULT_MIN_SPEED && (vel < tar*0.5)) {
                current_params.cur_min_speed *= 0.9;
            }
            current_params.cur_limit_speed = current_params.cur_min_speed + LIMITSPD_INCR;
        }
    }
    refresh_hitrect = YES;
}


BOOL refresh_hitrect = YES;
HitRect cached_rect;

-(HitRect) get_hit_rect {
    if (refresh_hitrect == NO) {
        return cached_rect;
    }
    
    Vec3D *v = [Vec3D init_x:up_vec.x y:up_vec.y z:0];
    Vec3D *h = [v crossWith:[Vec3D Z_VEC]];
    float x = self.position.x;
    float y = self.position.y;
    [h normalize];
    [v normalize];
    [h scale:IMGWID/2 * HITBOX_RESCALE];
    [v scale:IMGHEI * HITBOX_RESCALE];
    CGPoint *pts = (CGPoint*) malloc(sizeof(CGPoint)*4);
    pts[0] = ccp(x-h.x , y-h.y);
    pts[1] = ccp(x+h.x , y+h.y);
    pts[2] = ccp(x-h.x+v.x , y-h.y+v.y);
    pts[3] = ccp(x+h.x+v.x , y+h.y+v.y);
    
    float x1 = pts[0].x;
    float y1 = pts[0].y;
    float x2 = pts[0].x;
    float y2 = pts[0].y;

    for (int i = 0; i < 4; i++) {
        x1 = MIN(pts[i].x,x1);
        y1 = MIN(pts[i].y,y1);
        x2 = MAX(pts[i].x,x2);
        y2 = MAX(pts[i].y,y2);
    }
    free(pts);
    [v dealloc];
    [h dealloc];
    
    refresh_hitrect = NO;
    cached_rect = [Common hitrect_cons_x1:x1 y1:y1 x2:x2 y2:y2];
    return cached_rect;
}

-(void)cleanup_anims {
    [self stopAction:current_anim]; 
    
    [_RUN_ANIM_FAST dealloc];
    [_RUN_ANIM_MED dealloc];
    [_RUN_ANIM_NONE dealloc];
    [_RUN_ANIM_SLOW dealloc];
    
    [_ROCKET_ANIM dealloc];
    [_CAPE_ANIM dealloc];
    [_HIT_ANIM dealloc];
    
    
    [self removeAllChildrenWithCleanup:NO];
}

@end
