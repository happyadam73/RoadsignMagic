//
//  AWBRoadsignMagicMainViewController.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 20/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "ZFont.h"
#import <QuartzCore/QuartzCore.h>
#import "AWBRoadsignBackground.h"
#import "AWBLockedView.h"
#import "AWBSignBackgroundPickerView.h"
#import "AWBSignSymbolPickerView.h"
#import "AWBRoadsignDescriptor.h"

#define SNAP_TO_GRID_SIZE 32.0
#define DEFAULT_FONT_POINT_SIZE 80.0

@interface AWBRoadsignMagicMainViewController : UIViewController <AWBLockedViewDelegate>
{    
    UIScrollView *mainScrollView;
    UIImageView *signBackgroundView;
    AWBSignBackgroundPickerView *signBackgroundPickerView;
    AWBSignSymbolPickerView *signSymbolPickerView;    
    BOOL signBackgroundPickerViewShowing;
    BOOL signSymbolPickerViewShowing;
    
    UIBarButtonItem *signBackgroundPickerButton;
    UIBarButtonItem *textButton;
    UIBarButtonItem *toolbarSpacing;
    UIBarButtonItem *editButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *editTextButton;
    UIBarButtonItem *selectNoneOrAllButton;    
    UIBarButtonItem *signSymbolPickerButton;
    UIBarButtonItem *actionButton;
    UIBarButtonItem *settingsButton;
    UIBarButtonItem *fixedToolbarSpacing;
        
    AWBRoadsignBackground *selectedSignBackground;
    AWBRoadsignSymbol *selectedSignSymbol;
    
    ZFont *roadsignFont;
    
    UIRotationGestureRecognizer *rotationGestureRecognizer;
    UIPanGestureRecognizer *panGestureRecognizer;
    UIPinchGestureRecognizer *pinchGestureRecognizer;
    UITapGestureRecognizer *singleTapGestureRecognizer;
    UITapGestureRecognizer *doubleTapGestureRecognizer;
    UISwipeGestureRecognizer *swipeGestureRecognizer;
    UILongPressGestureRecognizer *longPressGestureRecognizer;
    UILongPressGestureRecognizer *longDoublePressGestureRecognizer;
    
    UIView <AWBTransformableView> *capturedView;
    CGPoint capturedCenterOffset;
    BOOL currentlyPinching;
    BOOL currentlyRotating;
    
    AWBLockedView *lockedView;
    BOOL snapToGrid;
    CGFloat snapToGridSize;
    CGFloat exportQuality;
    
    NSString *labelTextLine1;
    NSString *labelTextLine2;
    NSString *labelTextLine3;
    UIColor *labelTextColor;
    NSString *labelTextFont;
    UITextAlignment labelTextAlignment;
    
    BOOL isSignInEditMode;
    NSUInteger totalSelectedInEditMode;
    NSUInteger totalSelectedLabelsInEditMode; 
    NSUInteger totalLabelSubviews;
    NSUInteger totalImageSubviews;
    NSString *roadsignSaveDocumentsSubdirectory;
    BOOL roadsignLoadRequired;
    AWBRoadsignDescriptor *roadsignDescriptor;
    
    UIActionSheet *deleteConfirmationSheet;
}

@property (nonatomic, retain) UIBarButtonItem *signBackgroundPickerButton;
@property (nonatomic, retain) UIBarButtonItem *textButton;
@property (nonatomic, retain) UIBarButtonItem *toolbarSpacing;
@property (nonatomic, retain) UIBarButtonItem *editButton;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (nonatomic, retain) UIBarButtonItem *deleteButton;
@property (nonatomic, retain) UIBarButtonItem *editTextButton;
@property (nonatomic, retain) UIBarButtonItem *selectNoneOrAllButton;    
@property (nonatomic, retain) UIBarButtonItem *signSymbolPickerButton;
@property (nonatomic, retain) UIBarButtonItem *actionButton;
@property (nonatomic, retain) UIBarButtonItem *settingsButton;
@property (nonatomic, retain) UIBarButtonItem *fixedToolbarSpacing;
@property (nonatomic, retain) AWBSignBackgroundPickerView *signBackgroundPickerView;
@property (nonatomic, retain) AWBSignSymbolPickerView *signSymbolPickerView;  
@property (nonatomic, retain) UIImageView *signBackgroundView;
@property (nonatomic, retain) UIScrollView *mainScrollView;
@property (nonatomic, retain) UIRotationGestureRecognizer *rotationGestureRecognizer;
@property (nonatomic, retain) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, retain) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, retain) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, retain) UILongPressGestureRecognizer *longDoublePressGestureRecognizer;
@property (nonatomic, retain) ZFont *roadsignFont;
@property (nonatomic, retain) AWBLockedView *lockedView;
@property (nonatomic, assign) BOOL snapToGrid;
@property (nonatomic, assign) CGFloat snapToGridSize;
@property (nonatomic, assign) CGFloat exportQuality;
@property (nonatomic, retain) NSString *labelTextLine1;
@property (nonatomic, retain) NSString *labelTextLine2;
@property (nonatomic, retain) NSString *labelTextLine3;
@property (nonatomic, retain) UIColor *labelTextColor;
@property (nonatomic, retain) NSString *labelTextFont;
@property (nonatomic, assign) UITextAlignment labelTextAlignment;
@property (nonatomic, retain) AWBRoadsignBackground *selectedSignBackground;
@property (nonatomic, retain) AWBRoadsignSymbol *selectedSignSymbol;
@property (assign) BOOL isSignInEditMode;
@property (nonatomic, retain) UIActionSheet *deleteConfirmationSheet;
@property (nonatomic, retain) NSString *roadsignSaveDocumentsSubdirectory;
@property (nonatomic, readonly) NSUInteger totalLabelSubviews;
@property (nonatomic, readonly) NSUInteger totalImageSubviews;
@property (nonatomic, assign) AWBRoadsignDescriptor *roadsignDescriptor;

- (BOOL)saveChanges:(BOOL)saveThumbnail;
- (void)loadChanges;
- (NSString *)archivePath;
- (NSString *)thumbnailArchivePath;

@end


