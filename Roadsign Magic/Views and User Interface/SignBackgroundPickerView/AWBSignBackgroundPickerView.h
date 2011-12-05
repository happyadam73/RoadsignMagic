//
//  AWBSignBackgroundPickerView.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 28/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "AWBRoadsignBackground.h"

@class AWBSignBackgroundPickerView;

@protocol AWBSignBackgroundPickerViewDelegate
@optional
- (void)awbSignBackgroundPickerView:(AWBSignBackgroundPickerView *)backgroundPicker didSelectSignBackground:(AWBRoadsignBackground *)signBackground;
@end

@interface AWBSignBackgroundPickerView : UIView <iCarouselDataSource, iCarouselDelegate> {
    id delegate;
    iCarousel *carouselSubcategory;
    iCarousel *carouselCategory;
    NSArray *signBackgroundCategories;
    NSUInteger selectedSignBackgroundCategory;
    NSUInteger selectedSignBackgroundCarouselIndex;
    NSUInteger selectedSignBackgroundCategoryIndex;
    AWBRoadsignBackground *selectedSignBackground;
    
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) iCarousel *carouselSubcategory;
@property (nonatomic, retain) iCarousel *carouselCategory;
@property (nonatomic, retain) NSArray *signBackgroundCategories;
@property (nonatomic, retain) AWBRoadsignBackground *selectedSignBackground;

@end
