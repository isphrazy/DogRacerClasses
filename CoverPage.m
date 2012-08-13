#import "CoverPage.h"

#define PLAYBUTTON_OFFSET_X 15
#define PLAYBUTTON_OFFSET_Y -15
#define SOUND_TAG 0
#define MUSIC_TAG 1

@implementation CoverPage

-(void) initVars{
    settingLayer = NULL;
    soundMute = NO;
    musicMute = NO;
}

+(CCScene *) scene{
	CCScene *scene = [CCScene node];
    CoverPage *coverPage = [CoverPage node];
    
    [coverPage initVars];
 
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
                                         onclick_target:self selector:@selector(playButtonListener)];
    playbutton.position = ccp( wid/2 - playbutton.rect.size.width/2 + PLAYBUTTON_OFFSET_X,-hei/2 + playbutton.rect.size.height/2 + PLAYBUTTON_OFFSET_Y );
    
    CCMenuItem *settingsbutton = [CoverPage make_button_img:@"Front-Page_option.png"
                                                 imgsel:@"Front-Page_option-withlight.png" 
                                         onclick_target:self selector:@selector(settingsButtonListener)];
    settingsbutton.position = ccp(-wid/2+settingsbutton.rect.size.width/2,-hei/2 + settingsbutton.rect.size.height/2);
    
    CCMenuItem *scoresbutton = [CoverPage make_button_img:@"Front-Page_scores.png"
                                                     imgsel:@"Front-Page_scores-withlight.png" 
                                             onclick_target:self selector:@selector(scoresButtonListener)];
    scoresbutton.position = ccp(-wid/2+scoresbutton.rect.size.width/2,-hei/2 + scoresbutton.rect.size.height/2 + settingsbutton.rect.size.height );
    
    CCMenuItem *logo = [CCMenuItemImage itemFromNormalImage:@"Front-Page_title.png" selectedImage:@"Front-Page_title.png"];
    logo.position = ccp(0,hei/2 - logo.rect.size.height/2);
    
    front_menu = [CCMenu menuWithItems:playbutton,settingsbutton,scoresbutton,logo, nil];
    [self addChild:front_menu];
}

-(void)playButtonListener {
    [[[CCDirector sharedDirector] runningScene] removeAllChildrenWithCleanup:YES];
    [[CCDirector sharedDirector] replaceScene: [WorldSelectionPage scene]];
}

-(void) setSettingPage{
    
    if(settingLayer == NULL){
        CGSize s = [[UIScreen mainScreen] bounds].size;
        settingLayer = [CCLayerColor layerWithColor:ccc4(0,0,0,100) width:s.height height:s.width];
        settingLayer.anchorPoint = ccp(0,0);
        
        
        //add return button
        CCMenuItem *returnButton = [CoverPage make_button_img:@"Option-Page_back.png"
                                                       imgsel:@"Option-Page_back_withlight.png" 
                                               onclick_target:self selector:@selector(settingReturn)];
        returnButton.position = ccp(8, 271);
        returnButton.anchorPoint = ccp(0, 0);
            
        //add title

        CCMenuItem *settingTitle = [CCMenuItemImage itemFromNormalImage:@"Option-Page_title.png" 
                                                          selectedImage:@"Option-Page_title.png"];
        settingTitle.position = ccp(145, 227);
        settingTitle.anchorPoint = ccp(0, 0);                                                                                    
             
        //add sound button
        
        soundButtonNormal = [CoverPage make_button_img: @"Option-Page_sound.png" 
                                                imgsel:@"Option-Page_sound.png"
                                        onclick_target:self 
                                              selector:@selector(soundAction)];
        
        soundButtonDisabled = [CoverPage make_button_img: @"Option-Page_No-sound.png" 
                                                  imgsel:@"Option-Page_No-sound.png"
                                          onclick_target:self 
                                                selector:@selector(soundAction)];
        
        //soundButton = soundButtonNormal;
        soundButtonNormal.position = ccp(50, 140);
        soundButtonNormal.anchorPoint = ccp(0, 0);     
        
        soundButtonDisabled.position = ccp(50, 140);
        soundButtonDisabled.anchorPoint = ccp(0, 0); 
        
        if(soundMute)
            soundButtonNormal.visible = NO;
        else
            soundButtonDisabled.visible = NO;
                                            
        //add sound scroll bar
        CCSlider *soundSlider = [CCSlider sliderWithBackgroundFile:@"Option-Page_sliderbar.png" 
                                                         thumbFile:@"Option-Page_slider.png"];
        soundSlider.tag = SOUND_TAG;
        
        soundSlider.anchorPoint = ccp(0, 0);
        soundSlider.position = ccp(120, 158);
        [settingLayer addChild:soundSlider];
        
        //add music button
        musicButtonNormal = [CoverPage make_button_img:@"Option-Page_music.png"
                                                imgsel:@"Option-Page_music.png" 
                                        onclick_target:self 
                                              selector:@selector(musicAction)];
        musicButtonNormal.position = ccp(50, 65);
        musicButtonNormal.anchorPoint = ccp(0, 0);
        
        musicButtonDisabled = [CoverPage make_button_img:@"Option-Page_No-music.png"
                                                  imgsel:@"Option-Page_No-music.png" 
                                          onclick_target:self 
                                                selector:@selector(musicAction)];
        musicButtonDisabled.position = ccp(50, 65);
        musicButtonDisabled.anchorPoint = ccp(0, 0);
        
        if(musicMute)
            musicButtonNormal.visible = NO;
        else
            musicButtonDisabled.visible = NO;
                                                  
       
        //add music scroll bar
        CCSlider *musicSlider = [CCSlider sliderWithBackgroundFile:@"Option-Page_sliderbar.png" 
                                                         thumbFile:@"Option-Page_slider.png"];
        musicSlider.tag = MUSIC_TAG;
      
        musicSlider.anchorPoint = ccp(0, 0);
        musicSlider.position = ccp(120, 78);
        [settingLayer addChild:musicSlider];
        
        setting_menu = [CCMenu menuWithItems:returnButton, settingTitle, soundButtonNormal, soundButtonDisabled, musicButtonNormal, musicButtonDisabled, nil];
        setting_menu.position = ccp(0, 0);
        setting_menu.anchorPoint = ccp(0, 0);
        [settingLayer addChild:setting_menu];
        [[[CCDirector sharedDirector] runningScene] addChild:settingLayer];
    }else{
        settingLayer.visible = YES;
    }

}

-(void) soundAction{
    soundMute = !soundMute;
    if(soundMute){
        soundButtonDisabled.visible = YES;
        soundButtonNormal.visible = NO;
    }else{
        soundButtonNormal.visible = YES;
        soundButtonDisabled.visible = NO;
    }
}

-(void) musicAction{
    musicMute = !musicMute;
    if(musicMute){
        musicButtonDisabled.visible = YES;
        musicButtonNormal.visible = NO;
    }else{
        musicButtonNormal.visible = YES;
        musicButtonDisabled.visible = NO;
    }
}

-(void) settingReturn{
    settingLayer.visible = NO;
    front_menu.visible = YES;
}

-(void)settingsButtonListener {
    
    front_menu.visible = FALSE;
    [self setSettingPage];
}



-(void)scoresButtonListener {
}

-(void)dealloc{
    [settingLayer removeAllChildrenWithCleanup:NO];
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
