//
//  UIImage+NonCached.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 09/10/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "UIImage+NonCached.h"

@implementation UIImage (NonCached)

+ (UIImage*)imageFromFile:(NSString*)aFileName 
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *imageFilename = [NSString stringWithFormat:@"%@/%@", bundlePath, aFileName];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilename];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@@2x.%@", [imageFilename stringByDeletingPathExtension], [imageFilename pathExtension]]];
    }
    return image;
}

@end
