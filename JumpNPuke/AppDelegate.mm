//
//  AppDelegate.mm
//  Test22
//
//  Created by Vincent on 28/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"


@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

@synthesize queue;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	
	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
	
	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	director_.wantsFullScreenLayout = YES;
	
	// Display FSP and SPF
	[director_ setDisplayStats:YES];
	
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
	
	// attach the openglView to the director
	[director_ setView:glView];
	
	// for rotation and other messages
	[director_ setDelegate:self];
	
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
	//	[director setProjection:kCCDirectorProjection3D];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	// set the Navigation Controller as the root view controller
	//	[window_ setRootViewController:rootViewController_];
	[window_ addSubview:navController_.view];
	
	// make main window visible
	[window_ makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// When in iPad / RetinaDisplay mode, CCFileUtils will append the "-ipad" / "-hd" to all loaded files
	// If the -ipad  / -hdfile is not found, it will load the non-suffixed version
	[CCFileUtils setiPadSuffix:@"-ipad"];			// Default on iPad is "" (empty string)
	[CCFileUtils setRetinaDisplaySuffix:@"-hd"];	// Default on RetinaDisplay is "-hd"
	
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	//Initialize the NSOperationQueue here
	queue = [[NSOperationQueue alloc] init];
	
	//Only load item at a time. No point loading more than one anyway.
	[queue setMaxConcurrentOperationCount:1];
	
	//Prepare the loading screen
	introScene = [[JNPIntroScene alloc] init];

	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
	//[director_ pushScene: [[JNPIntroScene alloc]init]]; 
	
    [self startGame:nil];
    
	return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];
	
	[super dealloc];
}

-(void)startGame:(id)sender{
	//Throw up the loading screen while loading stuff in the background.
	//[[CCDirector sharedDirector] replaceScene:introScene];
    [[CCDirector sharedDirector] pushScene: introScene]; 
	
	//Load all the resources. This will not block the main thread. See JNPIntroBaseLayer.m and etc...
	introLayer = [JNPIntroBaseLayer node];
}

//This function should only be called when everything is done loading. This function is only called in
//targetLayer since it's the last item to be loaded. Once it's loaded, we know the game is ready to go.
-(void) reportProgressDone:(id)obj
{
	[introScene increasePercentage:1];	
	
    NSLog(@"JNPMenuScene node...");

	JNPMenuScene *menuScene = [[JNPMenuScene node] retain];
	//[menuScene node];
	
    NSLog(@"pushScene: menuScene node...");
    
	//Everything is now loaded. Let's start the game!
	//[[CCDirector sharedDirector] replaceScene:menuScene];
    [[CCDirector sharedDirector] pushScene: menuScene]; 
}

//Increment the loading scene progrss bar.
-(void) reportProgress:(id)obj
{
    NSLog(@"reportProgress...");
    
	[introScene increasePercentage:33];	
}

@end

