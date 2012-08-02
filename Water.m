#import "Water.h"

#define ANIM_SPEED 0.0025
#define OFFSET_V 10

@implementation Water

+(Water*)init_x:(float)x y:(float)y width:(float)width {
    Water *w = [Water node];
    w.position = ccp(x,y);
    [w init_body:width];
    
    return w;
}

-(void)init_body:(float)width {
    body = [self init_drawbody_ofwidth:width];
    bwidth = width;
    
    body_tex_offset = (CGPoint*) malloc(sizeof(CGPoint)*4);
    offset_ct = 0;
    [self update_body_tex_offset];
    
    active = YES;
}

-(GameObjectReturnCode)update:(Player *)player g:(GameEngineLayer *)g {
    [self update_body_tex_offset];
    if(!active) {
        return GameObjectReturnCode_NONE;
    }
    
    if ([Common hitrect_touch:[self get_hit_rect] b:[player get_hit_rect]]) {
        [player reset_params];
        [self setActive:NO];
        [player add_effect:[HitEffect init_from:[player get_default_params] time:40]];
    }
    
    return GameObjectReturnCode_NONE;
}

-(void)set_active:(BOOL)t_active {
    active = t_active;
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:self.position.x 
                                y1:self.position.y-body.texture.pixelsHigh
                               wid:bwidth 
                               hei:body.texture.pixelsHigh];
}

-(void)update_body_tex_offset {
    body_tex_offset[0] = ccp(body.tex_pts[0].x+offset_ct, body.tex_pts[0].y);
    body_tex_offset[1] = ccp(body.tex_pts[1].x+offset_ct, body.tex_pts[1].y);
    body_tex_offset[2] = ccp(body.tex_pts[2].x+offset_ct, body.tex_pts[2].y);
    body_tex_offset[3] = ccp(body.tex_pts[3].x+offset_ct, body.tex_pts[3].y);
    offset_ct = offset_ct >= 1 ? ANIM_SPEED : offset_ct + ANIM_SPEED;
}

/*0 1
  2 3*/
-(gl_render_obj)init_drawbody_ofwidth:(float)width {
    gl_render_obj o = [Common init_render_obj:[Resource get_tex:TEX_WATER] npts:4];
    
    int twid = o.texture.pixelsWide;
    int thei = o.texture.pixelsHigh;
    
    o.tri_pts[0] = ccp(0,-thei + OFFSET_V);
    o.tri_pts[1] = ccp(width,-thei + OFFSET_V);
    o.tri_pts[2] = ccp(0,0 + OFFSET_V);
    o.tri_pts[3] = ccp(width,0 + OFFSET_V);
    
    o.tex_pts[0] = ccp(0,1);
    o.tex_pts[1] = ccp(o.tri_pts[1].x/twid,1);
    o.tex_pts[2] = ccp(0,0);
    o.tex_pts[3] = ccp(o.tri_pts[3].x/twid,0);
    
    return o;

}

-(void) draw {
    [super draw];
    [self draw_renderobj:body n_vtx:4];
}

-(void)draw_renderobj:(gl_render_obj)obj n_vtx:(int)n_vtx {
    glBindTexture(GL_TEXTURE_2D, obj.texture.name);
	glVertexPointer(2, GL_FLOAT, 0, obj.tri_pts); 
	glTexCoordPointer(2, GL_FLOAT, 0, body_tex_offset);
    
	glDrawArrays(GL_TRIANGLES, 0, 3);
    if (n_vtx == 4)glDrawArrays(GL_TRIANGLES, 1, 3);
}



@end
