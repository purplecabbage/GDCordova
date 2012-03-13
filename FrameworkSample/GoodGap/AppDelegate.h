//
//  AppDelegate.h
//  GoodGap
//
//  Created by Jesse MacFadyen on 12-01-06.
//  Copyright (c) 2012 Nitobi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GD/GDiOS.h>

#import "MainViewController.h"


@interface AppDelegate : NSObject <UIApplicationDelegate, GDiOSDelegate> {
    BOOL started;
}

-(void) onAuthorised:(GDAppEvent*)anEvent;
-(void) onNotAuthorised:(GDAppEvent*)anEvent;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) GDiOS *gdLibrary;

@property (nonatomic, retain) MainViewController *viewController;

@end