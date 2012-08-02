#import "GameControlImplementation.h"

#define JUMP_HOLD_TIME 15
#define JUMP_POWER 8.5

@implementation GameControlImplementation

+(void)control_update_player:(Player*)player 
                       state:(GameControlState*)state 
                     islands:(NSMutableArray*)islands 
                     objects:(NSMutableArray*)game_objects {
    
    float JUMP_FLOAT_SCALE = 1;
    
    if (player.current_island != NULL) {
        [[player get_current_params] add_airjump_count];
    }
    
    if (state.queue_jump == YES) {
        if (player.current_island != NULL) {
            [GameControlImplementation player_jump_from_island:player state:state];
            state.jump_hold_counter = JUMP_HOLD_TIME;
        } else if ([player get_current_params].cur_airjump_count > 0) {
            [GameControlImplementation player_double_jump:player state:state];
            state.jump_hold_counter = JUMP_HOLD_TIME;
            [[player get_current_params] decr_airjump_count];
        }
    }
    state.queue_jump = NO;
    
    
    if (state.is_touch_down && state.jump_hold_counter > 0) {
        state.jump_hold_counter--;
        float pct_left = ((float)state.jump_hold_counter)/((float)JUMP_HOLD_TIME);
        float scale = JUMP_FLOAT_SCALE;
        player.vx += player.up_vec.x *pct_left*scale;
        player.vy += player.up_vec.y *pct_left*scale;
    } else {
        state.jump_hold_counter = 0;
    }
}

+(void)player_double_jump:(Player*)player state:(GameControlState*)state {    
    player.vx += player.up_vec.x*JUMP_POWER;
    player.vy = player.up_vec.y*JUMP_POWER;
}



+(void)player_jump_from_island:(Player*)player state:(GameControlState*)state {
    float mov_speed = sqrtf(powf(player.vx, 2) + powf(player.vy, 2));
    
    Vec3D *tangent = [player.current_island get_tangent_vec];
    Vec3D *up = [[Vec3D Z_VEC] crossWith:tangent];
    [tangent normalize];
    [up normalize];
    if (player.current_island.ndir == -1) {
        [up scale:-1];
    }
    
    [tangent scale:mov_speed];
    [up scale:JUMP_POWER];
    
    Vec3D *combined = [up add:tangent];
    Vec3D *cur_tangent_vec = [player.current_island get_tangent_vec];
    Vec3D *calc_up = [[Vec3D Z_VEC] crossWith:cur_tangent_vec];
    [calc_up scale:2];
    player.position = [calc_up transform_pt:player.position];
    
    player.vx = combined.x;
    player.vy = combined.y;
    player.current_island = NULL;
    
    [calc_up dealloc];
    [up dealloc];
    [combined dealloc];
    [tangent dealloc];
    [cur_tangent_vec dealloc];
    
}


+(void)touch_begin:(GameControlState*)state at:(CGPoint)pt {
    [state start_touch:pt];
    state.queue_jump = YES;
}

+(void)touch_end:(GameControlState*)state at:(CGPoint)pt {
    [state end_touch];
}

@end
