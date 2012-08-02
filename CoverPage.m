#import "CoverPage.h"

#define PLAYBUTTON_OFFSET_X 15
#define PLAYBUTTON_OFFSET_Y -15

@implementation CoverPage

+(CCScene *) scene{
	CCScene *scene = [CCScene node];
    CoverPage *coverPage = [CoverPage node];
    [coverPage init_bg];
    [coverPage init_img];
    [scene addChild:coverPage];
    
    return scene;
}

-(void) init_bg {
    bg_img = [CCSprite spriteWithFile:@"Front-Page_background.png"];
    bg_img.position = ccp([UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width/2);
    [self addChild:bg_img];
}

-(void) init_img {
    float hei = [UIScreen mainScreen].bounds.size.width;
    float wid = [UIScreen mainScreen].bounds.size.height;
    
    CCMenuItem *playbutton = [CoverPage make_button_img:@"Front-Page_PLAY.png"
                                                imgsel:@"Front-Page_PLAY-withLight.png" 
                                        onclick_target:self selector:@selector(playbutton_action)];
    playbutton.position = ccp( wid/2 - playbutton.rect.size.width/2 + PLAYBUTTON_OFFSET_X,-hei/2 + playbutton.rect.size.height/2 + PLAYBUTTON_OFFSET_Y );
    
    CCMenuItem *settingsbutton = [CoverPage make_button_img:@"Front-Page_option.png"
                                                 imgsel:@"Front-Page_option-withlight.png" 
                                         onclick_target:self selector:@selector(settingsbutton_action)];
    settingsbutton.position = ccp(-wid/2+settingsbutton.rect.size.width/2,-hei/2 + settingsbutton.rect.size.height/2);
    
    CCMenuItem *scoresbutton = [CoverPage make_button_img:@"Front-Page_scores.png"
                                                     imgsel:@"Front-Page_scores-withlight.png" 
                                             onclick_target:self selector:@selector(scoresbutton_action)];
    scoresbutton.position = ccp(-wid/2+scoresbutton.rect.size.width/2,-hei/2 + scoresbutton.rect.size.height/2 + settingsbutton.rect.size.height );
    
    CCMenuItem *logo = [CCMenuItemImage itemFromNormalImage:@"Front-Page_title.png" selectedImage:@"Front-Page_title.png"];
    logo.position = ccp(0,hei/2 - logo.rect.size.height/2);
    
    front_menu = [CCMenu menuWithItems:playbutton,settingsbutton,scoresbutton,logo, nil];
    [self addChild:front_menu];
}

-(void)playbutton_action {
    [[[CCDirector sharedDirector] runningScene] removeAllChildrenWithCleanup:YES];
    [[CCDirector sharedDirector] replaceScene: [GameEngineLayer scene_with:@"test"]];
}

-(void)settingsbutton_action {
    NSLog(@"settingsbutton");
    
    
    
}

-(void)scoresbutton_action {
    NSLog(@"scoresbutton");
}

-(void)dealloc{
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

+(CCMenuItem*)make_button_img:(NSString*)imgfile imgsel:(NSString*)imgselfile onclick_target:(NSObject*)tar selector:(SEL)sel {
    CCSprite *img = [CCSprite spriteWithFile:imgfile];
    CCSprite *img_zoom = [CCSprite spriteWithFile:imgselfile];
    [CoverPage set_zoom_pos_align:img zoomed:img_zoom scale:1.2];
    return [CCMenuItemImage itemFromNormalSprite:img selectedSprite:img_zoom target:tar selector:sel];
    
}

+(void)set_zoom_pos_align:(CCSprite*)normal zoomed:(CCSprite*)zoomed scale:(float)scale {
    zoomed.scale = scale;
    zoomed.position = ccp((-[zoomed contentSize].width * zoomed.scale + [zoomed contentSize].width)/2
                          ,(-[zoomed contentSize].height * zoomed.scale + [zoomed contentSize].height)/2);
}


@end
