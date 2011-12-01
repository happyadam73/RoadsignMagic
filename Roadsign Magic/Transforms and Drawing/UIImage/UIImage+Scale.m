//
//  UIImage+Scale.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

- (UIImage *)imageScaledToMaxResolution:(int)maxPixels withTransparentBorderThickness:(CGFloat)borderPixels
{
    UIImage *image = self;
    if (image.size.width * image.size.height > maxPixels) {
        // calculate the scaling factor that will reduce the image size to maxPixels
        float actualHeight = image.size.height;
        float actualWidth = image.size.width;
        float scale = sqrt(image.size.width * image.size.height / maxPixels);
        
        // resize the image
        CGRect rect = CGRectMake(0.0, 0.0, floorf(actualWidth / scale), floorf(actualHeight / scale));
        UIGraphicsBeginImageContext(rect.size);
        //UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
        [image drawInRect:CGRectMake(borderPixels, borderPixels, floorf(actualWidth / scale) - (2.0 * borderPixels), floorf(actualHeight / scale) - (2.0 * borderPixels))];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();      
    }
    return image;
}

- (CGFloat)scaleRequiredForMaxResolution:(int)maxPixels
{
    CGFloat scale = 1.0;
    UIImage *image = self;
    if ((image.size.width * image.size.height) > maxPixels) {
        scale = sqrt(image.size.width * image.size.height / maxPixels);
    }
    return scale;   
}

- (UIImage *)imageBorderedWithColor:(UIColor *)color thickness:(CGFloat)borderPixels
{
    UIImage *image = self;
    
    // calculate the scaling factor that will reduce the image size to maxPixels
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth + (2.0 * borderPixels), actualHeight + (2.0 * borderPixels));
    UIGraphicsBeginImageContext(rect.size);
    [color setFill];
    UIRectFill(rect);
    [image drawInRect:CGRectMake(borderPixels, borderPixels, actualWidth, actualHeight)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();      
    
    return image;
}

- (UIImage *)imageBorderedWithColor:(UIColor *)color thickness:(CGFloat)borderPixels transparentEdgeThickness:(CGFloat)edgePixels
{
    UIImage *image = self;
    
    // calculate the scaling factor that will reduce the image size to maxPixels
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth + (2.0 * borderPixels) + (2.0 * edgePixels), actualHeight + (2.0 * borderPixels) + (2.0 * edgePixels));
    UIGraphicsBeginImageContext(rect.size);
    [color setFill];
    UIRectFill(CGRectMake(edgePixels, edgePixels, actualWidth + (2.0 * borderPixels), actualHeight + (2.0 * borderPixels)));
    [image drawInRect:CGRectMake(borderPixels+edgePixels, borderPixels+edgePixels, actualWidth, actualHeight)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();      
    
    return image;
}

@end
