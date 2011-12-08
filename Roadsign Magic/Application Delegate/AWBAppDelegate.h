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
    CGSize signBackgroundSize;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *mainNavigationController;
@property (nonatomic, assign) CGSize signBackgroundSize;

@end
