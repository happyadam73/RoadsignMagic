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
#import "AWBDeviceHelper.h"
#import "AWBRoadsignMagicStoreViewController.h"

@implementation AWBRoadsignMagicMainViewController (Facebook)

#pragma mark - FBSessionDelegate Methods

- (void)loginToFacebook
{   
    // Check and retrieve authorization information
    if (IS_GOPRO_PURCHASED) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] 
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        if (![facebook isSessionValid]) {
            facebook.sessionDelegate = self;
            NSArray *myPermissions = [NSArray arrayWithObjects: @"publish_stream", nil];
            [facebook authorize:myPermissions];
        } else {
            [self confirmUploadImageToFacebook];
        }        
    } else {
        [self facebookExportNotPurchased];
    }
}

- (void)facebookExportNotPurchased
{
    //message - then push onto the store
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"\"Go Pro\" not installed" 
                              message:@"Sharing with Facebook requires the \"Go Pro\" in-app purchase available through the In-App Store.  If you have purchased it already, you can also restore your purchase in the In-App Store." 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [alertView release];  
    
    AWBRoadsignMagicStoreViewController *controller = [[AWBRoadsignMagicStoreViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];      
}

- (void)confirmUploadImageToFacebook
{
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Post image to Facebook?" 
                              message:@"Upload image to the Roadsign Magic Facebook album?" 
                              delegate:self 
                              cancelButtonTitle:@"No" 
                              otherButtonTitles:@"Yes", 
                              nil];
    
    [alertView show];
    [alertView release];   

}

- (void)uploadImageToFacebook
{  
    if (!self.navigationController.toolbarHidden) {
        [self toggleFullscreen];
    }
    self.busyView.hidden = YES;
    CGFloat quality = 0.5;
    if (IS_GOPRO_PURCHASED) {
        if (self.exportSize > 1.0) {
            quality = 1.0;
        } else {
            quality = self.exportSize;
        }
    }    
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
    NSString *message = [NSString stringWithFormat:@"Created on my %@ using Roadsign Magic", machineFriendlyName()];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   image, @"picture",
                                   message, @"message", 
                                   nil];

    if (currentFacebookRequest) {
        currentFacebookRequest.delegate = nil;
    }
    
    currentFacebookRequest = [facebook requestWithGraphPath:@"me/photos"
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
    // Save authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    //complete facebook upload
    [self confirmUploadImageToFacebook];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled 
{
    [self.busyView removeFromParentView];
    self.busyView = nil;
    
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Facebook Not Connected" 
                              message:@"You have not logged in to Facebook.  Image upload cancelled." 
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

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {

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
//    if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
//        result = [result objectAtIndex:0];
//    }
    
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Facebook Upload Succeeded!" 
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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [self uploadImageToFacebook];
    } else {
        [self.busyView removeFromParentView];
        self.busyView = nil;
    }
}


@end
