//
//  UIView+SelectionMarquee.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 28/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (SelectionMarquee)

+ (CAShapeLayer *)selectionMarqueeWithWhitePhase:(BOOL)isWhite;
- (void)showSelectionMarquee:(CAShapeLayer *)marquee;
- (void)showSelectionMarquee2:(CAShapeLayer *)marquee;

@end
