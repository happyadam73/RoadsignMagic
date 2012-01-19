//
//  AWBSignSymbolPickerView.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 29/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBSignSymbolPickerView.h"
#import "UIImage+NonCached.h"
#import "UIColor+SignColors.h"
#import "UIColor+Texture.h"

@implementation AWBSignSymbolPickerView

@synthesize carouselCategory, carouselSubcategory, signSymbolCategories, selectedSignSymbol, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.signSymbolCategories = [AWBRoadsignSymbolGroup allSignSymbolCategories];   
        selectedSignSymbolCategory = 0;
        
        //slideup view background
        self.backgroundColor = [UIColor woodTextureColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        self.alpha = 0.9;
        
        //category carousel background
        UIView *categoryBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(-5.0, 0.0, (frame.size.width+10.0), 65.0)];
        categoryBackgroundView.backgroundColor = nil;
        categoryBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        categoryBackgroundView.layer.borderWidth = 2.0;
        categoryBackgroundView.layer.borderColor = [[UIColor blackColor] CGColor];
        
        //category carousel
        iCarousel *tempCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0, 7.0, frame.size.width, 50.0)];
        self.carouselCategory = tempCarousel;
        [tempCarousel release];
        carouselCategory.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        carouselCategory.type = iCarouselTypeLinear;
        carouselCategory.delegate = self;
        carouselCategory.dataSource = self; 
        [carouselCategory scrollToItemAtIndex:selectedSignSymbolCategory animated:YES];
        
        //subcategory carousel
        tempCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0, 70.0, frame.size.width, 100.0)];
        self.carouselSubcategory = tempCarousel;
        [tempCarousel release];
        carouselSubcategory.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        carouselSubcategory.type = iCarouselTypeLinear;
        carouselSubcategory.delegate = self;
        carouselSubcategory.dataSource = self;
        
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
    [signSymbolCategories release];
    [selectedSignSymbol release];
    [super dealloc];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if (carousel == self.carouselCategory) {
        return [self.signSymbolCategories count];
    } else {
        AWBRoadsignSymbolGroup *symbolGroup = [self.signSymbolCategories objectAtIndex:selectedSignSymbolCategory];
        return [symbolGroup.signSymbols count];
    }    
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    if (carousel == self.carouselCategory) {
        return [self.signSymbolCategories count];
    } else {
        return (IS_IPAD ? 12 : 6);
    } 
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    CGFloat alpha = 1.0;
    NSString *filename = nil;
    NSUInteger signSymbolId = 0;
    AWBRoadsignSymbolGroup *symbolGroup = nil;
    
    if (carousel == self.carouselCategory) {
        symbolGroup = [self.signSymbolCategories objectAtIndex:index];
        filename = symbolGroup.thumbnailImageFilename;
        if (index == selectedSignSymbolCategory) {
            alpha = 1.0;
        } else {
            alpha = 0.5;
        }
    } else {        
        symbolGroup = [self.signSymbolCategories objectAtIndex:selectedSignSymbolCategory];
        AWBRoadsignSymbol *signSymbol = [symbolGroup.signSymbols objectAtIndex:index];
        signSymbolId = signSymbol.signSymbolId;
        filename = signSymbol.thumbnailImageFilename;
        if (symbolGroup.isAvailable) {
            alpha = 1.0;            
        } else {
            alpha = 0.4;
        }
    }
    
	UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageFromFile:filename]] autorelease];
    view.alpha = alpha;
    
    if (carousel == self.carouselCategory) {
        if (!symbolGroup.isAvailable) {
            UIView *subview = [[UIImageView alloc] initWithImage:symbolGroup.purchasePackImage];
            [view addSubview:subview];
            subview.center = CGPointMake(35.0, 35.0);
            [subview release];            
        }
        if (index == selectedSignSymbolCategory) {
            view.layer.borderWidth = 1.0;
            view.layer.cornerRadius = 5.0;
            view.layer.borderColor = [[UIColor yellowSignBackgroundColor] CGColor];
        }
    } else {
        if (signSymbolId == selectedSignSymbol.signSymbolId) {
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
        selectedSignSymbolCategory = index;
        [self.carouselCategory reloadData];
        [self.carouselSubcategory reloadData];
        if (selectedSignSymbolCategory == selectedSignSymbolCategoryIndex) {
            [self.carouselSubcategory scrollToItemAtIndex:selectedSignSymbolCarouselIndex animated:YES];
        }
    } else {
        AWBRoadsignSymbolGroup *signSymbolGroup = [self.signSymbolCategories objectAtIndex:selectedSignSymbolCategory];
        AWBRoadsignSymbol *signSymbol = [signSymbolGroup.signSymbols objectAtIndex:index];
        self.selectedSignSymbol = signSymbol;
        selectedSignSymbolCarouselIndex = index;
        selectedSignSymbolCategoryIndex = selectedSignSymbolCategory; 
        
        if (signSymbolGroup.isAvailable) {
            if([delegate respondsToSelector:@selector(awbSignSymbolPickerView:didSelectSignSymbol:)]) {
                [delegate performSelector:@selector(awbSignSymbolPickerView:didSelectSignSymbol:) withObject:self withObject:self.selectedSignSymbol];
            }            
        } else {
            if([delegate respondsToSelector:@selector(awbSignSymbolPickerView:didSelectNonPurchasedSignSymbolCategory:)]) {
                [delegate performSelector:@selector(awbSignSymbolPickerView:didSelectNonPurchasedSignSymbolCategory:) withObject:self withObject:signSymbolGroup];
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