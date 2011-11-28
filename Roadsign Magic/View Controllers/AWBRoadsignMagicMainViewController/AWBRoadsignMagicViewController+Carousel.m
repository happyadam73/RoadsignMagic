//
//  AWBRoadsignMagicViewController+Carousel.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 21/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicViewController+Carousel.h"
#import "UIImage+NonCached.h"
#import "UIColor+SignColors.h"
#import "NSString+Helpers.h"
#import "AWBRoadsignMagicViewController+Sign.h"
#import "AWBRoadsignBackgroundGroup.h"
#import "AWBRoadsignBackground.h"
#import "AWBSignBackgroundPickerView.h"

@implementation AWBRoadsignMagicMainViewController (Carousel)

#pragma mark -
#pragma mark iCarousel methods

//- (void)initialiseSlideupView
//{
//
//    CGRect backgroundFrame = CGRectMake(0.0, self.view.bounds.size.height-(self.navigationController.toolbar.bounds.size.height)-180.0, self.view.bounds.size.width, 180);
//    AWBSignBackgroundPickerView *backgroundView = [[AWBSignBackgroundPickerView alloc] initWithFrame:backgroundFrame];
//    backgroundView.delegate = self;
//    self.slideUpView = backgroundView;
//	[self.view addSubview:backgroundView];
//    [backgroundView release];
//
//    
//    self.signBackgroundCategories = [AWBRoadsignBackgroundGroup allSignBackgroundCategories];   
//    selectedSignBackgroundCategory = 0;
//    
//    //slideup view background
//    CGRect backgroundFrame = CGRectMake(0.0, self.view.bounds.size.height-(self.navigationController.toolbar.bounds.size.height)-180.0, self.view.bounds.size.width, 180);
//    UIView *backgroundView = [[UIView alloc] initWithFrame:backgroundFrame];
//    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageFromFile:@"asphalt.jpg"]];
//	backgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//    backgroundView.alpha = 0.9;
//
//    //category carousel background
//    UIView *categoryBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(-5.0, 0.0, (backgroundFrame.size.width+10.0), 65.0)];
//    categoryBackgroundView.backgroundColor = nil;
//    categoryBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//    categoryBackgroundView.layer.borderWidth = 2.0;
//    categoryBackgroundView.layer.borderColor = [[UIColor yellowSignBackgroundColor] CGColor];
//
//    //category carousel
//    iCarousel *tempCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0, 7.0, backgroundFrame.size.width, 50.0)];
//	self.carouselCategory = tempCarousel;
//    [tempCarousel release];
//	carouselCategory.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//    carouselCategory.type = iCarouselTypeLinear;
//	carouselCategory.delegate = self;
//	carouselCategory.dataSource = self; 
//    [carouselCategory scrollToItemAtIndex:selectedSignBackgroundCategory animated:YES];
//    
//    //subcategory carousel
//    tempCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0, 70.0, backgroundFrame.size.width, 100.0)];
//	self.carouselSubcategory = tempCarousel;
//    [tempCarousel release];
//	carouselSubcategory.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//    carouselSubcategory.type = iCarouselTypeLinear;
//	carouselSubcategory.delegate = self;
//	carouselSubcategory.dataSource = self;
//    
//	//add views together
//    [backgroundView addSubview:categoryBackgroundView];
//    [backgroundView addSubview:carouselSubcategory];
//    [backgroundView addSubview:carouselCategory];
//    self.slideUpView = backgroundView;
//	[self.view addSubview:backgroundView];
//    [categoryBackgroundView release];
//    [backgroundView release];
//}

//- (void)awbSignBackgroundPickerView:(AWBSignBackgroundPickerView *)backgroundPicker didSelectSignBackground:(AWBRoadsignBackground *)signBackground
//{
//    self.selectedSignBackground = signBackground;
//    self.labelTextColor = [UIColor foregroundColorWithBackgroundSignColorCode:signBackground.primaryColorCode];
//    NSString *filename = signBackground.fullsizeImageFilename;        
//    [self updateSignBackgroundWithImageFromFile:filename];
//}
//
//- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
//{
//    if (carousel == self.carouselCategory) {
//        return [self.signBackgroundCategories count];
//    } else {
//        AWBRoadsignBackgroundGroup *signGroup = [self.signBackgroundCategories objectAtIndex:selectedSignBackgroundCategory];
//        return [signGroup.signBackgrounds count];
//    }    
//}
//
//- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
//{
//    //limit the number of items views loaded concurrently (for performance reasons)
//    if (carousel == self.carouselCategory) {
//        return [self.signBackgroundCategories count];
//    } else {
//        return (IS_IPAD ? 12 : 6);
//    } 
//}
//
//- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
//{
//    CGFloat alpha = 1.0;
//    NSString *filename = nil;
//    NSUInteger signBackgroundId = 0;
//    
//    if (carousel == self.carouselCategory) {
//        AWBRoadsignBackgroundGroup *signGroup = [self.signBackgroundCategories objectAtIndex:index];
//        filename = signGroup.thumbnailImageFilename;
//        if (index == selectedSignBackgroundCategory) {
//            alpha = 1.0;
//        } else {
//            alpha = 0.5;
//        }
//    } else {        
//        AWBRoadsignBackgroundGroup *signGroup = [self.signBackgroundCategories objectAtIndex:selectedSignBackgroundCategory];
//        AWBRoadsignBackground *signBackground = [signGroup.signBackgrounds objectAtIndex:index];
//        signBackgroundId = signBackground.signBackgroundId;
//        filename = signBackground.thumbnailImageFilename;
//        alpha = 1.0;
//    }
//    
//	UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageFromFile:filename]] autorelease];
//    view.alpha = alpha;
//
//    if (carousel == self.carouselCategory) {
//        if (index == selectedSignBackgroundCategory) {
//            view.layer.borderWidth = 1.0;
//            view.layer.cornerRadius = 5.0;
//            view.layer.borderColor = [[UIColor yellowSignBackgroundColor] CGColor];
//        }
//    } else {
//        if (signBackgroundId == selectedSignBackground.signBackgroundId) {
//            view.layer.borderWidth = 1.0;
//            view.layer.cornerRadius = 5.0;
//            view.layer.borderColor = [[UIColor yellowSignBackgroundColor] CGColor];            
//        }
//    }
//    
//	return view;
//}
//
//- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
//{
//	//note: placeholder views are only displayed if wrapping is disabled
//    return 0;
//}
//
//- (CGFloat)carouselItemWidth:(iCarousel *)carousel
//{
//    //slightly wider than item view
//    CGFloat width;
//    if (carousel == self.carouselCategory) {
//        width = 60;
//    } else {
//        width = 120;
//    }   
//    
//    return width;
//}
//
//- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
//{
//    //implement 'flip3D' style carousel
//    
//    //set opacity based on distance from camera
//    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
//    
//    //do 3d transform
//    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = self.carouselSubcategory.perspective;
//    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
//    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carouselSubcategory.itemWidth);
//}
//
//- (BOOL)carouselShouldWrap:(iCarousel *)carousel
//{
//    if (carousel == self.carouselCategory) {
//        return NO;
//    } else {
//        return YES;
//    }
//}
//
//- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
//{
//    if (carousel == self.carouselCategory) {
//        selectedSignBackgroundCategory = index;
//        [self.carouselCategory reloadData];
//        [self.carouselSubcategory reloadData];
//        if (selectedSignBackgroundCategory == selectedSignBackgroundCategoryIndex) {
//            [self.carouselSubcategory scrollToItemAtIndex:selectedSignBackgroundCarouselIndex animated:YES];
//        }
//    } else {
//        AWBRoadsignBackgroundGroup *signGroup = [self.signBackgroundCategories objectAtIndex:selectedSignBackgroundCategory];
//        AWBRoadsignBackground *signBackground = [signGroup.signBackgrounds objectAtIndex:index];
//        self.selectedSignBackground = signBackground;
//        selectedSignBackgroundCarouselIndex = index;
//        selectedSignBackgroundCategoryIndex = selectedSignBackgroundCategory;
//        self.labelTextColor = [UIColor foregroundColorWithBackgroundSignColorCode:signBackground.primaryColorCode];
//        NSString *filename = signBackground.fullsizeImageFilename;        
//        [self updateSignBackgroundWithImageFromFile:filename];
//        [self.carouselSubcategory reloadData];
//    }
//}

@end



