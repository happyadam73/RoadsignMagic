//
//  AWBRoadsignMagicMainViewController.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 20/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "ZFont.h"
#import <QuartzCore/QuartzCore.h>

@interface AWBRoadsignMagicMainViewController : UIViewController 
{    
    UIScrollView *mainScrollView;
    UIImageView *signBackgroundView;
    iCarousel *carouselSubcategory;
    iCarousel *carouselCategory;
    UIView *slideUpView;
    
    UIBarButtonItem *signBackgroundPickerButton;
    UIBarButtonItem *textButton;
    UIBarButtonItem *toolbarSpacing;
    UIBarButtonItem *editButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *editTextButton;
    UIBarButtonItem *selectNoneOrAllButton;    
    UIBarButtonItem *addSymbolButton;
    UIBarButtonItem *actionButton;
    UIBarButtonItem *settingsButton;
    UIBarButtonItem *fixedToolbarSpacing;
        
    NSMutableArray *signBackgroundItems;
    NSArray *signBackgroundCategories;
    NSUInteger selectedSignBackgroundCategory;
    BOOL thumbViewShowing;
    ZFont *roadsignFont;
    
    UIRotationGestureRecognizer *rotationGestureRecognizer;
    UIPanGestureRecognizer *panGestureRecognizer;
    UIPinchGestureRecognizer *pinchGestureRecognizer;
    UITapGestureRecognizer *singleTapGestureRecognizer;
    UITapGestureRecognizer *doubleTapGestureRecognizer;
    UISwipeGestureRecognizer *swipeGestureRecognizer;
    UILongPressGestureRecognizer *longPressGestureRecognizer;
    UIView <AWBTransformableView> *capturedView;
    CGPoint capturedCenterOffset;
    
    CAShapeLayer *selectionMarquee;
    CAShapeLayer *selectionMarquee2;
    UIImageView *lockedView;
    BOOL scrollLocked;
    BOOL snapToGrid;
    CGFloat snapToGridSize;
    BOOL lockCanvas;
    CGFloat exportQuality;
    
    NSString *labelTextLine1;
    NSString *labelTextLine2;
    NSString *labelTextLine3;
    UIColor *labelTextColor;
    NSString *labelTextFont;
    UITextAlignment labelTextAlignment;
    
    NSUInteger totalSelectedInEditMode;
    NSUInteger totalSelectedLabelsInEditMode; 
    NSUInteger totalLabelSubviews;
}

@property (nonatomic, retain) UIBarButtonItem *signBackgroundPickerButton;
@property (nonatomic, retain) UIBarButtonItem *textButton;
@property (nonatomic, retain) UIBarButtonItem *toolbarSpacing;
@property (nonatomic, retain) UIBarButtonItem *editButton;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (nonatomic, retain) UIBarButtonItem *deleteButton;
@property (nonatomic, retain) UIBarButtonItem *editTextButton;
@property (nonatomic, retain) UIBarButtonItem *selectNoneOrAllButton;    
@property (nonatomic, retain) UIBarButtonItem *addSymbolButton;
@property (nonatomic, retain) UIBarButtonItem *actionButton;
@property (nonatomic, retain) UIBarButtonItem *settingsButton;
@property (nonatomic, retain) UIBarButtonItem *fixedToolbarSpacing;
@property (nonatomic, retain) iCarousel *carouselSubcategory;
@property (nonatomic, retain) iCarousel *carouselCategory;
@property (nonatomic, retain) UIView *slideUpView;
@property (nonatomic, retain) NSMutableArray *signBackgroundItems;
@property (nonatomic, retain) NSArray *signBackgroundCategories;
@property (nonatomic, retain) UIImageView *signBackgroundView;
@property (nonatomic, retain) UIScrollView *mainScrollView;
@property (nonatomic, retain) UIRotationGestureRecognizer *rotationGestureRecognizer;
@property (nonatomic, retain) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, retain) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, retain) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, retain) ZFont *roadsignFont;
@property (nonatomic, retain) CAShapeLayer *selectionMarquee;
@property (nonatomic, retain) CAShapeLayer *selectionMarquee2;
@property (nonatomic, assign) BOOL scrollLocked;
@property (nonatomic, assign) BOOL snapToGrid;
@property (nonatomic, assign) CGFloat snapToGridSize;
@property (nonatomic, assign) BOOL lockCanvas;
@property (nonatomic, assign) CGFloat exportQuality;
@property (nonatomic, retain) NSString *labelTextLine1;
@property (nonatomic, retain) NSString *labelTextLine2;
@property (nonatomic, retain) NSString *labelTextLine3;
@property (nonatomic, retain) UIColor *labelTextColor;
@property (nonatomic, retain) NSString *labelTextFont;
@property (nonatomic, assign) UITextAlignment labelTextAlignment;

@end


