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
#import "AWBSettings.h"
#import "AWBRoadsignsListViewController.h"
#import "AWBRoadsignStore.h"
#import "AWBRoadsignDescriptor.h"
#import "Facebook.h"

static NSString* kAppId = @"289600444412359";

@implementation AWBAppDelegate

@synthesize window=_window;
@synthesize mainNavigationController;
@synthesize signBackgroundSize;
@synthesize facebook;
//@synthesize userPermissions;

- (void)dealloc
{
    [_window release];
    [mainNavigationController release];
    [facebook release];
//    [userPermissions release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.signBackgroundSize = CGSizeZero;
    // Initialize Facebook
    facebook = [[Facebook alloc] initWithAppId:kAppId urlSchemeSuffix:@"rsm" andDelegate:nil];
    
    NSURL *url = (NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if (url) {
        NSLog(@"URL: %@", url);
        if ([[url absoluteString] hasPrefix:[self.facebook getOwnBaseUrl]]) {
            [self.facebook handleOpenURL:url];
        }   
    }
    
    // Initialize user permissions
    //    userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];

    AWBRoadsignDescriptor *roadsign = nil;
    NSUInteger totalSavedRoadsigns = [[[AWBRoadsignStore defaultStore] allRoadsigns] count];
    NSInteger roadsignIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyRoadsignStoreRoadsignIndex];
    if (totalSavedRoadsigns==0) {
        //no roadsigns
        //if user default index is -1 then this was by choice - user deleted them all so roadsign is nil otherwise this
        //is the first ever start so create one for the user automatically
        if (roadsignIndex != -1) {
            roadsign = [[AWBRoadsignStore defaultStore] createRoadsign];
            //first roadsign
            roadsign.roadsignName = @"Roadsign 1";
        }
    } else {
        //check what the last selected roadsign was
        //if it's -1 (last used the list view) or it's outside array bounds, then roadsign not set
        if ((roadsignIndex >= 0) && (roadsignIndex < totalSavedRoadsigns)) {
            roadsign = [[[AWBRoadsignStore defaultStore] allRoadsigns] objectAtIndex:roadsignIndex];
//            if (collage.totalObjects >= [CollageMakerViewController excessiveSubviewCountThreshold]) {
//                NSLog(@"Collage Total Objects: %d - exceed threshold (%d), so don't load", collage.totalObjects, [CollageMakerViewController excessiveSubviewCountThreshold]);
//                collage = nil;
//            }
        }
    }
    
    AWBRoadsignsListViewController *listController = [[AWBRoadsignsListViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:listController];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    navController.navigationBar.translucent = YES;
    navController.toolbar.barStyle = UIBarStyleBlack;
    navController.toolbar.translucent = YES;
    
    //navigate to collage if one was previously selected, or this is the first collage
    if (roadsign) {
        AWBRoadsignMagicMainViewController *roadsignController = [[AWBRoadsignMagicMainViewController alloc] initWithRoadsignDescriptor:roadsign];
        [navController pushViewController:roadsignController animated:NO];
        [roadsignController release];        
    }
        
    self.mainNavigationController = navController;
    self.window.rootViewController = self.mainNavigationController;
    [navController release];
    [listController release];
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
    [self.mainNavigationController.topViewController viewWillDisappear:NO];
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
    [self.mainNavigationController.topViewController viewDidAppear:NO];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{       
    NSLog(@"URL: %@", url);
    
    if ([[url absoluteString] hasPrefix:[self.facebook getOwnBaseUrl]]) {
        return [self.facebook handleOpenURL:url];
    } else {
        if ([url isFileURL]) {
            //my font stuff
            return YES;            
        } else {
            return NO;
        }
    }   
}

@end
