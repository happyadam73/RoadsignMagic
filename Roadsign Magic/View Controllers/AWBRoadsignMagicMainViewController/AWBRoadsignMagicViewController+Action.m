//
//  AWBRoadsignMagicViewController+Action.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicViewController+Action.h"
#import "AWBRoadsignMagicViewController+Delete.h"
#import "AWBRoadsignMagicMainViewController+UI.h"
#import "AWBRoadsignMagicViewController+Edit.h"
#import "AWBRoadsignMagicMainViewController+Toolbar.h"
#import "UIImage+Scale.h"
#import "AWBTransforms.h"
#import "AWBRoadsignDescriptor.h"
#import "AWBDeviceHelper.h"
#import <Twitter/Twitter.h>
#import "UIImage+NonCached.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

@implementation AWBRoadsignMagicMainViewController (Action)

- (void)performAction:(id)sender
{
    [self resetEditMode:sender];
    
    BOOL wasActionSheetVisible = self.chooseActionTypeSheet.visible;
    [self dismissAllActionSheetsAndPopovers];
    [self dismissAllSlideUpPickerViews];
    
    if (wasActionSheetVisible) {
        return;
    }
    
    UIActionSheet *actionSheet = nil;
    if ([UIPrintInteractionController isPrintingAvailable]) {
        if ([self canUseTwitter]) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                             cancelButtonTitle:@"Cancel" 
                                        destructiveButtonTitle:nil 
                                             otherButtonTitles:@"Save Roadsign as Photo", @"Email Roadsign", @"Print (4x6, A6)", @"Print (Letter, A4)", @"Twitter", nil];                
        } else {                
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                             cancelButtonTitle:@"Cancel" 
                                        destructiveButtonTitle:nil 
                                             otherButtonTitles:@"Save Roadsign as Photo", @"Email Roadsign", @"Print (4x6, A6)", @"Print (Letter, A4)", nil];
        }
    } else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                         cancelButtonTitle:@"Cancel" 
                                    destructiveButtonTitle:nil 
                                         otherButtonTitles:@"Save Roadsign as Photo", @"Email Roadsign", nil];
    }
    self.chooseActionTypeSheet = actionSheet;
    [actionSheet release];
    
    [self.chooseActionTypeSheet showFromBarButtonItem:self.actionButton animated:YES];

}

- (void)chooseActionTypeActionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        
        if (self.exportSize == 0.0) {
            self.exportSize = 1.0;
        }
        
        SEL methodSelector;
        id methodObject = nil;
        NSString *busyText = nil;
        NSString *busyTextDetail = nil;
        
        if (buttonIndex == [actionSheet firstOtherButtonIndex]) {
            //Save Image
            busyText = @"Exporting Image";
            busyTextDetail = [NSString stringWithFormat:@"(Size: %@)", AWBImageSizeFromExportSizeValue(self.exportSize)];
            methodSelector = @selector(saveRoadsignAsPhoto);
        } else if (buttonIndex == ([actionSheet firstOtherButtonIndex]+1)) {
            //Email Image
            busyText = @"Preparing for Email";
            busyTextDetail = [NSString stringWithFormat:@"(Size: %@)", AWBImageSizeFromExportSizeValue(self.exportSize)];
            methodSelector = @selector(emailRoadsignAsPhoto);
        } else if (buttonIndex == ([actionSheet firstOtherButtonIndex]+2)) {
            // Print Image (4x6, A6)
            busyText = @"Preparing for Print";
            busyTextDetail = @"(4x6, A6)";
            methodSelector = @selector(printItemWithSize:);
            methodObject = [NSNumber numberWithInteger:0];
        } else if (buttonIndex == ([actionSheet firstOtherButtonIndex]+3)) {
            // Print Image
            busyText = @"Preparing for Print";
            busyTextDetail = @"(Letter, A4)";
            methodSelector = @selector(printItemWithSize:);
            methodObject = [NSNumber numberWithInteger:1];
        } else if (buttonIndex == ([actionSheet firstOtherButtonIndex]+4)) {
            // Twitter Image
            busyText = @"Preparing for Twitter";
            CGFloat quality = (DEVICE_IS_IPAD? 1.0 : 2.0);
            busyTextDetail = [NSString stringWithFormat:@"(Size: %@)", AWBImageSizeFromExportSizeValue(quality)];
            methodSelector = @selector(twitterRoadsignAsPhoto);
        }
        
        if (busyText) {
            AWBBusyView *busyIndicatorView = [[AWBBusyView alloc] initWithText:busyText detailText:busyTextDetail parentView:self.view centerAtPoint:self.view.center];
            self.busyView = busyIndicatorView;
            [busyIndicatorView release];
            [self performSelector:methodSelector withObject:methodObject afterDelay:0.0];	
        }	
    }
}

- (UIImage *)generateRoadsignImageWithScaleFactor:(CGFloat)scaleFactor
{
    UIGraphicsBeginImageContextWithOptions(self.signBackgroundView.bounds.size, NO, scaleFactor);
//    if (self.useBackgroundTexture && self.collageBackgroundTexture) {
//        UIImage *image = [UIColor textureImageWithDescription:self.collageBackgroundTexture];
//        CGContextDrawTiledImage(UIGraphicsGetCurrentContext(), CGRectMake(0.0, 0.0, (image.size.width/scaleFactor),  (image.size.height/scaleFactor)), [image CGImage]);
//        self.view.backgroundColor = [UIColor clearColor];
//    }
    
//    UIImage *image = [UIImage imageFromFile:@"concrete.jpg"];
//    CGContextDrawTiledImage(UIGraphicsGetCurrentContext(), CGRectMake(0.0, 0.0, (image.size.width * scaleFactor),  (image.size.height * scaleFactor)), [image CGImage]);
    
    [self.signBackgroundView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roadsignImage = UIGraphicsGetImageFromCurrentImageContext();
//    if (self.useBackgroundTexture && self.collageBackgroundTexture) {
//        self.view.backgroundColor = [UIColor textureColorWithDescription:self.collageBackgroundTexture];
//    }
    UIGraphicsEndImageContext();
    
    NSLog(@"Roadsign Image %f x %f", roadsignImage.size.width, roadsignImage.size.height);
    
    return roadsignImage;
}

- (void)saveRoadsignAsPhoto
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if (!self.navigationController.toolbarHidden) {
        [self toggleFullscreen];
    }
    self.busyView.hidden = YES;
    UIImage *roadsignImage = [self generateRoadsignImageWithScaleFactor:self.exportSize];    
    [self toggleFullscreen];
    self.busyView.hidden = NO;
    [self.busyView removeFromParentView];
    self.busyView = nil;
    [self saveImageToSavedPhotosAlbum:roadsignImage];   
    [pool drain];
}

- (void)saveImageToSavedPhotosAlbum:(UIImage *)image 
{
    NSData *data = UIImagePNGRepresentation(image);
    //NSData *data = UIImageJPEGRepresentation(image, 0.7);
    ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];
	[al writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {}];
    [al release];
    
        
//    [image retain];
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo 
{
    if(error != nil) {
        NSLog(@"ERROR SAVING:%@",[error localizedDescription]);
    }
    [image release];
}

- (void)emailRoadsignAsPhoto
{
    if (!self.navigationController.toolbarHidden) {
        [self toggleFullscreen];
    }
    self.busyView.hidden = YES;
    UIImage *roadsignImage = [self generateRoadsignImageWithScaleFactor:self.exportSize];
    [self toggleFullscreen];
    self.busyView.hidden = NO;
    [self.busyView removeFromParentView];
    self.busyView = nil;
    
    if ([MFMailComposeViewController canSendMail]) {
        [self displayRoadsignEmailCompositionSheet:roadsignImage];        
    }
}

- (void)displayRoadsignEmailCompositionSheet:(UIImage *)image 
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    NSString *subjectLine = [NSString stringWithFormat:@"Check Out My New %@!", [self typeOfRoadsignDescription]];
    [picker setSubject:subjectLine];
    
    // Attach an image to the email
    NSData *imageData = UIImagePNGRepresentation(image);
    [picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"roadsign.png"];
    
    // Fill out the email body text
    NSString *emailBody = [NSString stringWithFormat:@"This %@ was made on my %@ using Roadsign Magic", [self typeOfRoadsignDescription], machineFriendlyName()];
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentModalViewController:picker animated:YES];
    
    [picker release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)printItemWithSize:(NSNumber *)sizeNumber
{
    BOOL print6x4 = ([sizeNumber integerValue] == 0);
    
    if (!self.navigationController.toolbarHidden) {
        [self toggleFullscreen];
    }
    self.busyView.hidden = YES;
    
    // calculate the scaling factor that will reduce the image size to maxPixels
    CGFloat actualHeight = self.signBackgroundView.bounds.size.height;
    CGFloat actualWidth = self.signBackgroundView.bounds.size.width;
    
    CGFloat requiredHeight;
    CGFloat requiredWidth;
    CGFloat aspectRatio = (print6x4 ? 1.5 : 1.41);
    CGFloat leftMargin = 0.0;
    CGFloat rightMargin = 0.0;
    CGFloat topMargin = 0.0;
    CGFloat bottomMargin = 0.0;
    CGFloat offsetLeft = 0.0;
    CGFloat offsetTop = 0.0;
    CGFloat scaleFactor = (print6x4 ? 1.1 : 1.5);
    CGFloat delta = 0.0;

    if (actualWidth < actualHeight) {
        requiredWidth = actualWidth;
        requiredHeight = aspectRatio * actualWidth;
    } else {
        requiredHeight = actualHeight;
        requiredWidth = aspectRatio * actualHeight;
    }

    if (requiredWidth > actualWidth) {
        delta = (requiredWidth - actualWidth);
        leftMargin = (delta/2.0);
        rightMargin = (delta/2.0);
    }
    
    if (requiredHeight > actualHeight) {
        delta = (requiredHeight - actualHeight);
        topMargin = (delta/2.0);
        bottomMargin = (delta/2.0);
    }
    
    CGFloat extraWidth = (0.05 * (actualWidth + leftMargin + rightMargin));
    CGFloat extraHeight = (0.05 * (actualHeight + topMargin + bottomMargin));
    leftMargin += extraWidth;
    rightMargin += extraWidth;
    topMargin += extraHeight;
    bottomMargin += extraHeight;
    offsetLeft = leftMargin;
    offsetTop = topMargin;
        
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth + leftMargin + rightMargin, actualHeight + topMargin + bottomMargin);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, scaleFactor);    
       
//    self.view.backgroundColor = [UIColor clearColor];
    
    //for non mosaics, switch off mask to bounds
//    CollageThemeType themeType = self.collageDescriptor.themeType;
//    switch (themeType) {
//        case kAWBCollageThemeTypePhotoMosaicSmallImagesBlack:
//        case kAWBCollageThemeTypePhotoMosaicSmallImagesWhite:
//        case kAWBCollageThemeTypePhotoMosaicLargeImagesBlack:
//        case kAWBCollageThemeTypePhotoMosaicLargeImagesWhite:
//        case kAWBCollageThemeTypePhotoMosaicMicroImagesBlack:
//            [self view].layer.masksToBounds = YES;
//            break;
//        default:
//            [self view].layer.masksToBounds = NO;        
//    } 
    
//    if (self.useBackgroundTexture) {
//        UIImage *image = [UIColor textureImageWithDescription:self.collageBackgroundTexture];
//        CGContextDrawTiledImage(UIGraphicsGetCurrentContext(), CGRectMake(0.0, 0.0, (image.size.width/scaleFactor),  (image.size.height/scaleFactor)), [image CGImage]);        
//    } else {
//        [self.collageBackgroundColor setFill];        
//        UIRectFill(rect);
//    }

    [[UIColor whiteColor] setFill];        
    UIRectFill(rect);

    CGContextRef resizedContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(resizedContext, offsetLeft, offsetTop);
    [self.signBackgroundView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roadsignImage = UIGraphicsGetImageFromCurrentImageContext();
    
//    if (self.useBackgroundTexture) {
//        self.view.backgroundColor = [UIColor textureColorWithDescription:self.collageBackgroundTexture];
//    } else {
//        self.view.backgroundColor = self.collageBackgroundColor;        
//    }
//    if (self.addCollageBorder && self.collageBorderColor) {
//        [self addCollageBorderToView];
//    }
    
    UIGraphicsEndImageContext();      
    
//    [self view].layer.masksToBounds = YES;    
    self.busyView.hidden = NO;
    [self toggleFullscreen];
    
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    
    NSData *myData = [NSData dataWithData:UIImagePNGRepresentation(roadsignImage)];
    
    [self.busyView removeFromParentView];
    self.busyView = nil;
    
    if(printController && [UIPrintInteractionController canPrintData:myData]) {
        
        printController.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        if (print6x4) {
            printInfo.outputType = UIPrintInfoOutputPhoto;
        } else {
            printInfo.outputType = UIPrintInfoOutputGeneral;            
        }
        printInfo.jobName = self.roadsignDescriptor.roadsignName;
        printController.printInfo = printInfo;
        printController.printingItem = myData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            }
        };
        
        if (DEVICE_IS_IPAD) {
            [printController presentFromBarButtonItem:self.actionButton animated:YES completionHandler:completionHandler];        
        } else {
            [printController presentAnimated:YES completionHandler:completionHandler];
        }
    }
}

- (NSString *)typeOfRoadsignDescription
{
    return @"Roadsign";    
}

- (BOOL)canUseTwitter
{
    if ([TWTweetComposeViewController class] != nil) {
        return ([TWTweetComposeViewController canSendTweet]);
    } else {
        return NO;
    }
}

- (void)twitterRoadsignAsPhoto
{
    if ([TWTweetComposeViewController canSendTweet]) {        
        if (!self.navigationController.toolbarHidden) {
            [self toggleFullscreen];
        }
        self.busyView.hidden = YES;
        //CGFloat quality = (DEVICE_IS_IPAD? 1.0 : 2.0);
        CGFloat quality = 1.0;
        UIImage *roadsignImage = [self generateRoadsignImageWithScaleFactor:quality];
        [self toggleFullscreen];
        self.busyView.hidden = NO;
        [self.busyView removeFromParentView];
        self.busyView = nil;
        [self displayTwitterControllerWithImage:roadsignImage];    
    } else {
        [self.busyView removeFromParentView];
        self.busyView = nil;        
    }
}

- (void)displayTwitterControllerWithImage:(UIImage *)image
{
    TWTweetComposeViewController *twitterController = [[TWTweetComposeViewController alloc] init];
    [twitterController setInitialText:[NSString stringWithFormat:@"Here's My New %@!", [self typeOfRoadsignDescription]]];
    [twitterController addImage:image];
    twitterController.completionHandler = ^(TWTweetComposeViewControllerResult res) {[self dismissModalViewControllerAnimated:YES];};
    [self presentViewController:twitterController animated:YES completion:nil];
    [twitterController release];
}

@end
