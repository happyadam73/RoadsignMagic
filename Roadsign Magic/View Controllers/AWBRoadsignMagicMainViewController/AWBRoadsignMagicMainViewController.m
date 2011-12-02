//
//  AWBRoadsignMagicMainViewController.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 20/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+NonCached.h"
#import "FontLabel.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"
#import "AWBRoadsignMagicMainViewController+Gestures.h"
#import "FontManager.h"
#import "AWBTransformableZFontLabel.h"
#import "AWBRoadsignMagicMainViewController+Toolbar.h"
#import "AWBRoadsignMagicMainViewController+UI.h"
#import "UIView+SelectionMarquee.h"

@implementation AWBRoadsignMagicMainViewController

@synthesize mainScrollView, signBackgroundView;
@synthesize signBackgroundPickerButton, toolbarSpacing, textButton, editButton, editTextButton, cancelButton, deleteButton, selectNoneOrAllButton, signSymbolPickerButton, actionButton, settingsButton, fixedToolbarSpacing;
@synthesize signBackgroundPickerView, signSymbolPickerView; 
@synthesize rotationGestureRecognizer, panGestureRecognizer, pinchGestureRecognizer, singleTapGestureRecognizer, doubleTapGestureRecognizer, swipeGestureRecognizer, longPressGestureRecognizer, longDoublePressGestureRecognizer;
@synthesize roadsignFont; 
@synthesize labelTextColor, labelTextFont, labelTextLine1, labelTextLine2, labelTextLine3, labelTextAlignment;
@synthesize exportQuality, snapToGrid, snapToGridSize, lockedView;
@synthesize selectedSignBackground, selectedSignSymbol, isSignInEditMode;
@synthesize deleteConfirmationSheet;

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.isSignInEditMode) {
        self.toolbarItems = [self normalToolbarButtons];
        self.navigationItem.rightBarButtonItem = self.editButton;
    }    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self dereferenceGestureRecognizers];
    self.lockedView = nil;
    self.roadsignFont = nil;
    self.signBackgroundView = nil;
    self.mainScrollView = nil;
    self.signBackgroundPickerView = nil;
    self.signSymbolPickerView = nil;
    self.signBackgroundPickerButton = nil;
    self.toolbarSpacing = nil;
    self.textButton = nil;    
    self.editButton = nil;
    self.editTextButton = nil;
    self.cancelButton = nil;
    self.deleteButton = nil;
    self.selectNoneOrAllButton = nil;
    self.signSymbolPickerButton = nil;
    self.actionButton = nil;
    self.settingsButton = nil;
    self.fixedToolbarSpacing = nil;
    self.labelTextColor = nil;
    self.labelTextFont = nil;
    self.labelTextLine1 = nil;
    self.labelTextLine2 = nil;
    self.labelTextLine3 = nil;
    self.deleteConfirmationSheet = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    snapToGrid = YES;
    snapToGridSize = SNAP_TO_GRID_SIZE;
    labelTextAlignment = UITextAlignmentCenter;
    [self initialiseGestureRecognizers];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{    
    mainScrollView.contentSize = signBackgroundView.bounds.size;    
    float minWidthScale  = ((mainScrollView.bounds.size.width)  / signBackgroundView.bounds.size.width) * 0.96;
    float minHeightScale  = ((mainScrollView.bounds.size.height)  / signBackgroundView.bounds.size.height) * 0.96;    
    float currentZoomScale = mainScrollView.zoomScale;
    BOOL currentZoomScaleIsMin = (currentZoomScale == mainScrollView.minimumZoomScale);
    [mainScrollView setMinimumZoomScale:MIN(minWidthScale, minHeightScale)];
    float newScale = ((currentZoomScaleIsMin || (currentZoomScale <= mainScrollView.minimumZoomScale)) ? mainScrollView.minimumZoomScale : currentZoomScale);
    [mainScrollView setZoomScale:newScale];
    [self scrollViewDidZoom:mainScrollView];
        
    if (signBackgroundPickerView) {        
        CGRect frame = signBackgroundPickerView.frame;
        if (signBackgroundPickerViewShowing) {
            frame.origin.y = (self.view.bounds.size.height - self.navigationController.toolbar.bounds.size.height - frame.size.height);            
        } else {
            frame.origin.y = (self.view.bounds.size.height);                        
        }
        signBackgroundPickerView.frame = frame;
    }
    
}

- (void)loadView {
    [super loadView];
    
    ZFont *font = [[FontManager sharedManager] zFontWithName:@"BritishRoadsign" pointSize:DEFAULT_FONT_POINT_SIZE];
    //ZFont *font = [ZFont fontWithUIFont:[UIFont fontWithName:@"Thonburi-Bold" size:DEFAULT_FONT_POINT_SIZE]];
    
    self.roadsignFont = font;
    currentlyPinching = NO;
    currentlyRotating = NO;
    
    self.wantsFullScreenLayout = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageFromFile:@"concrete.jpg"]];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
    [scrollView setDelegate:self];
    [scrollView setBouncesZoom:YES];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.canCancelContentTouches = NO;
    scrollView.scrollEnabled = NO;
    self.mainScrollView = scrollView;
    [scrollView release];
    [[self view] addSubview:self.mainScrollView];
    
    //UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.mainScrollView.bounds];
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1400.0, 1400.0)];
    backgroundView.userInteractionEnabled = YES;
    self.signBackgroundView = backgroundView;
    [self.mainScrollView addSubview:self.signBackgroundView];
    [backgroundView release];
    
    [mainScrollView setContentSize:[signBackgroundView bounds].size];
    float minWidthScale  = ((mainScrollView.bounds.size.width)  / signBackgroundView.bounds.size.width) * 0.96;
    float minHeightScale  = ((mainScrollView.bounds.size.height)  / signBackgroundView.bounds.size.height) * 0.96;
    [mainScrollView setMinimumZoomScale:MIN(minWidthScale, minHeightScale)];
    [mainScrollView setMaximumZoomScale:2.0];
    [mainScrollView setZoomScale:MIN(minWidthScale, minHeightScale)];
    [mainScrollView setContentOffset:CGPointZero];

    AWBLockedView *view = [[AWBLockedView alloc] initWithObjectsLocked:NO canvasAnchored:!scrollView.scrollEnabled];
    self.lockedView = view;
    self.lockedView.delegate = self;
    [view release];
    self.navigationItem.titleView = lockedView;
    
}

- (void)dealloc {
     [self deallocGestureRecognizers];
    [selectedSignBackground release];
    [selectedSignSymbol release];
    [roadsignFont release];
    [signBackgroundPickerView release];
    [signSymbolPickerView release];
    [toolbarSpacing release];
    [editButton release];
    [editTextButton release];
    [cancelButton release];
    [deleteButton release];
    [selectNoneOrAllButton release];
    [signSymbolPickerButton release];
    [actionButton release];
    [settingsButton release];
    [fixedToolbarSpacing release];
    [signBackgroundPickerButton release];
    [mainScrollView release];
    [signBackgroundView release];
    [textButton release];
    [labelTextColor release];
    [labelTextFont release];
    [labelTextLine1 release];
    [labelTextLine2 release];
    [labelTextLine3 release];
    [lockedView release];
    [deleteConfirmationSheet release];
    [super dealloc];
}

- (void)awbLockedView:(AWBLockedView *)lockedView didSetAnchor:(BOOL)anchored
{
    self.mainScrollView.scrollEnabled = !anchored;
}

@end
