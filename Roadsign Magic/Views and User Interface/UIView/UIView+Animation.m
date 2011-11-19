//
//  UIView+Animation.m
//  Collage Maker
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)addSubviewWithAnimation:(UIView *)view duration:(NSTimeInterval)duration moveToPoint:(CGPoint)point
{
    [view retain];
        
    CGRect currentBounds = [view bounds];
    [view setBounds:CGRectZero];
    [view setAlpha:0.0];
    [view setCenter:[self randomViewPointWithMarginThickness:0.0]];
    
    [self addSubview:view];
    
    [UIView animateWithDuration:duration 
                          delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations: ^ {
                         [view setAlpha:1.0]; 
                         [view setBounds:currentBounds];
                         [view setCenter:point];
                     } 
                     completion: ^ (BOOL finished) {
                         [view release];
                     }];
}

- (CGPoint)randomViewPointWithMarginThickness:(CGFloat)margin
{
    CGFloat maxWidth = self.bounds.size.width - margin;
    CGFloat maxHeight = self.bounds.size.height - margin;

    return CGPointMake(AWBRandomIntInRange(margin, maxWidth), AWBRandomIntInRange(margin, maxHeight));   
}

- (CGPoint)randomViewPoint
{
    //set margin to 10% of longest screen length
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
    
    //longest width should be height, but check just in case
    CGFloat screenLength = (screenSize.height > screenSize.width ? screenSize.height : screenSize.width);
    
    return [self randomViewPointWithMarginThickness:(0.1*screenLength)];
}

@end
