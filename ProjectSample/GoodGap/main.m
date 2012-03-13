//
//  main.m
//  GoodGap
//
//  Created by Jesse MacFadyen on 12-01-06.
//  Copyright 2012 Nitobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GD/GDios.h>

int main(int argc, char* argv[])
{
    int retVal = 0;
#if !(__has_feature(objc_arc))
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
#else
    @autoreleasepool {
#endif
    [GDiOS initialiseWithClassNameConformingToUIApplicationDelegate:@"AppDelegate"];
    retVal = UIApplicationMain(argc, argv, nil, nil);
    [GDiOS finalise];
#if !(__has_feature(objc_arc))
    [pool release];
#else
}
#endif
    return retVal;
}
