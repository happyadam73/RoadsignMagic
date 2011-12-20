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
#import "AWBBusyView.h"
#import "AWBAppDelegate.h"

#define SNAP_TO_GRID_SIZE 32.0
#define DEFAULT_FONT_POINT_SIZE 160.0

enum {
    kAWBExportFormatIndexPNG = 0,
    kAWBExportFormatIndexJPEG = 1
};

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
    BOOL snapRotation;
    CGFloat snapToGridSize;
    CGFloat exportSize;    
    NSUInteger exportFormatSelectedIndex;
    BOOL pngExportTransparentBackground;
    CGFloat jpgExportQualityValue;
    UIColor *roadsignBackgroundColor;
    NSString *roadsignBackgroundTexture;
    BOOL useBackgroundTexture;
    NSString *labelTextLine1;
    NSString *labelTextLine2;
    NSString *labelTextLine3;
    UIColor *labelTextColor;
    NSString *labelTextFont;
    UITextAlignment labelTextAlignment;
    BOOL addTextBorders;
    BOOL textRoundedBorders;
    BOOL addTextBackground;
    UIColor *textBorderColor;
    UIColor *textBackgroundColor;

    BOOL isSignInEditMode;
    NSUInteger totalSelectedInEditMode;
    NSUInteger totalSelectedLabelsInEditMode; 
    NSUInteger totalLabelSubviews;
    NSUInteger totalSymbolSubviews;
    NSString *roadsignSaveDocumentsSubdirectory;
    BOOL roadsignLoadRequired;
    AWBRoadsignDescriptor *roadsignDescriptor;
    
    UIActionSheet *deleteConfirmationSheet;
    UIActionSheet *chooseActionTypeSheet;
    AWBBusyView *busyView;    
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
@property (nonatomic, retain) AWBLockedView *lockedView;
@property (nonatomic, assign) BOOL snapToGrid;
@property (nonatomic, assign) BOOL snapRotation;
@property (nonatomic, assign) CGFloat snapToGridSize;
@property (nonatomic, assign) CGFloat exportSize;
@property (nonatomic, retain) NSString *labelTextLine1;
@property (nonatomic, retain) NSString *labelTextLine2;
@property (nonatomic, retain) NSString *labelTextLine3;
@property (nonatomic, retain) UIColor *labelTextColor;
@property (nonatomic, retain) NSString *labelTextFont;
@property (nonatomic, assign) UITextAlignment labelTextAlignment;
@property (nonatomic, assign) BOOL addTextBorders;
@property (nonatomic, assign) BOOL textRoundedBorders;
@property (nonatomic, assign) BOOL addTextBackground;
@property (nonatomic, retain) UIColor *textBorderColor;
@property (nonatomic, retain) UIColor *textBackgroundColor;
@property (nonatomic, retain) AWBRoadsignBackground *selectedSignBackground;
@property (nonatomic, retain) AWBRoadsignSymbol *selectedSignSymbol;
@property (assign) BOOL isSignInEditMode;
@property (nonatomic, retain) UIActionSheet *deleteConfirmationSheet;
@property (nonatomic, retain) UIActionSheet *chooseActionTypeSheet;
@property (nonatomic, retain) AWBBusyView *busyView;
@property (nonatomic, retain) NSString *roadsignSaveDocumentsSubdirectory;
@property (nonatomic, assign) NSUInteger totalLabelSubviews;
@property (nonatomic, assign) NSUInteger totalSymbolSubviews;
@property (nonatomic, readonly) NSUInteger totalSubviews;
@property (nonatomic, assign) AWBRoadsignDescriptor *roadsignDescriptor;
@property (nonatomic, assign) NSUInteger exportFormatSelectedIndex;
@property (nonatomic, assign) BOOL pngExportTransparentBackground;
@property (nonatomic, assign) CGFloat jpgExportQualityValue;
@property (nonatomic, retain) UIColor *roadsignBackgroundColor;
@property (nonatomic, retain) NSString *roadsignBackgroundTexture;
@property (nonatomic, assign) BOOL useBackgroundTexture;

- (void) updateLayoutForNewOrientation: (UIInterfaceOrientation) orientation;
- (id)initWithRoadsignDescriptor:(AWBRoadsignDescriptor *)roadsign;
- (BOOL)saveChanges:(BOOL)saveThumbnail;
- (void)loadChanges;
- (NSString *)archivePath;
- (NSString *)thumbnailArchivePath;

@end


