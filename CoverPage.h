#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameEngineLayer.h"
#import "CCSlider.h"
#import "FileManager.h"

typedef enum PAGE_MODE{
    FRONT_PAGE,
    SETTING_PAGE,
    SCORE_PAGE
}PageMode;


@interface CoverPage : CCLayer{
    CCMenu *front_menu;
    CCSprite *bg_img;
    CCMenu *setting_menu;
    CCLayerColor *settingLayer;
    
    CCMenuItem *musicButton;
    
    CCMenuItem *soundButtonNormal;
    CCMenuItem *soundButtonDisabled;
    
    CCMenuItem *musicButtonNormal;
    CCMenuItem *musicButtonDisabled;
        
    BOOL soundMute;
    BOOL musicMute;
   
}

+(CCScene *) scene;

@end
