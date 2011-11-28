//
//  AWBRoadsignMagicMainViewController+Gestures.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 22/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController.h"
#import "UIView+HitTest.h"
#import "UIView+Hierarchy.h"

@interface AWBRoadsignMagicMainViewController (Gestures) <UIGestureRecognizerDelegate>

- (void)initialiseGestureRecognizers;
- (void)deallocGestureRecognizers;
- (void)dereferenceGestureRecognizers;
//- (void)showSelectionMarquee:(CAShapeLayer *)marquee onTransformableView:(UIView <AWBTransformableView> *)view;
//- (void)showSelectionMarqueesOnTransformableView:(UIView <AWBTransformableView> *)view;

@end
