//
//  AWBRoadsignMagicMainViewController.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 20/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
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
#import "AWBRoadsign.h"
#import "AWBRoadsignStore.h"
#import "FileHelpers.h"
#import "AWBRoadsignMagicViewController+Sign.h"

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
@synthesize totalImageSubviews, totalLabelSubviews, roadsignDescriptor, roadsignSaveDocumentsSubdirectory;

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
    self.roadsignSaveDocumentsSubdirectory = @"Roadsign 1";
    [self initialiseGestureRecognizers];
    [self loadChanges];
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

- (BOOL)saveChanges:(BOOL)saveThumbnail
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    BOOL success = NO;
    
    if (self.signBackgroundView) {
        
        //if excessive objects, then reset the selected collage index
        //trying to avoid memory crash when loading the app
//        if (self.excessiveSubviewCount) {
//            [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:kAWBInfoKeyCollageStoreCollageIndex];
//        }
        
        AWBRoadsign *roadsign = [[AWBRoadsign alloc] init];
        roadsign.roadsignBackgroundId = self.selectedSignBackground.signBackgroundId;
        roadsign.exportQuality = exportQuality;
        
        [roadsign initRoadsignFromView:self.signBackgroundView];
        
        self.roadsignDescriptor.totalImageObjects = self.totalImageSubviews;
        self.roadsignDescriptor.totalLabelObjects = self.totalLabelSubviews;
        self.roadsignDescriptor.totalImageMemoryBytes = roadsign.totalImageMemoryBytes;
        [[AWBRoadsignStore defaultStore] saveAllRoadsigns];
        
        success = [NSKeyedArchiver archiveRootObject:roadsign toFile:[self archivePath]];
        [roadsign release];
        
        if (saveThumbnail) {
            CGSize signSize = self.signBackgroundView.bounds.size;
            CGFloat scale = MIN((256.0/signSize.width), (192.0/signSize.height));
            //UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, scale);
            UIGraphicsBeginImageContextWithOptions(signSize, NO, scale);
            [self.signBackgroundView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *roadsignImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            //NSData *imageData = UIImageJPEGRepresentation(roadsignImage, 0.5);
            NSData *imageData = UIImagePNGRepresentation(roadsignImage);
            [imageData writeToFile:[self thumbnailArchivePath] atomically:YES];
        }
    }
    [pool drain];
    return success;
}

- (void)loadChanges
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *path = [self archivePath];
    AWBRoadsign *roadsign = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (roadsign) {
        AWBRoadsignBackground *signBackground = [AWBRoadsignBackground signBackgroundWithIdentifier:roadsign.roadsignBackgroundId];
        [self awbSignBackgroundPickerView:nil didSelectSignBackground:signBackground];
        
        [roadsign addRoadsignToView:self.signBackgroundView];
       
        totalImageSubviews = roadsign.totalImageSubviews;
        totalLabelSubviews = roadsign.totalLabelSubviews;
        self.exportQuality = roadsign.exportQuality;
    }
    
    [pool drain];
}

- (NSString *)archivePath
{
    return AWBPathInDocumentSubdirectory(roadsignSaveDocumentsSubdirectory, @"roadsign.data");
}

- (NSString *)thumbnailArchivePath
{
    return AWBPathInDocumentSubdirectory(roadsignSaveDocumentsSubdirectory, @"thumbnail.png");
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
    [roadsignSaveDocumentsSubdirectory release];
    [super dealloc];
}

- (void)awbLockedView:(AWBLockedView *)lockedView didSetAnchor:(BOOL)anchored
{
    self.mainScrollView.scrollEnabled = !anchored;
}

@end
