//
//  AppDelegate.m
//  GoodGap
//
//  Created by Jesse MacFadyen on 12-01-06.
//  Copyright (c) 2012 Nitobi. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize gdLibrary;
@synthesize viewController;// = _viewController;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

// change the app ID and version here to the ID and version enabled on the GC
NSString* kappId = @"nitobi.goodgap";
NSString* kappVersion = @"1.0.0.0";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    gdLibrary = [GDiOS sharedInstance];
    gdLibrary.delegate = self;
    started = NO;
    
    // Start up the Good Library.
    [gdLibrary authorise:kappId andVersion:kappVersion];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)awakeFromNib
{
    [_window resignKeyWindow];
#if !(__has_feature(objc_arc))
    [_window release];
#else
    CFTypeRef cfWindow = (__bridge CFTypeRef)_window;
    CFRelease(cfWindow); 
#endif
    self.window = [[GDiOS sharedInstance] getWindow];    
}

-(void)handleEvent:(GDAppEvent*)anEvent
{
    /* Called from gdLibrary when events occur, such as system startup. */

    switch (anEvent.type) 
    {
		case GDAppEventAuthorised: 
        {
            [self onAuthorised:anEvent];
			break;
        }
		case GDAppEventNotAuthorised: 
        {
            [self onNotAuthorised:anEvent];
			break;
        }
		case GDAppEventRemoteSettingsUpdate: 
        {
            // handle app config changes
			break;
        }            
    }
}

-(void) onAuthorised:(GDAppEvent*)anEvent 
{
    /* Handle the Good Libraries authorised event. */                            

    switch (anEvent.code) {
        case GDErrorNone: {
            if (!started) {
                // launch application UI here
                started = YES;
                self.viewController = [[MainViewController alloc] init];
                
                self.window.rootViewController = self.viewController;
            }
            break;
        }
        default:
            NSAssert(false, @"Authorised startup with an error");
            break;
    }
}

-(void) onNotAuthorised:(GDAppEvent*)anEvent 
{
    /* Handle the Good Libraries not authorised event. */                            

    switch (anEvent.code) {
        case GDErrorActivationFailed:
        case GDErrorProvisioningFailed:
        case GDErrorPushConnectionTimeout:
        case GDErrorProvisioningCancelled: {
            // application can either handle this and show it's own UI or just call back into
            // the GD library and the welcome screen will be shown            
            [gdLibrary authorise:kappId andVersion:kappVersion];
            break;
        }
        case GDErrorSecurityError:
        case GDErrorAppDenied:
        case GDErrorBlocked:
        case GDErrorWiped:
        case GDErrorRemoteLockout: 
        case GDErrorPasswordChangeRequired: {
            // an condition has occured denying authorisation, an application may wish to log these events
            NSLog(@"onNotAuthorised %@", anEvent.message);
            break;
        }
        case GDErrorIdleLockout: {
            // idle lockout is benign & informational
            break;
        }
        default: 
            NSAssert(false, @"Unhandled not authorised event");
            break;
    }
}

@end
