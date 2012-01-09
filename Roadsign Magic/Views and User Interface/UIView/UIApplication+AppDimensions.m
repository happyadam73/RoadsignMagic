//
//  UIApplication+AppDimensions.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 06/01/2012.
//  Copyright (c) 2012 Callcredit. All rights reserved.
//

#import "UIApplication+AppDimensions.h"

@implementation UIApplication (AppDimensions)

+(CGSize) currentSize
{
    return [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSLog(@"Width: %f  Height: %f", size.width, size.height);
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    return size;
}

@end
