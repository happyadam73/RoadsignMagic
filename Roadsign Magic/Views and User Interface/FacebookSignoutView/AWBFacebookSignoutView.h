//
//  AWBFacebookSignoutView.h
//  Roadsign Magic
//
//  Created by Buckley Adam on 21/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "AWBAppDelegate.h"

@interface AWBFacebookSignoutView : UIView <FBSessionDelegate> {
    Facebook *facebook;
    UILabel *textLabel;
    UIButton *signOutButton;
}

- (void)handleCurrentFacebookSession;
- (void)showLoggedIn;
- (void)showLoggedOut;
- (void)logoutFromFacebook;
- (void)removeFacebookSession;
- (void)addTextLabel;
- (void)addSignoutButton;

@end
