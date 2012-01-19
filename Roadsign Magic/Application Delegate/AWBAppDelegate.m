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
#import "AWBMyFontsListViewController.h"
#import "AWBRoadsignsListViewController.h"
#import "AWBMyRoadsignsDataSource.h"
#import "AWBTemplateRoadsignsDataSource.h"
#import "AWBRoadsignStore.h"
#import "AWBRoadsignDescriptor.h"
#import "Facebook.h"
#import "AWBMyFont.h"
#import "AWBMyFontStore.h"
#import "AWBDeviceHelper.h"
#import "InAppStore.h"

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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:nil object:nil];

    //initialise in-app store
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[InAppStore defaultStore]];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.signBackgroundSize = CGSizeZero;
    
    // Initialize Facebook
    facebook = [[Facebook alloc] initWithAppId:kAppId urlSchemeSuffix:@"rsm" andDelegate:nil];    

    AWBRoadsignDescriptor *roadsign = nil;
    NSUInteger totalSavedRoadsigns = [[[AWBRoadsignStore defaultStore] myRoadsigns] count];
    NSInteger roadsignIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyMyRoadsignStoreRoadsignIndex];
    if (totalSavedRoadsigns==0) {
        //no roadsigns
        //if user default index is -1 then this was by choice - user deleted them all so roadsign is nil otherwise this
        //is the first ever start so create one for the user automatically
        if (roadsignIndex != -1) {
            roadsign = [[AWBRoadsignStore defaultStore] createMyRoadsign];
            //first roadsign
            roadsign.roadsignName = @"Roadsign 1";
        }
    } else {
        //check what the last selected roadsign was
        //if it's -1 (last used the list view) or it's outside array bounds, then roadsign not set
        if ((roadsignIndex >= 0) && (roadsignIndex < totalSavedRoadsigns)) {
            roadsign = [[[AWBRoadsignStore defaultStore] myRoadsigns] objectAtIndex:roadsignIndex];
//            if (collage.totalObjects >= [CollageMakerViewController excessiveSubviewCountThreshold]) {
//                NSLog(@"Collage Total Objects: %d - exceed threshold (%d), so don't load", collage.totalObjects, [CollageMakerViewController excessiveSubviewCountThreshold]);
//                collage = nil;
//            }
        }
    }
    
    //AWBMyRoadsignsListViewController *listController = [[AWBMyRoadsignsListViewController alloc] init];
    AWBMyRoadsignsDataSource *myRoadsignsDataSource = [[AWBMyRoadsignsDataSource alloc] init];
    AWBTemplateRoadsignsDataSource *templateRoadsignsDataSource = [[AWBTemplateRoadsignsDataSource alloc] init];
    NSArray *dataSources = [NSArray arrayWithObjects:myRoadsignsDataSource, templateRoadsignsDataSource, nil];
    AWBRoadsignsListViewController *listController = [[AWBRoadsignsListViewController alloc] initWithDataSources:dataSources];
    [myRoadsignsDataSource release];
    [templateRoadsignsDataSource release];
    
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
    
    NSURL *url = (NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if (url) {
        return [self handleOpenURL:url];  
    } else {
        return YES;            
    }
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
    return [self handleOpenURL:url];
}

- (BOOL)handleOpenURL:(NSURL *)url
{    
    if ([[url absoluteString] hasPrefix:[self.facebook getOwnBaseUrl]]) {
        return [self.facebook handleOpenURL:url];
    } else {
        if ([url isFileURL]) {
            [self.mainNavigationController.visibleViewController dismissModalViewControllerAnimated:YES];
            
            if (![self.mainNavigationController.topViewController isKindOfClass:[AWBMyFontsListViewController class]]) {
                AWBMyFontsListViewController *controller = [[AWBMyFontsListViewController alloc] init];
                controller.pendingMyFontInstall = YES;
                controller.pendingMyFontInstallURL = url;
                [self.mainNavigationController pushViewController:controller animated:YES];
                [controller release];                
            } else {
                AWBMyFontsListViewController *controller = (AWBMyFontsListViewController *)self.mainNavigationController.topViewController;
                if (controller.installMyFontAlertView) {
                    [controller.installMyFontAlertView dismissWithClickedButtonIndex:controller.installMyFontAlertView.cancelButtonIndex animated:NO];
                } 
                controller.pendingMyFontInstall = YES;
                controller.pendingMyFontInstallURL = url;
            }
            return YES;            
        } else {
            return NO;
        }
    }   
}

//-(void)onNotification:(NSNotification*)notification
//{
//    NSLog(@"Notification name is %@ sent by %@",[notification name], [[notification object] description] );
//}

@end
