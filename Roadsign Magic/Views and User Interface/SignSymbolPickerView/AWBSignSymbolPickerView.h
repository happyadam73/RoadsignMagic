//
//  AWBSignSymbolPickerView.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 29/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "AWBRoadsignSymbol.h"

@class AWBSignSymbolPickerView;

@protocol AWBSignSymbolPickerViewDelegate
@optional
- (void)awbSignSymbolPickerView:(AWBSignSymbolPickerView *)symbolPicker didSelectSignSymbol:(AWBRoadsignSymbol *)signSymbol;
@end

@interface AWBSignSymbolPickerView : UIView <iCarouselDataSource, iCarouselDelegate> {
    id delegate;
    iCarousel *carouselSubcategory;
    iCarousel *carouselCategory;
    NSArray *signSymbolCategories;
    NSUInteger selectedSignSymbolCategory;
    NSUInteger selectedSignSymbolCarouselIndex;
    NSUInteger selectedSignSymbolCategoryIndex;
    AWBRoadsignSymbol *selectedSignSymbol;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) iCarousel *carouselSubcategory;
@property (nonatomic, retain) iCarousel *carouselCategory;
@property (nonatomic, retain) NSArray *signSymbolCategories;
@property (nonatomic, retain) AWBRoadsignSymbol *selectedSignSymbol;

@end
