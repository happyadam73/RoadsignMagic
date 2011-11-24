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

@implementation AWBRoadsignMagicMainViewController (Carousel)

#pragma mark -
#pragma mark iCarousel methods

- (void)initialiseSlideupView
{
    self.signBackgroundItems = [NSMutableArray array];
    [signBackgroundItems addObject:[NSNumber numberWithInteger:15]];
    [signBackgroundItems addObject:[NSNumber numberWithInteger:9]];
    [signBackgroundItems addObject:[NSNumber numberWithInteger:14]];
    [signBackgroundItems addObject:[NSNumber numberWithInteger:19]];
    [signBackgroundItems addObject:[NSNumber numberWithInteger:10]];
    [signBackgroundItems addObject:[NSNumber numberWithInteger:15]];
    selectedCategory = 0;
    
    //slideup view background
    CGRect backgroundFrame = CGRectMake(0.0, self.view.bounds.size.height-(self.navigationController.toolbar.bounds.size.height)-180.0, self.view.bounds.size.width, 180);
    UIView *backgroundView = [[UIView alloc] initWithFrame:backgroundFrame];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageFromFile:@"asphalt.jpg"]];
	backgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    backgroundView.alpha = 0.9;

    //category carousel background
    UIView *categoryBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(-5.0, 0.0, (backgroundFrame.size.width+10.0), 65.0)];
    categoryBackgroundView.backgroundColor = nil;
    categoryBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    categoryBackgroundView.layer.borderWidth = 2.0;
    categoryBackgroundView.layer.borderColor = [[UIColor yellowSignBackgroundColor] CGColor];

    //category carousel
    iCarousel *tempCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0, 7.0, backgroundFrame.size.width, 50.0)];
	self.carouselCategory = tempCarousel;
    [tempCarousel release];
	carouselCategory.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    carouselCategory.type = iCarouselTypeLinear;
	carouselCategory.delegate = self;
	carouselCategory.dataSource = self; 
    [carouselCategory scrollToItemAtIndex:selectedCategory animated:YES];
    
    //subcategory carousel
    tempCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0, 70.0, backgroundFrame.size.width, 100.0)];
	self.carouselSubcategory = tempCarousel;
    [tempCarousel release];
	carouselSubcategory.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    carouselSubcategory.type = iCarouselTypeLinear;
	carouselSubcategory.delegate = self;
	carouselSubcategory.dataSource = self;
    
	//add views together
    [backgroundView addSubview:categoryBackgroundView];
    [backgroundView addSubview:carouselSubcategory];
    [backgroundView addSubview:carouselCategory];
    self.slideUpView = backgroundView;
	[self.view addSubview:backgroundView];
    [categoryBackgroundView release];
    [backgroundView release];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if (carousel == self.carouselCategory) {
        return [signBackgroundItems count];
    } else {
        return [[signBackgroundItems objectAtIndex:selectedCategory] integerValue];
    }    
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    if (carousel == self.carouselCategory) {
        return [signBackgroundItems count];
    } else {
        return (IS_IPAD ? 12 : 6);
    } 
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    CGFloat alpha = 1.0;
    NSString *filename = nil;

    if (carousel == self.carouselCategory) {
        filename = [NSString stringWithFormat:@"0%d.png", index];
        if (index == selectedCategory) {
            alpha = 1.0;
        } else {
            alpha = 0.5;
        }
    } else {
        NSString *imageNumberString = [[NSString stringWithFormat:@"%d", (index+1)] stringByPaddingTheLeftToLength:3 withString:@"0" startingAtIndex:0];
        filename = [NSString stringWithFormat:@"1%d%@.png", selectedCategory, imageNumberString];    
        alpha = 1.0;
    }
    
	UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageFromFile:filename]] autorelease];
    view.alpha = alpha;

    if (carousel == self.carouselCategory) {
        if (index == selectedCategory) {
            view.layer.borderWidth = 1.0;
            view.layer.cornerRadius = 5.0;
            view.layer.borderColor = [[UIColor yellowSignBackgroundColor] CGColor];
        }
    }
    
//    if (IS_IPAD) {
//        view.transform = CGAffineTransformMakeScale(2.0, 2.0); 
//    }  
//	UILabel *label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
//	label.text = [[items objectAtIndex:index] stringValue];
//	label.backgroundColor = [UIColor clearColor];
//	label.textAlignment = UITextAlignmentCenter;
//	label.font = [label.font fontWithSize:50];
	//[view addSubview:label];
	return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	//note: placeholder views are only displayed if wrapping is disabled
    return 0;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    CGFloat width;
    if (carousel == self.carouselCategory) {
        width = 60;
    } else {
        width = 120;
    }   
    
    return width;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    //implement 'flip3D' style carousel
    
    //set opacity based on distance from camera
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    //do 3d transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carouselSubcategory.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carouselSubcategory.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    if (carousel == self.carouselCategory) {
        return NO;
    } else {
        return YES;
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (carousel == self.carouselCategory) {
        selectedCategory = index;
        [self.carouselCategory reloadData];
        [self.carouselSubcategory reloadData];
    } else {
        NSString *imageNumberString = [[NSString stringWithFormat:@"%d", (index+1)] stringByPaddingTheLeftToLength:3 withString:@"0" startingAtIndex:0];
        NSString *filename = [NSString stringWithFormat:@"2%d%@.png", selectedCategory, imageNumberString];    
        [self updateSignBackgroundWithImageFromFile:filename];
    }
}

@end



