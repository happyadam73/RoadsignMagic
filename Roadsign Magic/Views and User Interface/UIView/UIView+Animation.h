//
//  UIView+Animation.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Animation)

- (void)addSubviewWithAnimation:(UIView *)view duration:(NSTimeInterval)duration moveToPoint:(CGPoint)point;
- (CGPoint)randomViewPointWithMarginThickness:(CGFloat)margin;
- (CGPoint)randomViewPoint;

@end
