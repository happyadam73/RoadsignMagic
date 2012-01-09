//
//  UIApplication+AppDimensions.h
//  Roadsign Magic
//
//  Created by Buckley Adam on 06/01/2012.
//  Copyright (c) 2012 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIApplication (AppDimensions)

+(CGSize) currentSize;
+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation;

@end
