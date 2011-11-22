//
//  AWBRoadsignMagicMainViewController.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 20/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface AWBRoadsignMagicMainViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView *mainScrollView;
    
    UIBarButtonItem *signBackgroundPickerButton;
    UIBarButtonItem *textButton;
    UIBarButtonItem *toolbarSpacing;
    iCarousel *carouselSubcategory;
    iCarousel *carouselCategory;
    UIView *slideUpView;
    NSMutableArray *items;
    NSUInteger selectedCategory;
    BOOL thumbViewShowing;
}

@property (nonatomic, retain) UIBarButtonItem *signBackgroundPickerButton;
@property (nonatomic, retain) UIBarButtonItem *textButton;
@property (nonatomic, retain) UIBarButtonItem *toolbarSpacing;
@property (nonatomic, retain) iCarousel *carouselSubcategory;
@property (nonatomic, retain) iCarousel *carouselCategory;
@property (nonatomic, retain) UIView *slideUpView;
@property (nonatomic, retain) NSMutableArray *items;

@end

@interface AWBRoadsignMagicMainViewController (ViewHandlingMethods)
- (void)pickImageNamed:(NSString *)name;
- (NSArray *)normalToolbarButtons;
@end
