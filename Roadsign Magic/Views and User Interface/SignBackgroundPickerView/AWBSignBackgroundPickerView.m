//
//  AWBSignBackgroundPickerView.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 28/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBSignBackgroundPickerView.h"
#import "UIImage+NonCached.h"
#import "UIColor+Texture.h"

@implementation AWBSignBackgroundPickerView

@synthesize carouselCategory, carouselSubcategory, signBackgroundCategories, selectedSignBackground, delegate, currentSignBackgroundId, currentSignBackgroundCategoryIndex;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame signBackgroundCategoryIndex:0 signBackgroundId:8001];
}

- (id)initWithFrame:(CGRect)frame signBackgroundCategoryIndex:(NSUInteger)signBackgroundCategoryIndex signBackgroundId:(NSUInteger)signBackgroundId
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.signBackgroundCategories = [AWBRoadsignBackgroundGroup allSignBackgroundCategories];  
        currentSignBackgroundCategoryIndex = signBackgroundCategoryIndex;
        selectedSignBackgroundCategoryIndex = signBackgroundCategoryIndex;
        currentSignBackgroundId = signBackgroundId;
        
        //slideup view background
        self.backgroundColor = [UIColor asphaltTextureColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        self.alpha = 0.9;
        
        //category carousel background
        UIView *categoryBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(-5.0, 0.0, (frame.size.width+10.0), 65.0)];
        categoryBackgroundView.backgroundColor = nil;
        categoryBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        categoryBackgroundView.layer.borderWidth = 2.0;
        categoryBackgroundView.layer.borderColor = [[UIColor yellowSignBackgroundColor] CGColor];
        
        //category carousel
        iCarousel *tempCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0, 7.0, frame.size.width, 50.0)];
        self.carouselCategory = tempCarousel;
        [tempCarousel release];
        carouselCategory.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        carouselCategory.type = iCarouselTypeLinear;
        carouselCategory.delegate = self;
        carouselCategory.dataSource = self; 
        [carouselCategory scrollToItemAtIndex:currentSignBackgroundCategoryIndex animated:YES];
        
        //subcategory carousel
        tempCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0, 70.0, frame.size.width, 100.0)];
        self.carouselSubcategory = tempCarousel;
        [tempCarousel release];
        carouselSubcategory.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        carouselSubcategory.type = iCarouselTypeLinear;
        carouselSubcategory.delegate = self;
        carouselSubcategory.dataSource = self;
        NSUInteger scrollIndex = [AWBRoadsignBackground signIndexFromSignId:currentSignBackgroundId];
        [carouselSubcategory scrollToItemAtIndex:scrollIndex animated:YES];

        //add views together
        [self addSubview:categoryBackgroundView];
        [self addSubview:carouselSubcategory];
        [self addSubview:carouselCategory];
        [categoryBackgroundView release];
        
    }
    return self;
}

- (void)dealloc
{
    carouselSubcategory.delegate = nil;
    carouselSubcategory.dataSource = nil;
    carouselCategory.delegate = nil;
    carouselCategory.dataSource = nil;
    [carouselCategory release];
    [carouselSubcategory release];
    [signBackgroundCategories release];
    [selectedSignBackground release];
    [super dealloc];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if (carousel == self.carouselCategory) {
        return [self.signBackgroundCategories count];
    } else {
        AWBRoadsignBackgroundGroup *signGroup = [self.signBackgroundCategories objectAtIndex:selectedSignBackgroundCategoryIndex];
        return [signGroup.signBackgrounds count];
    }    
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    if (carousel == self.carouselCategory) {
        return [self.signBackgroundCategories count];
    } else {
        return (IS_IPAD ? 12 : 6);
    } 
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    CGFloat alpha = 1.0;
    NSString *filename = nil;
    NSUInteger signBackgroundId = 0;
    AWBRoadsignBackgroundGroup *signGroup = nil;
    
    if (carousel == self.carouselCategory) {
        signGroup = [self.signBackgroundCategories objectAtIndex:index];
        filename = signGroup.thumbnailImageFilename;
        if (index == selectedSignBackgroundCategoryIndex) {
            alpha = 1.0;
        } else {
            alpha = 0.5;
        }
    } else {        
        signGroup = [self.signBackgroundCategories objectAtIndex:selectedSignBackgroundCategoryIndex];
        AWBRoadsignBackground *signBackground = [signGroup.signBackgrounds objectAtIndex:index];
        signBackgroundId = signBackground.signBackgroundId;
        filename = signBackground.thumbnailImageFilename;
        if (signGroup.isAvailable) {
            alpha = 1.0;            
        } else {
            alpha = 0.4;
        }
    }
    
	UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageFromFile:filename]] autorelease];
    view.alpha = alpha;
    
    if (carousel == self.carouselCategory) {
        
        if (!signGroup.isAvailable) {
            UIView *subview = [[UIImageView alloc] initWithImage:signGroup.purchasePackImage];
            [view addSubview:subview];
            subview.center = CGPointMake(25.0, 25.0);
            [subview release];            
        }
        
        if (index == selectedSignBackgroundCategoryIndex) {
            view.layer.borderWidth = 1.0;
            view.layer.cornerRadius = 5.0;
            view.layer.borderColor = [[UIColor yellowSignBackgroundColor] CGColor];
        }
    } else {
        if (signBackgroundId == currentSignBackgroundId) {
            view.layer.borderWidth = 1.0;
            view.layer.cornerRadius = 5.0;
            view.layer.borderColor = [[UIColor yellowSignBackgroundColor] CGColor];            
        }
    }
        
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
        selectedSignBackgroundCategoryIndex = index;
        [self.carouselCategory reloadData];
        [self.carouselSubcategory reloadData];
        if (selectedSignBackgroundCategoryIndex == currentSignBackgroundCategoryIndex) {
            [self.carouselSubcategory scrollToItemAtIndex:selectedSignBackgroundCarouselIndex animated:YES];
        }
    } else {
        AWBRoadsignBackgroundGroup *signGroup = [self.signBackgroundCategories objectAtIndex:selectedSignBackgroundCategoryIndex];
        AWBRoadsignBackground *signBackground = [signGroup.signBackgrounds objectAtIndex:index];
        self.selectedSignBackground = signBackground;
        currentSignBackgroundId = self.selectedSignBackground.signBackgroundId;
        selectedSignBackgroundCarouselIndex = index;
        currentSignBackgroundCategoryIndex = selectedSignBackgroundCategoryIndex;        
        
        if (signGroup.isAvailable) {
            if([delegate respondsToSelector:@selector(awbSignBackgroundPickerView:didSelectSignBackground:)]) {
                [delegate performSelector:@selector(awbSignBackgroundPickerView:didSelectSignBackground:) withObject:self withObject:self.selectedSignBackground];
            }
        } else {
            if([delegate respondsToSelector:@selector(awbSignBackgroundPickerView:didSelectNonPurchasedSignBackgroundCategory:)]) {
                [delegate performSelector:@selector(awbSignBackgroundPickerView:didSelectNonPurchasedSignBackgroundCategory:) withObject:self withObject:signGroup];
            }            
        }
                
        [self.carouselSubcategory reloadData];
    }
}

- (void)reload
{
    [self.carouselCategory reloadData];
    [self.carouselSubcategory reloadData];    
}

@end
