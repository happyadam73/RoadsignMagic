//
//  AWBRoadsignMagicMainViewController+Facebook.h
//  Roadsign Magic
//
//  Created by Buckley Adam on 20/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBRoadsignMagicMainViewController.h"
#import "FBConnect.h"

@interface AWBRoadsignMagicMainViewController (Facebook) <FBRequestDelegate,FBSessionDelegate> 

- (void)loginToFacebook;
- (void)uploadImageToFacebook;
- (void) facebookPostImage:(UIImage *)image;

@end
