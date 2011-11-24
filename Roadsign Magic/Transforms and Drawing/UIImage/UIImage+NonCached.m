//
//  UIImage+NonCached.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 09/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "UIImage+NonCached.h"

@implementation UIImage (NonCached)

+ (UIImage*)imageFromFile:(NSString*)aFileName 
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *imageFilename = [NSString stringWithFormat:@"%@/%@", bundlePath, aFileName];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilename];
    if (!image) {
//        NSString *pathExtension = [imageFilename pathExtension];
//        NSString *alternativeFilename = [imageFilename stringByDeletingPathExtension];
//        NSString *newFilename = [NSString stringWithFormat:@"%@@2x.%@", alternativeFilename, pathExtension];
//        NSLog(@"%@", newFilename);
        image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@@2x.%@", [imageFilename stringByDeletingPathExtension], [imageFilename pathExtension]]];
//        if (image && (image.scale > 1.0)) {
//            image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
//        }
    }
//    NSLog(@"Image Scale: %f", image.scale);
    return image;
}

@end
