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
#import "AWBTransformableAnyFontLabel.h"
#import "AWBRoadsignMagicMainViewController+Toolbar.h"
#import "AWBRoadsignMagicMainViewController+UI.h"
#import "UIView+SelectionMarquee.h"
#import "AWBRoadsign.h"
#import "AWBRoadsignStore.h"
#import "FileHelpers.h"
#import "AWBRoadsignMagicViewController+Sign.h"
#import "AWBRoadsignMagicViewController+Edit.h"
#import "UIColor+Texture.h"

@implementation AWBRoadsignMagicMainViewController

@synthesize mainScrollView, signBackgroundView;
@synthesize signBackgroundPickerButton, toolbarSpacing, textButton, editButton, editTextButton, cancelButton, deleteButton, selectNoneOrAllButton, signSymbolPickerButton, actionButton, settingsButton, fixedToolbarSpacing;
@synthesize signBackgroundPickerView, signSymbolPickerView; 
@synthesize rotationGestureRecognizer, panGestureRecognizer, pinchGestureRecognizer, singleTapGestureRecognizer, doubleTapGestureRecognizer, doubleDoubleTapGestureRecognizer, swipeGestureRecognizer, longPressGestureRecognizer, longDoublePressGestureRecognizer;
@synthesize labelTextColor, labelTextFont, labelTextLine1, labelTextLine2, labelTextLine3, labelTextAlignment;
@synthesize addTextBorders, addTextBackground, textRoundedBorders, textBorderColor, textBackgroundColor;
@synthesize exportSize, snapToGrid, snapRotation, snapToGridSize, lockedView;
@synthesize selectedSignBackground, selectedSignSymbol, isSignInEditMode;
@synthesize deleteConfirmationSheet, chooseActionTypeSheet, busyView;
@synthesize totalSymbolSubviews, totalLabelSubviews, totalSubviews, roadsignDescriptor, roadsignSaveDocumentsSubdirectory;
@synthesize exportFormatSelectedIndex, pngExportTransparentBackground, jpgExportQualityValue;
@synthesize roadsignBackgroundTexture, roadsignBackgroundColor, useBackgroundTexture;
@synthesize useMyFonts, labelMyFont;

- (id)init
{
    AWBRoadsignDescriptor *roadsign = [[AWBRoadsignStore defaultStore] createMyRoadsign];
    return [self initWithRoadsignDescriptor:roadsign];
}

- (id)initWithRoadsignDescriptor:(AWBRoadsignDescriptor *)roadsign
{
    self = [super init];
    if (self) {  
        
        AWBAppDelegate *delegate = (AWBAppDelegate *)[[UIApplication sharedApplication] delegate];
        facebook = [delegate facebook];
        self.roadsignDescriptor = roadsign;
        [self setRoadsignSaveDocumentsSubdirectory:roadsign.roadsignSaveDocumentsSubdirectory];
        self.snapToGrid = NO;
        self.snapRotation = YES;
        self.snapToGridSize = SNAP_TO_GRID_SIZE;
        self.labelTextAlignment = UITextAlignmentCenter;
        self.exportSize = 1.0;
        self.isSignInEditMode = NO;
        self.exportFormatSelectedIndex = kAWBExportFormatIndexPNG;
        self.pngExportTransparentBackground = YES;
        self.jpgExportQualityValue = 0.7;
        self.roadsignBackgroundColor = [UIColor yellowSignBackgroundColor];
        self.roadsignBackgroundTexture = @"Metal";
        self.useBackgroundTexture = YES;  
        self.labelTextFont = @"BritishRoadsign";
        self.labelMyFont = nil;
        self.useMyFonts = NO;
        self.addTextBorders = NO;
        self.addTextBackground = NO;
        self.textRoundedBorders = YES;
        self.textBorderColor = [UIColor blackColor];
        self.textBackgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!self.isSignInEditMode) {
        self.toolbarItems = [self normalToolbarButtons];
        if (self.totalSubviews > 0) {
            [self.navigationItem setRightBarButtonItem:self.editButton animated:YES];
        } else {
            [self.navigationItem setRightBarButtonItem:nil animated:YES];
        }        
        if (self.navigationController.toolbarHidden) {
            [self toggleFullscreen];
        }
    }  
    
    if (!self.modalViewController) {
        if (roadsignLoadRequired) {
            roadsignLoadRequired = NO;
            [self loadChanges];
        }        
    } else {
        [self updateLayoutForNewOrientation:self.interfaceOrientation];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    facebook.sessionDelegate = self;
    if (self.busyView) {
        [self.busyView removeFromParentView];
        self.busyView = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (!self.modalViewController) {
        [self resetEditMode:nil];
        BOOL saveThumbnail = YES;
//        if (self.excessiveSubviewCount) {
//            saveThumbnail = NO;
//        }
        [self saveChanges:saveThumbnail];
    }
    [super viewWillDisappear:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self dereferenceGestureRecognizers];
    
    facebook.sessionDelegate = nil;
    if (currentFacebookRequest) {
        currentFacebookRequest.delegate = nil;
    }
    
    self.selectedSignBackground = nil;
    self.selectedSignSymbol = nil;
    self.lockedView = nil;
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
    self.labelMyFont = nil;
    self.labelTextLine1 = nil;
    self.labelTextLine2 = nil;
    self.labelTextLine3 = nil;
    self.deleteConfirmationSheet = nil;
    self.chooseActionTypeSheet = nil;
    self.roadsignBackgroundTexture = nil;
    self.roadsignBackgroundColor = nil;
    self.busyView = nil;
    self.textBorderColor = nil;
    self.textBackgroundColor = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialiseGestureRecognizers];
    roadsignLoadRequired = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{    
    [self updateLayoutForNewOrientation:toInterfaceOrientation];
}

- (void) updateLayoutForNewOrientation: (UIInterfaceOrientation) orientation 
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
                
    currentlyPinching = NO;
    currentlyRotating = NO;
    
    self.wantsFullScreenLayout = YES;
    if (self.useBackgroundTexture && self.roadsignBackgroundTexture) {
        self.view.backgroundColor = [UIColor textureColorWithDescription:self.roadsignBackgroundTexture];
    } else {
        if (self.roadsignBackgroundColor) {
            self.view.backgroundColor = self.roadsignBackgroundColor;
        }            
    }
    
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
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1400.0, 1400.0)];
    backgroundView.userInteractionEnabled = YES;
    self.signBackgroundView = backgroundView;
    AWBAppDelegate *delegate = (AWBAppDelegate *) [[UIApplication sharedApplication] delegate];
    delegate.signBackgroundSize = signBackgroundView.bounds.size;
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
    self.navigationItem.titleView = lockedView;
    [view release];
    
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
        if (self.selectedSignBackground) {
            roadsign.roadsignBackgroundId = self.selectedSignBackground.signBackgroundId;
        } else {
            roadsign.roadsignBackgroundId = 0;            
        }
        roadsign.exportSize = exportSize;
        roadsign.objectsLocked = lockedView.objectsLocked;
        roadsign.canvasAnchored = lockedView.canvasAnchored;
        roadsign.snapToGrid = snapToGrid;
        roadsign.snapRotation = snapRotation;
        roadsign.snapToGridSize = snapToGridSize;
        roadsign.exportFormatSelectedIndex = exportFormatSelectedIndex;
        roadsign.pngExportTransparentBackground = pngExportTransparentBackground;
        roadsign.jpgExportQualityValue = jpgExportQualityValue;
        roadsign.labelTextLine1 = labelTextLine1;
        roadsign.labelTextLine2 = labelTextLine2;
        roadsign.labelTextLine3 = labelTextLine3;
        roadsign.labelTextColor = labelTextColor;
        roadsign.labelTextFont = labelTextFont;
        roadsign.labelMyFont = labelMyFont;
        roadsign.useMyFonts = useMyFonts;
        roadsign.labelTextAlignment = labelTextAlignment;
        roadsign.roadsignBackgroundColor = roadsignBackgroundColor;
        roadsign.roadsignBackgroundTexture = roadsignBackgroundTexture;
        roadsign.useBackgroundTexture = useBackgroundTexture;
        roadsign.addTextBorders  = addTextBorders;
        roadsign.textRoundedBorders = textRoundedBorders;
        roadsign.textBorderColor = textBorderColor;
        roadsign.addTextBackground = addTextBackground;
        roadsign.textBackgroundColor = textBackgroundColor;
        
        [roadsign initRoadsignFromView:self.signBackgroundView];
        
        self.roadsignDescriptor.totalSymbolObjects = self.totalSymbolSubviews;
        self.roadsignDescriptor.totalLabelObjects = self.totalLabelSubviews;
        self.roadsignDescriptor.totalImageMemoryBytes = roadsign.totalImageMemoryBytes;
        [[AWBRoadsignStore defaultStore] saveMyRoadsigns];
        
        success = [NSKeyedArchiver archiveRootObject:roadsign toFile:[self archivePath]];
        [roadsign release];
        
        if (saveThumbnail) {
            CGSize signSize = self.signBackgroundView.bounds.size;
            CGFloat scale = MIN((256.0/signSize.width), (192.0/signSize.height));
            UIGraphicsBeginImageContextWithOptions(signSize, NO, scale);
            [self.signBackgroundView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *roadsignImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
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
        NSUInteger signBackgroundId = roadsign.roadsignBackgroundId;
        if (signBackgroundId > 0) {
            AWBRoadsignBackground *signBackground = [AWBRoadsignBackground signBackgroundWithIdentifier:signBackgroundId];
            [self updateSignBackground:signBackground willAnimateAndSave:NO];
        }
        
        self.exportSize = roadsign.exportSize;
        self.lockedView.objectsLocked = roadsign.objectsLocked;
        self.lockedView.canvasAnchored = roadsign.canvasAnchored;
        self.snapToGrid = roadsign.snapToGrid;
        self.snapRotation = roadsign.snapRotation;
        self.snapToGridSize = roadsign.snapToGridSize;
        self.exportFormatSelectedIndex = roadsign.exportFormatSelectedIndex;
        self.pngExportTransparentBackground = roadsign.pngExportTransparentBackground;
        self.jpgExportQualityValue = roadsign.jpgExportQualityValue;
        self.useBackgroundTexture = roadsign.useBackgroundTexture;
        self.labelTextAlignment = roadsign.labelTextAlignment;
        self.addTextBorders = roadsign.addTextBorders;
        self.textRoundedBorders = roadsign.textRoundedBorders;
        self.addTextBackground = roadsign.addTextBackground;
        self.useMyFonts = roadsign.useMyFonts;
        
        if (roadsign.roadsignBackgroundColor) {
            self.roadsignBackgroundColor = roadsign.roadsignBackgroundColor;
        }
        if (roadsign.roadsignBackgroundColor) {
            self.roadsignBackgroundTexture = roadsign.roadsignBackgroundTexture;
        }
        if (roadsign.labelTextLine1) {
            self.labelTextLine1 = roadsign.labelTextLine1;
        }
        if (roadsign.labelTextLine2) {
            self.labelTextLine2 = roadsign.labelTextLine2;
        }
        if (roadsign.labelTextLine3) {
            self.labelTextLine3 = roadsign.labelTextLine3;
        }
        if (roadsign.labelTextColor) {
            self.labelTextColor = roadsign.labelTextColor;
        }
        if (roadsign.labelTextFont) {
            self.labelTextFont = roadsign.labelTextFont;
        }
        if (roadsign.labelMyFont) {
            self.labelMyFont = roadsign.labelMyFont;
        }        
        if (roadsign.textBorderColor) {
            self.textBorderColor = roadsign.textBorderColor;
        }   
        if (roadsign.textBackgroundColor) {
            self.textBackgroundColor = roadsign.textBackgroundColor;
        }

        if (self.useBackgroundTexture && self.roadsignBackgroundTexture) {
            self.view.backgroundColor = [UIColor textureColorWithDescription:self.roadsignBackgroundTexture];
        } else {
            if (self.roadsignBackgroundColor) {
                self.view.backgroundColor = self.roadsignBackgroundColor;
            }            
        }
        
        [roadsign addRoadsignToView:self.signBackgroundView];
        
        self.totalSymbolSubviews = roadsign.totalSymbols;
        self.totalLabelSubviews = roadsign.totalLabels;
    }
    
    [pool drain];
}

- (NSUInteger)totalSubviews
{
    return (totalLabelSubviews + totalSymbolSubviews);
}

- (void)setTotalLabelSubviews:(NSUInteger)total
{
    totalLabelSubviews = total;
    if (self.totalSubviews > 0) {
        [self.navigationItem setRightBarButtonItem:self.editButton animated:YES];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

- (void)setTotalSymbolSubviews:(NSUInteger)total
{
    totalSymbolSubviews = total;
    if (self.totalSubviews > 0) {
        [self.navigationItem setRightBarButtonItem:self.editButton animated:YES];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
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
    facebook.sessionDelegate = nil;
    if (currentFacebookRequest) {
        currentFacebookRequest.delegate = nil;
    }
    [selectedSignBackground release];
    [selectedSignSymbol release];
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
    [textButton release];
    [labelTextColor release];
    [labelTextFont release];
    [labelMyFont release];
    [labelTextLine1 release];
    [labelTextLine2 release];
    [labelTextLine3 release];
    [textBorderColor release];
    [textBackgroundColor release];
    [lockedView release];
    [deleteConfirmationSheet release];
    [chooseActionTypeSheet release];
    [busyView release];
    [roadsignSaveDocumentsSubdirectory release];
    [signBackgroundView release];
    [mainScrollView release];
    [roadsignBackgroundColor release];
    [roadsignBackgroundTexture release];
    [super dealloc];
}

- (void)awbLockedView:(AWBLockedView *)lockedView didSetAnchor:(BOOL)anchored
{
    self.mainScrollView.scrollEnabled = !anchored;
}

@end
