//
//  UIView+SelectionMarquee.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 28/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "UIView+SelectionMarquee.h"

@implementation UIView (SelectionMarquee)

+ (CAShapeLayer *)selectionMarqueeWithWhitePhase:(BOOL)isWhite
{
    CAShapeLayer *selectionMarquee = [CAShapeLayer layer];
    
    if (selectionMarquee) {
        selectionMarquee.fillColor = [[UIColor clearColor] CGColor];
        selectionMarquee.strokeColor = (isWhite ? [[UIColor whiteColor] CGColor] : [[UIColor blackColor] CGColor]);
        selectionMarquee.lineWidth = 3.0f;
        selectionMarquee.lineJoin = kCALineJoinRound;
        selectionMarquee.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:(isWhite ? 10 : 5)],[NSNumber numberWithInt:(isWhite ? 5 : 10)], nil];

//        selectionMarquee.lineWidth = 60.0f;
//        selectionMarquee.lineJoin = kCALineJoinRound;
//        selectionMarquee.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:(isWhite ? 200 : 100)],[NSNumber numberWithInt:(isWhite ? 100 : 200)], nil];
        
        selectionMarquee.bounds = CGRectZero;
        selectionMarquee.position = CGPointZero;        
    }

    return selectionMarquee;
}

- (void)showSelectionMarquee:(CAShapeLayer *)marquee
{    
    CGRect frame = self.frame;    
    marquee.bounds = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
    marquee.position = CGPointMake(frame.origin.x, frame.origin.y);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, frame);        
    [marquee setPath:path];
    CGPathRelease(path);
    marquee.hidden = NO;
}

- (void)showSelectionMarquee2:(CAShapeLayer *)marquee
{    
    CGRect frame = self.bounds;    
    marquee.bounds = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
    marquee.position = CGPointMake(frame.origin.x, frame.origin.y);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, frame);        
    [marquee setPath:path];
    CGPathRelease(path);
    marquee.hidden = NO;
}

@end
