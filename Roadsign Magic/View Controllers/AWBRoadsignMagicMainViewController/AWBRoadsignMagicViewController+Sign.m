//
//  AWBRoadsignMagicViewController+Sign.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicViewController+Sign.h"
#import "UIImage+NonCached.h"

@implementation AWBRoadsignMagicMainViewController (Sign)

- (void)initialiseSlideupView
{
    CGRect backgroundFrame = CGRectMake(0.0, self.view.bounds.size.height-(self.navigationController.toolbar.bounds.size.height)-180.0, self.view.bounds.size.width, 180);
    AWBSignBackgroundPickerView *backgroundView = [[AWBSignBackgroundPickerView alloc] initWithFrame:backgroundFrame];
    backgroundView.delegate = self;
    self.slideUpView = backgroundView;
	[self.view addSubview:backgroundView];
    [backgroundView release];
}

- (void)updateSignBackgroundWithImageFromFile:(NSString *)name 
{    
    UIImage *image = [UIImage imageFromFile:name];
    [signBackgroundView setImage:image];
    [signBackgroundView sizeToFit];
    signBackgroundView.alpha = 0.0;
    [mainScrollView setContentSize:[signBackgroundView bounds].size];
    float minWidthScale  = ((mainScrollView.bounds.size.width)  / signBackgroundView.bounds.size.width) * 0.96;
    float minHeightScale  = ((mainScrollView.bounds.size.height)  / signBackgroundView.bounds.size.height) * 0.96;
    [mainScrollView setMinimumZoomScale:MIN(minWidthScale, minHeightScale)];
    [mainScrollView setMaximumZoomScale:2.0];
    [mainScrollView setZoomScale:MIN(minWidthScale, minHeightScale)];
    [mainScrollView setContentOffset:CGPointZero];
    
    [UIView animateWithDuration:1.0 
                          delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations: ^ {
                         [signBackgroundView setAlpha:1.0]; 
                     } 
                     completion: ^ (BOOL finished) {}];    
}

- (void)awbSignBackgroundPickerView:(AWBSignBackgroundPickerView *)backgroundPicker didSelectSignBackground:(AWBRoadsignBackground *)signBackground
{
    self.selectedSignBackground = signBackground;
    self.labelTextColor = [UIColor foregroundColorWithBackgroundSignColorCode:signBackground.primaryColorCode];
    NSString *filename = signBackground.fullsizeImageFilename;        
    [self updateSignBackgroundWithImageFromFile:filename];
}

@end
