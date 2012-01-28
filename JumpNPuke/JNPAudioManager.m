//
//  JNPAudioManager.m
//  PawAppsExample_SimpleAudioEngine
//
//  Created by Vincent on 27/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPAudioManager.h"
#import "SimpleAudioEngine.h"
#import "CCNode.h"

@implementation JNPAudioManager
@synthesize counter;
@synthesize nextMusicStress;

-(id) init
{
	if( (self=[super init])) {
        self.counter = 0;
        self.nextMusicStress = 0;

        [self schedule:@selector(backgroundMusicTick:) interval:0.5];
    }
   	return self;
}

// playMusic
-(void) playMusic:(int)stress {
    switch (stress) {
        case 1:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Tribal.mp3" loop:YES];
            break;
            
        case 2:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Tribal_2.mp3" loop:YES];
            break;

        default:
        case 0:
            break;
    }
}

// playNextMusic
-(void) playMusicNext:(int)stress {
    self.nextMusicStress = stress;
}

// play
-(void) play:(int)soundType {
    switch (soundType) {
        case jnpSndDummy:
            [[SimpleAudioEngine sharedEngine] playEffect:@"gameboy-startup.wav"];
            break;
            
        case jnpSndJump:
            [[SimpleAudioEngine sharedEngine] playEffect:@"jump.mp3"];
            break;
            
        case jnpSndDie:
            [[SimpleAudioEngine sharedEngine] playEffect:@"die.mp3"];
            break;
            
        default:
            break;
    }
}

// preload files
-(void) preload {
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"calm.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Tribal.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Tribal_2.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"music1.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"music2.mp3"];
}

// called every 0.5 sec
-(void) backgroundMusicTick:(ccTime)time {
    self.counter = self.counter + 1;
    
    if (self.counter % 12 == 0 && self.nextMusicStress != 0) {
        NSLog(@"time has come to play next music with stress %d", self.nextMusicStress);
        int stress = self.nextMusicStress;
        self.nextMusicStress = 0;
        [self playMusic:stress];
    }
}


@end
