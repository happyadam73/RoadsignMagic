//
//  AWBRoadsignMagicViewController+Sign.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicViewController+Sign.h"
#import "UIImage+NonCached.h"
#import "AWBRoadsignMagicMainViewController+UI.h"
#import "UIImage+Scale.h"

#define MAX_SIGN_BACKGROUND_PIXELS 1000000

@implementation AWBRoadsignMagicMainViewController (Sign)

- (void)initialiseSignBackgroundPickerView
{
    CGRect backgroundFrame = CGRectMake(0.0, self.view.bounds.size.height, self.view.bounds.size.width, 180);
    AWBSignBackgroundPickerView *backgroundPicker = [[AWBSignBackgroundPickerView alloc] initWithFrame:backgroundFrame];
    backgroundPicker.delegate = self;
    self.signBackgroundPickerView = backgroundPicker;
	[self.view addSubview:backgroundPicker];
    [backgroundPicker release];
    signBackgroundPickerViewShowing = NO;
}

- (void)toggleSignBackgroundPickerView:(id)sender 
{
    [self dismissSignSymbolPickerView];
    UIButton *button = (UIButton *)sender;
    [self performSelector:@selector(highlightSignBackgroundPickerButton:) withObject:button afterDelay:0];
    
    if (!signBackgroundPickerView) {
        [self initialiseSignBackgroundPickerView];
    }
    
    CGRect frame = signBackgroundPickerView.frame;
    if (!signBackgroundPickerViewShowing) {
        frame.origin.y = (self.view.bounds.size.height - self.navigationController.toolbar.bounds.size.height - frame.size.height);            
    } else {
        frame.origin.y = (self.view.bounds.size.height);                        
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [signBackgroundPickerView setFrame:frame];
    [UIView commitAnimations];
    
    signBackgroundPickerViewShowing = !signBackgroundPickerViewShowing;
}

- (void)highlightSignBackgroundPickerButton:(UIButton*)button 
{
    [button setSelected:signBackgroundPickerViewShowing];
}

- (void)updateSignBackgroundWithImageFromFile:(NSString *)name willAnimateAndSave:(BOOL)animateAndSave
{    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self hideSelectionMarquees];
    //UIImage *image = [[UIImage imageFromFile:name] imageScaledToMaxResolution:MAX_SIGN_BACKGROUND_PIXELS withTransparentBorderThickness:0.0];
    UIImage *image = [UIImage imageFromFile:name];
    [signBackgroundView setImage:image];
    [signBackgroundView sizeToFit];
    signBackgroundView.alpha = 0.0;
    [mainScrollView setContentSize:[signBackgroundView bounds].size];
    
    NSLog(@"mainScrollView: %f %f %f %f", mainScrollView.frame.origin.x, mainScrollView.frame.origin.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height);
    NSLog(@"signBackgroundView: %f %f %f %f", signBackgroundView.frame.origin.x, signBackgroundView.frame.origin.y, signBackgroundView.frame.size.width, signBackgroundView.frame.size.height);    
    NSLog(@"mainScrollView: %f %f %f %f", mainScrollView.bounds.origin.x, mainScrollView.bounds.origin.y, mainScrollView.bounds.size.width, mainScrollView.bounds.size.height);
    NSLog(@"signBackgroundView: %f %f %f %f", signBackgroundView.bounds.origin.x, signBackgroundView.bounds.origin.y, signBackgroundView.bounds.size.width, signBackgroundView.bounds.size.height);    

    
    float minWidthScale  = ((mainScrollView.bounds.size.width)  / signBackgroundView.bounds.size.width) * 0.96;
    float minHeightScale  = ((mainScrollView.bounds.size.height)  / signBackgroundView.bounds.size.height) * 0.96;
    [mainScrollView setMinimumZoomScale:MIN(minWidthScale, minHeightScale)];
    [mainScrollView setMaximumZoomScale:2.0];
    [mainScrollView setZoomScale:MIN(minWidthScale, minHeightScale)];
    [mainScrollView setContentOffset:CGPointZero];
    
    AWBAppDelegate *delegate = (AWBAppDelegate *) [[UIApplication sharedApplication] delegate];
    delegate.signBackgroundSize = signBackgroundView.bounds.size;
    
    if (animateAndSave) {
        [UIView animateWithDuration:1.0 
                              delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                         animations: ^ {
                             [signBackgroundView setAlpha:1.0]; 
                         } 
                         completion: ^ (BOOL finished) {[self saveChanges:YES];}];        
    } else {
        [signBackgroundView setAlpha:1.0];
    }
    
    [pool drain];
}

- (void)awbSignBackgroundPickerView:(AWBSignBackgroundPickerView *)backgroundPicker didSelectSignBackground:(AWBRoadsignBackground *)signBackground
{
    [self updateSignBackground:signBackground willAnimateAndSave:YES];
}

- (void)updateSignBackground:(AWBRoadsignBackground *)signBackground willAnimateAndSave:(BOOL)animateAndSave
{
    self.selectedSignBackground = signBackground;
    self.labelTextColor = [UIColor foregroundColorWithBackgroundSignColorCode:signBackground.primaryColorCode];
    self.textBorderColor = [UIColor foregroundColorWithBackgroundSignColorCode:signBackground.primaryColorCode];
    self.textBackgroundColor = [UIColor backgroundColorWithBackgroundSignColorCode:signBackground.primaryColorCode];
    
    if ((signBackground.signBackgroundId >= 8000) && (signBackground.signBackgroundId < 9000)) {
        //clear blackground
        [self clearSignBackgroundWithSignId:signBackground.signBackgroundId willAnimateAndSave:animateAndSave];
    } else {
        NSString *filename = signBackground.fullsizeImageFilename;        
        [self updateSignBackgroundWithImageFromFile:filename willAnimateAndSave:animateAndSave];            
    }
    
}

- (void)clearSignBackgroundWithSignId:(NSUInteger)signBackgroundId willAnimateAndSave:(BOOL)animateAndSave
{    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [signBackgroundView setImage:nil];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat aspectRatio;
    if (screenSize.width < screenSize.height) {
        aspectRatio = screenSize.width / screenSize.height;
    } else {
        aspectRatio = screenSize.height / screenSize.width;
    }
    CGFloat backgroundViewWidth;
    CGFloat backgroundViewHeight;
    if (signBackgroundId == 8001) {
        backgroundViewHeight = 1400.0;
        backgroundViewWidth = aspectRatio * backgroundViewHeight;
    } else if (signBackgroundId == 8002) {
        backgroundViewWidth = 1400.0;
        backgroundViewHeight = aspectRatio * backgroundViewWidth;
    } else if (signBackgroundId == 8003) {
        backgroundViewWidth = 1400.0;
        backgroundViewHeight = 1400.0;        
    } else {
        backgroundViewWidth = 1400.0;
        backgroundViewHeight = 1400.0;                
    }
//    CGRect signBackgroundFrame = signBackgroundView.frame;
//    signBackgroundFrame.size.width = backgroundViewWidth;
//    signBackgroundFrame.size.height = backgroundViewHeight;
//    signBackgroundView.frame = signBackgroundFrame;
    signBackgroundView.bounds = CGRectMake(0.0, 0.0, backgroundViewWidth, backgroundViewHeight);
    //signBackgroundView.center = mainScrollView.center;
    
    [mainScrollView setContentSize:[signBackgroundView bounds].size];

    NSLog(@"mainScrollView: %f %f %f %f", mainScrollView.frame.origin.x, mainScrollView.frame.origin.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height);
    NSLog(@"signBackgroundView: %f %f %f %f", signBackgroundView.frame.origin.x, signBackgroundView.frame.origin.y, signBackgroundView.frame.size.width, signBackgroundView.frame.size.height);    
    NSLog(@"mainScrollView: %f %f %f %f", mainScrollView.bounds.origin.x, mainScrollView.bounds.origin.y, mainScrollView.bounds.size.width, mainScrollView.bounds.size.height);
    NSLog(@"signBackgroundView: %f %f %f %f", signBackgroundView.bounds.origin.x, signBackgroundView.bounds.origin.y, signBackgroundView.bounds.size.width, signBackgroundView.bounds.size.height);    

    float minWidthScale  = ((mainScrollView.bounds.size.width)  / signBackgroundView.bounds.size.width) * 0.96;
    float minHeightScale  = ((mainScrollView.bounds.size.height)  / signBackgroundView.bounds.size.height) * 0.96;
    
    NSLog(@"Scales: %f %f", minWidthScale, minHeightScale);
    
    [mainScrollView setMinimumZoomScale:MIN(minWidthScale, minHeightScale)];
    [mainScrollView setMaximumZoomScale:2.0];
    [mainScrollView setZoomScale:MIN(minWidthScale, minHeightScale)];
    [mainScrollView setContentOffset:CGPointZero];
    
    [self showSelectionMarquees];
    
    AWBAppDelegate *delegate = (AWBAppDelegate *) [[UIApplication sharedApplication] delegate];
    delegate.signBackgroundSize = signBackgroundView.bounds.size;
    
    if (animateAndSave) {
        //no animation at the moment
        [self saveChanges:YES];
    } 
    
    [pool drain];
}

@end
