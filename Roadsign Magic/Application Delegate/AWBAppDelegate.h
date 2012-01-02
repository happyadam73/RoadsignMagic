//
//  AWBAppDelegate.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 19/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface AWBAppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController *mainNavigationController;
    CGSize signBackgroundSize;
    Facebook *facebook;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *mainNavigationController;
@property (nonatomic, assign) CGSize signBackgroundSize;
@property (nonatomic, retain) Facebook *facebook;

- (BOOL)handleOpenURL:(NSURL *)url;

@end
