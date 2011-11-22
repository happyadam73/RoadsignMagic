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

//#define NUMBER_OF_ITEMS (IS_IPAD? 7: 7)
//#define NUMBER_OF_VISIBLE_ITEMS (IS_IPAD? 28: 14)
//#define ITEM_SPACING (IS_IPAD? 400: 200)
//#define INCLUDE_PLACEHOLDERS YES

@implementation AWBRoadsignMagicMainViewController (Carousel)

#pragma mark -
#pragma mark iCarousel methods

- (void)initialiseCarousel
{
    self.items = [NSMutableArray array];
    [items addObject:[NSNumber numberWithInteger:15]];
    [items addObject:[NSNumber numberWithInteger:9]];
    [items addObject:[NSNumber numberWithInteger:14]];
    [items addObject:[NSNumber numberWithInteger:19]];
    [items addObject:[NSNumber numberWithInteger:10]];
    [items addObject:[NSNumber numberWithInteger:15]];
    
//    for (int i = 0; i < NUMBER_OF_ITEMS; i++)
//    {
//        [items addObject:[NSNumber numberWithInt:i]];
//    }
    
    selectedCategory = 0;
    
    //create carousel
    CGRect backgroundFrame = CGRectMake(0.0, self.view.bounds.size.height-(self.navigationController.toolbar.bounds.size.height)-180.0, self.view.bounds.size.width, 180);
    UIView *backgroundView = [[UIView alloc] initWithFrame:backgroundFrame];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageFromFile:@"asphalt.jpg"]];
	backgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//    backgroundView.layer.borderWidth = 1.0;
//    backgroundView.layer.borderColor = [[UIColor yellowSignBackgroundColor] CGColor];
    backgroundView.alpha = 0.8;
        
    iCarousel *tempCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0, 70.0, backgroundFrame.size.width, 100.0)];
	self.carouselSubcategory = tempCarousel;
    [tempCarousel release];
	carouselSubcategory.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    carouselSubcategory.type = iCarouselTypeLinear;
	carouselSubcategory.delegate = self;
	carouselSubcategory.dataSource = self;
    
    CGRect categoryFrame = CGRectMake(0.0, 15.0, backgroundFrame.size.width, 50.0);
    UIView *categoryBackgroundView = [[UIView alloc] initWithFrame:categoryFrame];
    categoryBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageFromFile:@"asphaltyellow.jpg"]];
	categoryBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    categoryBackgroundView.alpha = 1.0;
    
    tempCarousel = [[iCarousel alloc] initWithFrame:categoryFrame];
	self.carouselCategory = tempCarousel;
    [tempCarousel release];
	carouselCategory.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    carouselCategory.type = iCarouselTypeLinear;
	carouselCategory.delegate = self;
	carouselCategory.dataSource = self; 
    [carouselCategory scrollToItemAtIndex:selectedCategory animated:YES];
    
	//add carousels to view
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
        return [items count];
    } else {
        return [[items objectAtIndex:selectedCategory] integerValue];
    }    
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    if (carousel == self.carouselCategory) {
        return [items count];
    } else {
        return [[items objectAtIndex:selectedCategory] integerValue];
    } 
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    //create a numbered view
    //NSUInteger imageNumber = (NSUInteger)fmodf(index, 7.0)+1;
    CGFloat alpha = 1.0;
    NSString *filename = nil;

    if (carousel == self.carouselCategory) {
        filename = [NSString stringWithFormat:@"0%d.png", index];
        if (index == selectedCategory) {
            alpha = 1.0;
        } else {
            alpha = 0.65;
        }
    } else {
        NSString *imageNumberString = [[NSString stringWithFormat:@"%d", (index+1)] stringByPaddingTheLeftToLength:3 withString:@"0" startingAtIndex:0];
        filename = [NSString stringWithFormat:@"1%d%@.png", selectedCategory, imageNumberString];    
        NSLog(@"%@", filename);
    }
    
//    NSString *filename = [NSString stringWithFormat:@"sign%d0%d.png", category, imageNumber];
	UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageFromFile:filename]] autorelease];
    view.alpha = alpha;

    if (carousel == self.carouselCategory) {
        if (index == selectedCategory) {
//            view.layer.borderWidth = 1.0;
//            view.layer.borderColor = [[UIColor whiteColor] CGColor];
            view.layer.backgroundColor = [self.slideUpView.backgroundColor CGColor];
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
	//return INCLUDE_PLACEHOLDERS? 2: 0;
}

//- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index
//{
//	//create a placeholder view
//	UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageFromFile:@"page.png"]] autorelease];
//	UILabel *label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
//	label.text = (index == 0)? @"[": @"]";
//	label.backgroundColor = [UIColor clearColor];
//	label.textAlignment = UITextAlignmentCenter;
//	label.font = [label.font fontWithSize:50];
//	//[view addSubview:label];
//	return view;
//}

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
        NSLog(@"%@", filename);
        [self pickImageNamed:filename];
    }
}

@end

@implementation NSString (LeftPadding)

- (NSString *)stringByPaddingTheLeftToLength:(NSUInteger) newLength withString:(NSString *) padString startingAtIndex:(NSUInteger) padIndex
{
    if ([self length] <= newLength)
        return [[@"" stringByPaddingToLength:newLength - [self length] withString:padString startingAtIndex:padIndex] stringByAppendingString:self];
    else
        return [[self copy] autorelease];
}

@end

