//
//  AWBAppDelegate.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 19/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBAppDelegate.h"
#import "AWBRoadsignMagicMainViewController.h"
#import "AWBRoadsignMagicMainViewController+UI.h"
#import "AWBRoadsignMagicSettingsTableViewController.h"

@implementation AWBAppDelegate

@synthesize window=_window;
@synthesize mainNavigationController;

- (void)dealloc
{
    [_window release];
    [mainNavigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    AWBRoadsignMagicMainViewController *viewController = [[AWBRoadsignMagicMainViewController alloc] init];
//    AWBRoadsignMagicSettingsTableViewController *settingsController = [[AWBRoadsignMagicSettingsTableViewController alloc] initWithSettings:[AWBSettings mainSettingsWithInfo:[viewController settingsInfo]] settingsInfo:[viewController settingsInfo] rootController:nil]; 
//    settingsController.controllerType = AWBSettingsControllerTypeMainSettings;  
//    settingsController.navigationItem.title = @"My Signs";
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    [navController pushViewController:viewController animated:YES];
    [viewController release];
//    [settingsController release];
    
    navController.navigationBar.barStyle = UIBarStyleBlack;
    navController.navigationBar.translucent = YES;
    navController.navigationBarHidden = NO;
    navController.toolbar.barStyle = UIBarStyleBlack;
    navController.toolbar.translucent = YES;
    navController.toolbarHidden = NO;
    self.mainNavigationController = navController;
    self.window.rootViewController = navController;    
    [navController release];    
    
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

@end
