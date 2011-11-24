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

@implementation AWBRoadsignMagicMainViewController

@synthesize mainScrollView, signBackgroundView;
@synthesize signBackgroundPickerButton, toolbarSpacing, textButton;
@synthesize carouselSubcategory, carouselCategory, slideUpView, items;
@synthesize rotationGestureRecognizer, panGestureRecognizer, pinchGestureRecognizer, singleTapGestureRecognizer, doubleTapGestureRecognizer, swipeGestureRecognizer, longPressGestureRecognizer;
@synthesize roadsignFont, selectionMarquee, selectionMarquee2;
@synthesize labelTextColor, labelTextFont, labelTextLine1, labelTextLine2, labelTextLine3;
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
    
    lockedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locked"]];
    lockedView.center = CGPointMake(self.view.bounds.size.width - 20.0, 40.0);
    lockedView.hidden = !scrollLocked;
    [self.view addSubview:lockedView];
    
}

- (void)toggleThumbView {
    UIButton *button = (UIButton *)self.signBackgroundPickerButton.customView;
    [self performSelector:@selector(doHighlight:) withObject:button afterDelay:0];
    
    if (!slideUpView) {
        [self initialiseSlideupView];
    }
    
    CGRect frame = slideUpView.frame;
    if (!thumbViewShowing) {
        frame.origin.y = (self.view.bounds.size.height - self.navigationController.toolbar.bounds.size.height - frame.size.height);            
    } else {
        frame.origin.y = (self.view.bounds.size.height);                        
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [slideUpView setFrame:frame];
    [UIView commitAnimations];
    
    thumbViewShowing = !thumbViewShowing;
}

- (void)doHighlight:(UIButton*)b {
    [b setSelected:thumbViewShowing];
}

- (void)dealloc {
    //it's a good idea to set these to nil here to avoid
	//sending messages to a deallocated viewcontroller
    [self deallocGestureRecognizers];
	carouselSubcategory.delegate = nil;
	carouselSubcategory.dataSource = nil;
    [roadsignFont release];
    [items release];
    [slideUpView release];
    [carouselCategory release];
    [carouselSubcategory release];
    [toolbarSpacing release];
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

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIView *view = nil;
    if (scrollView == mainScrollView) {
        view = signBackgroundView;
    }
    return view;
}

#pragma mark View handling methods


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)? 
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)? 
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;    
    signBackgroundView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, 
                                  scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)updateSignBackgroundWithImageFromFile:(NSString *)name {
    
    UIImage *image = [UIImage imageFromFile:name];
    [signBackgroundView setImage:image];
    [signBackgroundView sizeToFit];
    signBackgroundView.alpha = 0.0;
    [mainScrollView setContentSize:[signBackgroundView bounds].size];
    float minWidthScale  = ((mainScrollView.bounds.size.width)  / signBackgroundView.bounds.size.width) * 0.96;
    float minHeightScale  = ((mainScrollView.bounds.size.height)  / signBackgroundView.bounds.size.height) * 0.96;
    [mainScrollView setMinimumZoomScale:MIN(minWidthScale, minHeightScale)];
    [mainScrollView setZoomScale:MIN(minWidthScale, minHeightScale)];
    [mainScrollView setContentOffset:CGPointZero];
    
//    AWBTransformableLabel *label = [[AWBTransformableLabel alloc] initWithTextLines:[NSArray arrayWithObjects:@"Sleepy", @"Head", nil] font:self.roadsignFont offset:CGPointZero rotation:0.0 scale:1.0 horizontalFlip:NO color:[UIColor whiteColor]];
//    [signBackgroundView addSubview:label];
//    label.center = CGPointMake(200.0, 200.0);
//    [label release];
    
    [UIView animateWithDuration:1.0 
                          delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations: ^ {
                         [signBackgroundView setAlpha:1.0]; 
                     } 
                     completion: ^ (BOOL finished) {}];    
}


- (UIBarButtonItem *)signBackgroundPickerButton
{
    if (!signBackgroundPickerButton) {
        UIImage* image = [UIImage imageNamed:@"button-up"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton* button = [[UIButton alloc] initWithFrame:frame];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        image = [UIImage imageNamed:@"button-down"];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        [button setBackgroundImage:image forState:UIControlStateSelected];
        [button addTarget:self action:@selector(toggleThumbView) forControlEvents:UIControlEventTouchUpInside];
        [button setShowsTouchWhenHighlighted:YES];
        signBackgroundPickerButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [button release];        
    }
    return signBackgroundPickerButton;    
}

- (UIBarButtonItem *)toolbarSpacing
{
    if (!toolbarSpacing) {
        toolbarSpacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return toolbarSpacing;    
}

- (UIBarButtonItem *)textButton
{
    if (!textButton) {
        textButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"textbutton"] style:UIBarButtonItemStylePlain target:self action:@selector(addTextView:)];
    }
    return textButton;    
}

- (NSArray *)normalToolbarButtons
{
    return [NSArray arrayWithObjects:self.toolbarSpacing, self.textButton,self.toolbarSpacing, self.signBackgroundPickerButton, self.toolbarSpacing, nil];
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [mainScrollView frame].size.height / scale;
    zoomRect.size.width  = [mainScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

@end
