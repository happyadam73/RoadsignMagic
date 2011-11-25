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
#import "AWBRoadsignMagicViewController+Carousel.h"
#import "AWBRoadsignMagicMainViewController+Gestures.h"
#import "FontManager.h"
#import "AWBTransformableLabel.h"
#import "AWBRoadsignMagicViewController+Toolbar.h"
#import "AWBRoadsignMagicMainViewController+UI.h"

@implementation AWBRoadsignMagicMainViewController

@synthesize mainScrollView, signBackgroundView;
@synthesize signBackgroundPickerButton, toolbarSpacing, textButton, editButton, editTextButton, cancelButton, deleteButton, selectNoneOrAllButton, addSymbolButton, actionButton, settingsButton, fixedToolbarSpacing;
@synthesize carouselSubcategory, carouselCategory, slideUpView, signBackgroundItems, signBackgroundCategories;
@synthesize rotationGestureRecognizer, panGestureRecognizer, pinchGestureRecognizer, singleTapGestureRecognizer, doubleTapGestureRecognizer, swipeGestureRecognizer, longPressGestureRecognizer;
@synthesize roadsignFont, selectionMarquee, selectionMarquee2;
@synthesize labelTextColor, labelTextFont, labelTextLine1, labelTextLine2, labelTextLine3, labelTextAlignment;
@synthesize exportQuality, lockCanvas, snapToGrid, snapToGridSize, scrollLocked;

- (void)viewWillAppear:(BOOL)animated
{
    self.toolbarItems = [self normalToolbarButtons];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self dereferenceGestureRecognizers];
    self.selectionMarquee = nil;
    self.selectionMarquee2 = nil;
    self.roadsignFont = nil;
    self.signBackgroundView = nil;
    self.mainScrollView = nil;
    self.slideUpView = nil;
    self.carouselSubcategory = nil;
    self.carouselCategory = nil;
    self.signBackgroundPickerButton = nil;
    self.toolbarSpacing = nil;
    self.textButton = nil;    
    self.editButton = nil;
    self.editTextButton = nil;
    self.cancelButton = nil;
    self.deleteButton = nil;
    self.selectNoneOrAllButton = nil;
    self.addSymbolButton = nil;
    self.actionButton = nil;
    self.settingsButton = nil;
    self.fixedToolbarSpacing = nil;
    self.labelTextColor = nil;
    self.labelTextFont = nil;
    self.labelTextLine1 = nil;
    self.labelTextLine2 = nil;
    self.labelTextLine3 = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    snapToGrid = YES;
    snapToGridSize = 50.0;
        
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
        
    if (slideUpView) {        
        CGRect frame = slideUpView.frame;
        if (thumbViewShowing) {
            frame.origin.y = (self.view.bounds.size.height - self.navigationController.toolbar.bounds.size.height - frame.size.height);            
        } else {
            frame.origin.y = (self.view.bounds.size.height);                        
        }
        slideUpView.frame = frame;
    }
    
    lockedView.center = CGPointMake(self.view.bounds.size.width - 20.0, 40.0);
}

- (void)loadView {
    [super loadView];
    
    ZFont *font = [[FontManager sharedManager] zFontWithName:@"BritishRoadsign" pointSize:40.0];
    self.roadsignFont = font;
    scrollLocked = NO;

    self.wantsFullScreenLayout = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageFromFile:@"concrete.jpg"]];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
    [scrollView setDelegate:self];
    [scrollView setBouncesZoom:YES];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.canCancelContentTouches = NO;
    scrollView.scrollEnabled = !scrollLocked;
    self.mainScrollView = scrollView;
    [scrollView release];
    [[self view] addSubview:self.mainScrollView];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.mainScrollView.bounds];
    backgroundView.userInteractionEnabled = YES;
    self.signBackgroundView = backgroundView;
    [self.mainScrollView addSubview:self.signBackgroundView];
    [backgroundView release];
    
    [[self.signBackgroundView layer] addSublayer:self.selectionMarquee];
    [[self.signBackgroundView layer] addSublayer:self.selectionMarquee2];
    
    lockedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anchored"]];
    lockedView.center = CGPointMake(self.view.bounds.size.width - 20.0, 40.0);
    lockedView.hidden = !scrollLocked;
    [self.view addSubview:lockedView];
    
}

- (void)dealloc {
    //it's a good idea to set these to nil here to avoid
	//sending messages to a deallocated viewcontroller
    [self deallocGestureRecognizers];
	carouselSubcategory.delegate = nil;
	carouselSubcategory.dataSource = nil;
    [signBackgroundCategories release];
    [roadsignFont release];
    [signBackgroundItems release];
    [slideUpView release];
    [carouselCategory release];
    [carouselSubcategory release];
    [toolbarSpacing release];
    [editButton release];
    [editTextButton release];
    [cancelButton release];
    [deleteButton release];
    [selectNoneOrAllButton release];
    [addSymbolButton release];
    [actionButton release];
    [settingsButton release];
    [fixedToolbarSpacing release];
    [signBackgroundPickerButton release];
    [mainScrollView release];
    [signBackgroundView release];
    [textButton release];
    [selectionMarquee release];
    [selectionMarquee2 release];
    [labelTextColor release];
    [labelTextFont release];
    [labelTextLine1 release];
    [labelTextLine2 release];
    [labelTextLine3 release];
    [super dealloc];
}


@end
