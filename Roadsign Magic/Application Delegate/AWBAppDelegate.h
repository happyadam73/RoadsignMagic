//
//  AWBAppDelegate.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 19/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWBAppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController *mainNavigationController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *mainNavigationController;

@end
