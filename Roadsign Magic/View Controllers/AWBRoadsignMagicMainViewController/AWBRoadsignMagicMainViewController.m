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

#define ZOOM_VIEW_TAG 100



@implementation AWBRoadsignMagicMainViewController

@synthesize signBackgroundPickerButton, toolbarSpacing, textButton;
@synthesize carouselSubcategory, carouselCategory, slideUpView, items;

- (void)viewWillAppear:(BOOL)animated
{
    self.toolbarItems = [self normalToolbarButtons];
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self initialiseCarousel];
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.slideUpView = nil;
    self.carouselSubcategory = nil;
    self.carouselCategory = nil;
    self.signBackgroundPickerButton = nil;
    self.toolbarSpacing = nil;
    self.textButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{    
    // recalculate contentSize based on current orientation    
    UIView *zoomView = [mainScrollView viewWithTag:ZOOM_VIEW_TAG];
    mainScrollView.contentSize = zoomView.bounds.size;
    
    // choose minimum scale so image width fits screen
    float minWidthScale  = ((mainScrollView.bounds.size.width)  / zoomView.bounds.size.width) * 0.96;
    float minHeightScale  = ((mainScrollView.bounds.size.height)  / zoomView.bounds.size.height) * 0.96;    
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
}

- (void)loadView {
    [super loadView];
    self.wantsFullScreenLayout = YES;
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete.jpg"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageFromFile:@"concrete.jpg"]];
    mainScrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
    [mainScrollView setDelegate:self];
    [mainScrollView setBouncesZoom:YES];
    mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mainScrollView.backgroundColor = [UIColor clearColor];
    
    [[self view] addSubview:mainScrollView];
    
    //[self pickImageNamed:@"WeCanDoIt"];
}


- (void)toggleThumbView {
    UIButton *button = (UIButton *)self.signBackgroundPickerButton.customView;
    [self performSelector:@selector(doHighlight:) withObject:button afterDelay:0];
    
    if (!slideUpView) {
        [self initialiseCarousel];
    }
    
//    CGRect frame = [slideUpView frame];
//    if (thumbViewShowing) {
//        frame.origin.y += (slideUpView.bounds.size.height + self.navigationController.toolbar.bounds.size.height);
//    } else {
//        frame.origin.y -= (slideUpView.bounds.size.height + self.navigationController.toolbar.bounds.size.height);
//    }
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
	carouselSubcategory.delegate = nil;
	carouselSubcategory.dataSource = nil;
    
    [items release];
    [slideUpView release];
    [carouselCategory release];
    [carouselSubcategory release];
    [toolbarSpacing release];
    [signBackgroundPickerButton release];
    [mainScrollView release];
    [textButton release];
    [super dealloc];
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIView *view = nil;
    if (scrollView == mainScrollView) {
        view = [mainScrollView viewWithTag:ZOOM_VIEW_TAG];
    }
    return view;
}

#pragma mark View handling methods


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)? 
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)? 
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    UIView *zoomView = [mainScrollView viewWithTag:ZOOM_VIEW_TAG];
    zoomView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, 
                                  scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)pickImageNamed:(NSString *)name {
    
    [[mainScrollView viewWithTag:ZOOM_VIEW_TAG] removeFromSuperview];
    
    UIImage *image = [UIImage imageFromFile:name];
    
    UIImageView *zoomView = [[UIImageView alloc] initWithImage:image];
    [zoomView setTag:ZOOM_VIEW_TAG];
    zoomView.alpha = 0.0;
    [mainScrollView addSubview:zoomView];
    [mainScrollView setContentSize:[zoomView bounds].size];
    float minWidthScale  = ((mainScrollView.bounds.size.width)  / zoomView.bounds.size.width) * 0.96;
    float minHeightScale  = ((mainScrollView.bounds.size.height)  / zoomView.bounds.size.height) * 0.96;
    
    [mainScrollView setMinimumZoomScale:MIN(minWidthScale, minHeightScale)];
    [mainScrollView setZoomScale:MIN(minWidthScale, minHeightScale)];
    [mainScrollView setContentOffset:CGPointZero];
    
    
//    FontLabel *label = [[FontLabel alloc] initWithFrame:CGRectMake(400, 150, 500, 300) fontName:@"BritishRoadsign" pointSize:40.0f];
//	label.textColor = [UIColor blackColor];
//	label.text = @"Sleepy\nTime";
//    label.textAlignment = UITextAlignmentCenter;
//	label.lineBreakMode = UILineBreakModeTailTruncation;
//	label.backgroundColor = [UIColor greenColor];
//	label.numberOfLines = 0;
//	[label sizeToFit];
//	label.backgroundColor = nil;
//	label.opaque = NO;
//    label.transform = CGAffineTransformMakeScale(1.75, 1.75);
//	[zoomView addSubview:label];
//	[label release];   
    
    [UIView animateWithDuration:1.0 
                          delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations: ^ {
                         [zoomView setAlpha:1.0]; 
                     } 
                     completion: ^ (BOOL finished) {
                         [zoomView release];
                     }];
    
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
        textButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"textbutton"] style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return textButton;    
}

- (NSArray *)normalToolbarButtons
{
    return [NSArray arrayWithObjects:self.toolbarSpacing, self.textButton,self.toolbarSpacing, self.signBackgroundPickerButton, self.toolbarSpacing, nil];
}

- (void)toggleFullscreen
{
    BOOL hidden = !self.navigationController.toolbarHidden;
    [self.navigationController setToolbarHidden:hidden animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationSlide];
}

@end
