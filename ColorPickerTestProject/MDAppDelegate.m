//
//  CPAppDelegate.m
//  ColorPickerTestProject
//
//  Created by Roman Derkach on 2/18/14.
//  Copyright (c) 2014 mobidev. All rights reserved.
//

#import "MDAppDelegate.h"

#import "MDColorsViewController.h"

@interface MDAppDelegate ()

@end

@implementation MDAppDelegate

- (BOOL)                  application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
	UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController: [MDColorsViewController new]];
	self.window.rootViewController = rootVC;

	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
