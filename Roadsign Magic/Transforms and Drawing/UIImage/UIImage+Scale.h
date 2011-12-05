//
//  UIImage+Scale.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Scale)

- (UIImage *)imageScaledToMaxResolution:(int)maxPixels withTransparentBorderThickness:(CGFloat)borderPixels;
- (CGFloat)scaleRequiredForMaxResolution:(int)maxPixels;
- (UIImage *)imageBorderedWithColor:(UIColor *)color thickness:(CGFloat)borderPixels;
- (UIImage *)imageBorderedWithColor:(UIColor *)color thickness:(CGFloat)borderPixels transparentEdgeThickness:(CGFloat)edgePixels;

@end
