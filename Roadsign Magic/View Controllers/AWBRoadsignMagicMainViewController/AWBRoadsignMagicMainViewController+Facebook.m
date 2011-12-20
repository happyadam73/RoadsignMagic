//
//  AWBRoadsignMagicMainViewController+Facebook.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 20/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController+Facebook.h"
#import "FBConnect.h"
#import "AWBRoadsignMagicMainViewController+UI.h"
#import "AWBRoadsignMagicViewController+Action.h"

@implementation AWBRoadsignMagicMainViewController (Facebook)

#pragma mark - FBSessionDelegate Methods

- (void)loginToFacebook
{
    AWBAppDelegate *delegate = (AWBAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [delegate facebook].accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [delegate facebook].expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![[delegate facebook] isSessionValid]) {
        [delegate facebook].sessionDelegate = self;
        NSArray *myPermissions = [NSArray arrayWithObjects: @"publish_stream", nil];
        [[delegate facebook] authorize:myPermissions];
    } else {
        [self uploadImageToFacebook];
    }
}

- (void)uploadImageToFacebook
{  
    if (!self.navigationController.toolbarHidden) {
        [self toggleFullscreen];
    }
    
    self.busyView.hidden = YES;
    CGFloat quality = 1.0;
    UIImage *roadsignImage = [self generateRoadsignImageWithScaleFactor:quality];
    [self toggleFullscreen];
    self.busyView.hidden = NO;
    [self.busyView removeFromParentView];
    self.busyView = nil;
    [self facebookPostImage:roadsignImage];        
}

/*
 * Graph API: Upload a photo. By default, when using me/photos the photo is uploaded
 * to the application album which is automatically created if it does not exist.
 */
- (void) facebookPostImage:(UIImage *)image
{
    AWBAppDelegate *delegate = (AWBAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   image, @"picture",
                                   @"Created using Roadsign Magic", @"message", 
                                   @"Roadsign Magic", @"caption", 
                                   nil];
    
    [[delegate facebook] requestWithGraphPath:@"me/photos"
                                    andParams:params
                                andHttpMethod:@"POST"
                                  andDelegate:self];
}

#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin 
{    
    AWBAppDelegate *delegate = (AWBAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Save authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[delegate facebook] accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[delegate facebook] expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    //complete facebook upload
    [self uploadImageToFacebook];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled 
{
    NSLog(@"did not login");
    [self.busyView removeFromParentView];
    self.busyView = nil;
    
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Facebook Not Connected" 
                              message:@"You have not logged in to Facebook.  Image upload is cancelled." 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [alertView release];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout
{
    [self.busyView removeFromParentView];
    self.busyView = nil;
    NSLog(@"fbDidLogout");
}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response: %@", response);
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
        result = [result objectAtIndex:0];
    }
    
    NSLog(@"Result: %@", result);
    
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Facebook Succeeded!" 
                              message:@"Image has been uploaded to Facebook." 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [alertView release];   
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Facebook Failed!" 
                              message:@"Image could not be uploaded to Facebook." 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [alertView release];
}

@end
