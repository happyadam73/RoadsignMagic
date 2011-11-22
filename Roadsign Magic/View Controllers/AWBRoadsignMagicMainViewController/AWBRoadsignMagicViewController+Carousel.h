//
//  AWBRoadsignMagicViewController+Carousel.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 21/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBRoadsignMagicMainViewController.h"

@interface AWBRoadsignMagicMainViewController (Carousel) <iCarouselDataSource, iCarouselDelegate>
- (void)initialiseCarousel;
@end

@interface NSString (LeftPadding)
- (NSString *)stringByPaddingTheLeftToLength:(NSUInteger) newLength withString:(NSString *) padString startingAtIndex:(NSUInteger) padIndex;
@end
