//
//  CAShapeLayer+Animation.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 28/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "CAShapeLayer+Animation.h"

@implementation CAShapeLayer (Animation)

- (void)addDashAnimation
{    
    if (![self actionForKey:@"linePhase"]) {
        CABasicAnimation *dashAnimation;
        dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
        [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
        [dashAnimation setDuration:0.25f];
        [dashAnimation setRepeatCount:HUGE_VALF];
        [self addAnimation:dashAnimation forKey:@"linePhase"];
    }
}

- (void)removeDashAnimation
{
    if (![self actionForKey:@"linePhase"]) {
        [self removeAnimationForKey:@"linePhase"];
    }    
}

@end
