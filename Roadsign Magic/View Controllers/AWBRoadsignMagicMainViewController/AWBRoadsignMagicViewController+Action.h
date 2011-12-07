//
//  AWBRoadsignMagicViewController+Action.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface AWBRoadsignMagicMainViewController (Action) <MFMailComposeViewControllerDelegate, UIPrintInteractionControllerDelegate> 

- (void)performAction:(id)sender;
- (void)chooseActionTypeActionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (UIImage *)generateRoadsignImageWithScaleFactor:(CGFloat)scaleFactor;
- (void)saveImageToSavedPhotosAlbum:(UIImage *)image; 
- (void)saveRoadsignAsPhoto;
- (void)emailRoadsignAsPhoto;
- (void)displayRoadsignEmailCompositionSheet:(UIImage *)image;
- (void)printItemWithSize:(NSNumber *)sizeNumber;
- (NSString *)typeOfRoadsignDescription;
- (BOOL)canUseTwitter;
- (void)twitterRoadsignAsPhoto;
- (void)displayTwitterControllerWithImage:(UIImage *)image;

@end
