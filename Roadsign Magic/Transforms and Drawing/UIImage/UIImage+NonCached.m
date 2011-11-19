//
//  UIImage+NonCached.m
//  Collage Maker
//
//  Created by Adam Buckley on 09/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "UIImage+NonCached.h"

@implementation UIImage (NonCached)

+ (UIImage*)imageFromFile:(NSString*)aFileName 
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", bundlePath, aFileName]];
}

@end
