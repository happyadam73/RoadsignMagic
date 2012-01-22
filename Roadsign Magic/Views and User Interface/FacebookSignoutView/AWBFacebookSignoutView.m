//
//  AWBFacebookSignoutView.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 21/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBFacebookSignoutView.h"

@implementation AWBFacebookSignoutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        AWBAppDelegate *delegate = (AWBAppDelegate *)[[UIApplication sharedApplication] delegate];
        facebook = [delegate facebook];
        facebook.sessionDelegate = self;        
        [self addTextLabel];
        [self addSignoutButton];
        [self handleCurrentFacebookSession];
    }
    return self;
}

- (void)handleCurrentFacebookSession
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if ([facebook isSessionValid]) {
        [self showLoggedIn];
    } else {
        [self showLoggedOut];
    }
}

- (void)showLoggedIn
{
    signOutButton.enabled = YES;
    textLabel.text = @"You are currently signed in to Facebook.  Sign out if you need to change accounts.  You may also need to sign out from Facebook in Safari or within the Facebook app.";
}

- (void)showLoggedOut
{
    textLabel.text = @"Roadsign Magic is not currently signed in to Facebook.  You will need to first sign in and authorise Roadsign Magic when you next upload a roadsign.";
    signOutButton.enabled = NO;
}

- (void)logoutFromFacebook
{
    [facebook logout:self];
}

- (void)addTextLabel
{
    CGFloat leftMargin = 10.0;
    CGFloat topMargin = 10.0;
    CGFloat frameWidth = 300.0;
    CGFloat frameHeight = 110.0;
    CGFloat fontSize = 15.0;
    
    if (DEVICE_IS_IPAD) {
        leftMargin = 10.0;
        topMargin = 10.0;
        frameWidth = 300.0;
        frameHeight = 110.0;
        fontSize = 15.0;
    } 
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, frameWidth, frameHeight)];
    textLabel.numberOfLines = 0;
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setFont:[UIFont systemFontOfSize:fontSize]];
    textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1.0];
    textLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    
    [self addSubview:textLabel];
}

- (void)addSignoutButton
{
    CGFloat leftMargin = 10.0;
    CGFloat topMargin = 140.0;
    CGFloat frameWidth = 300.0;
    CGFloat frameHeight = 50.0;
    CGFloat fontSize = 18.0;
    
    if (DEVICE_IS_IPAD) {
        leftMargin = 10.0;
        topMargin = 140.0;
        frameWidth = 300.0;
        frameHeight = 50.0;
        fontSize = 18.0;
    } 
    
    signOutButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    signOutButton.frame = CGRectMake(leftMargin, topMargin, frameWidth, frameHeight);
    [signOutButton.titleLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [signOutButton setTitle:@"Sign Out from Facebook" forState:(UIControlStateNormal | UIControlStateNormal)];
    [signOutButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    signOutButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [signOutButton addTarget:self action:@selector(logoutFromFacebook) forControlEvents:UIControlEventTouchUpInside];
    [signOutButton setShowsTouchWhenHighlighted:YES];
    [self addSubview:signOutButton];
}

#pragma mark - FBSessionDelegate Methods

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout
{
    [self removeFacebookSession];
    [self showLoggedOut];
}

- (void)removeFacebookSession
{
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
        
        // Nil out the session variables to prevent
        // the app from thinking there is a valid session
        if (nil != [facebook accessToken]) {
            facebook.accessToken = nil;
        }
        if (nil != [facebook expirationDate]) {
            facebook.expirationDate = nil;
        }
    }    
}

- (void)dealloc
{
    facebook.sessionDelegate = nil;
    [signOutButton release];
    [textLabel release];
    [super dealloc];
}

@end
