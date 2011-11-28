//
//  AWBRoadsignMagicMainViewController+Gestures.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 22/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController+Gestures.h"
#import "AWBRoadsignMagicMainViewController+UI.h"
#import "AWBTransforms.h"
#import "AWBTransformableView.h"
#import "AWBRoadsignMagicViewController+Edit.h"
#import "UIView+SelectionMarquee.h"
#import "CAShapeLayer+Animation.h"

@implementation AWBRoadsignMagicMainViewController (Gestures)


- (void)initialiseGestureRecognizers
{
    UIRotationGestureRecognizer *rotationRegonizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotations:)];
    self.rotationGestureRecognizer = rotationRegonizer;
    self.rotationGestureRecognizer.delegate = self;
    [rotationRegonizer release];
    [self.view addGestureRecognizer:self.rotationGestureRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    //panRecognizer.cancelsTouchesInView = NO;
    self.panGestureRecognizer = panRecognizer;
    [panRecognizer release];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinches:)];
    self.pinchGestureRecognizer = pinchRecognizer;
    self.pinchGestureRecognizer.delegate = self;
    [pinchRecognizer release];
    [self.view addGestureRecognizer:self.pinchGestureRecognizer]; 
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTaps:)];
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    doubleTapRecognizer.numberOfTapsRequired = 2;
    self.doubleTapGestureRecognizer = doubleTapRecognizer;
    [doubleTapRecognizer release];
    [self.mainScrollView addGestureRecognizer:self.doubleTapGestureRecognizer]; 
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTaps:)];
    singleTapRecognizer.numberOfTouchesRequired = 1;
    singleTapRecognizer.numberOfTapsRequired = 1;
    self.singleTapGestureRecognizer = singleTapRecognizer;
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    [singleTapRecognizer release];
    [self.mainScrollView addGestureRecognizer:self.singleTapGestureRecognizer]; 
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftAndRightSwipes:)];
    swipeRecognizer.numberOfTouchesRequired = 2;
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    self.swipeGestureRecognizer = swipeRecognizer;
    [swipeRecognizer release];
    [self.view addGestureRecognizer:self.swipeGestureRecognizer]; 
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPresses:)];
    self.longPressGestureRecognizer = longPressRecognizer;
    [longPressRecognizer release];
    [self.view addGestureRecognizer:self.longPressGestureRecognizer];
    
    UILongPressGestureRecognizer *longDoublePressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongDoublePresses:)];
    longDoublePressRecognizer.numberOfTouchesRequired = 2;
    self.longDoublePressGestureRecognizer = longDoublePressRecognizer;
    [longDoublePressRecognizer release];
    [self.view addGestureRecognizer:self.longDoublePressGestureRecognizer];
}

- (void)deallocGestureRecognizers
{
    [rotationGestureRecognizer release];
    [panGestureRecognizer release];
    [pinchGestureRecognizer release];
    [singleTapGestureRecognizer release];
    [doubleTapGestureRecognizer release];
    [swipeGestureRecognizer release];
    [longPressGestureRecognizer release];
    [longDoublePressGestureRecognizer release];
}

- (void)dereferenceGestureRecognizers
{
    self.rotationGestureRecognizer = nil;
    self.panGestureRecognizer = nil;
    self.pinchGestureRecognizer = nil;
    self.singleTapGestureRecognizer = nil;
    self.doubleTapGestureRecognizer = nil;
    self.swipeGestureRecognizer = nil; 
    self.longPressGestureRecognizer = nil;
    self.longDoublePressGestureRecognizer = nil;
}

- (void)handleRotations:(UIRotationGestureRecognizer *)paramSender
{
    if (self.isSignInEditMode || self.lockedView.objectsLocked) {
        return;
    } else {
        if (!self.navigationController.toolbarHidden) {
            [self toggleFullscreen];
        }
    }
    
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [paramSender locationInView:self.signBackgroundView]; 
        capturedView = [self.signBackgroundView topTransformableViewAtPoint:point];
    }
    
    if (capturedView) {
        [self.signBackgroundView bringSubviewToFront:capturedView];
        if (paramSender.state == UIGestureRecognizerStateBegan) {
            [capturedView applyPendingRotationToCapturedView];
        } else {
            capturedView.pendingRotationAngleInRadians = paramSender.rotation;
        }
        [capturedView rotateAndScaleWithSnapToGrid:snapToGrid gridSize:snapToGridSize]; 
        
        if ((paramSender.state == UIGestureRecognizerStateEnded) || (paramSender.state == UIGestureRecognizerStateFailed)) {
//            selectionMarquee.hidden = YES;
//            selectionMarquee2.hidden = YES;
            if (!self.isSignInEditMode) {
                [capturedView hideSelection];                
            }
        } else {
            if (!self.isSignInEditMode) {
                [capturedView showSelectionWithAnimation:YES];                
            } else {
                [capturedView showSelection];
            }
            //            [self showSelectionMarqueesOnTransformableView:capturedView];
        }

    }   
    
}

- (void)handlePinches:(UIPinchGestureRecognizer *)paramSender
{

    if (self.isSignInEditMode || self.lockedView.objectsLocked) {
        return;
    } else {
        if (!self.navigationController.toolbarHidden) {
            [self toggleFullscreen];
        }
    }
    
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [paramSender locationInView:self.signBackgroundView]; 
        capturedView = [self.signBackgroundView topTransformableViewAtPoint:point];
    }
    
    if (capturedView) {
        [self.signBackgroundView bringSubviewToFront:capturedView];
        
        if (paramSender.state == UIGestureRecognizerStateBegan && capturedView.currentScale != 0.0) {
            paramSender.scale = capturedView.currentScale;
        }  else {
            capturedView.currentScale = paramSender.scale;
        }
        [capturedView rotateAndScaleWithSnapToGrid:snapToGrid gridSize:snapToGridSize];  
        
        
        if ((paramSender.state == UIGestureRecognizerStateEnded) || (paramSender.state == UIGestureRecognizerStateFailed)) {
//            selectionMarquee.hidden = YES;
//            selectionMarquee2.hidden = YES;
            if (!self.isSignInEditMode) {
                [capturedView hideSelection];                
            }
        } else {
            if (!self.isSignInEditMode) {
                [capturedView showSelectionWithAnimation:YES];                
            } else {
                [capturedView showSelection];
            }
            //[self showSelectionMarqueesOnTransformableView:capturedView];
        }

    }
    
}


- (void)handlePanGestures:(UIPanGestureRecognizer *)paramSender
{
    if (self.lockedView.objectsLocked) {
        return;
    }
    
    if (!self.isSignInEditMode && !self.navigationController.toolbarHidden) {
        [self toggleFullscreen];
    }

    CGPoint point = [paramSender locationInView:self.signBackgroundView]; 
    
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        capturedView = [self.signBackgroundView topTransformableViewAtPoint:point];
        if (capturedView) {
            [capturedView applyPendingRotationToCapturedView];
            capturedCenterOffset = AWBTransformedViewCenterOffsetFromPoint(capturedView, [paramSender locationInView:capturedView]);
        }
    }
    
    if (capturedView) {
        [self.signBackgroundView bringSubviewToFront:capturedView];        
        if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed) { 
            CGFloat x = point.x - capturedCenterOffset.x;
            CGFloat y = point.y - capturedCenterOffset.y;
            if (snapToGrid && (snapToGridSize > 0.0)) {
                x = AWBQuantizeFloat(x, (snapToGridSize/2.0), NO);
                y = AWBQuantizeFloat(y, (snapToGridSize/2.0), NO);                
            }
            
            capturedView.center = CGPointMake(x, y);
            
            if (!self.isSignInEditMode) {
                [capturedView showSelectionWithAnimation:YES];                
            } else {
                [capturedView showSelection];
            }
            //[self showSelectionMarqueesOnTransformableView:capturedView];
        } else {
            if (!self.isSignInEditMode) {
                [capturedView hideSelection];                
            }
//            selectionMarquee.hidden = YES;
//            selectionMarquee2.hidden = YES;
        }
    }
}

- (void)handleSingleTaps:(UITapGestureRecognizer *)paramSender
{
    if (self.isSignInEditMode) {
        CGPoint point = [paramSender locationInView:self.signBackgroundView]; 
        UIView <AWBTransformableView> *view = [self.signBackgroundView topTransformableViewAtPoint:point];
        if (view) {
            [self objectTappedInEditMode:view];            
        }
    } else {
        [self toggleFullscreen];
    }
}

- (void)handleDoubleTaps:(UITapGestureRecognizer *)paramSender
{
    if (!self.isSignInEditMode && !self.navigationController.toolbarHidden) {
        [self toggleFullscreen];
    }
    
    if ((paramSender.state == UIGestureRecognizerStateEnded) && (mainScrollView.minimumZoomScale != mainScrollView.maximumZoomScale)) {
        CGPoint point = [paramSender locationInView:self.mainScrollView];
        if (CGRectContainsPoint(self.signBackgroundView.frame, point)) {
            float newScale;
            if (mainScrollView.zoomScale == mainScrollView.minimumZoomScale) {
                newScale = mainScrollView.maximumZoomScale;
            } else {
                newScale = mainScrollView.minimumZoomScale;
            }
            
            CGPoint centerPoint = [self.signBackgroundView convertPoint:point fromView:mainScrollView];
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:centerPoint];
            [mainScrollView zoomToRect:zoomRect animated:YES];
        }
    }
}

- (void)handleLeftAndRightSwipes:(UISwipeGestureRecognizer *)paramSender
{
    if (self.isSignInEditMode || self.lockedView.objectsLocked) {
        return;
    } else {
        if (!self.navigationController.toolbarHidden) {
            [self toggleFullscreen];
        }
    }
    
    CGPoint point = [paramSender locationInView:self.signBackgroundView]; 
    UIView <AWBTransformableView> *view = [self.signBackgroundView topTransformableViewAtPoint:point];
    
    if (view) {
        view.horizontalFlip = view.horizontalFlip ? NO : YES; 
        [view rotateAndScaleWithSnapToGrid:snapToGrid gridSize:snapToGridSize];       
    }
}

- (void)handleLongPresses:(UILongPressGestureRecognizer *)paramSender
{
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        lockedView.canvasAnchored = !lockedView.canvasAnchored;
        mainScrollView.scrollEnabled = !lockedView.canvasAnchored;
    }
}

- (void)handleLongDoublePresses:(UILongPressGestureRecognizer *)paramSender
{
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        lockedView.objectsLocked = !lockedView.objectsLocked;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer 
{
    if ((gestureRecognizer == self.pinchGestureRecognizer) || (gestureRecognizer == self.rotationGestureRecognizer)) {
        if ((otherGestureRecognizer == self.pinchGestureRecognizer) || (otherGestureRecognizer == self.rotationGestureRecognizer)) {
            return YES;
        }
    }
    return NO;
}

//- (CAShapeLayer *)selectionMarquee
//{
//    if (!selectionMarquee) {
//        selectionMarquee = [[CAShapeLayer layer] retain];
//        selectionMarquee.fillColor = [[UIColor clearColor] CGColor];
//        selectionMarquee.strokeColor = [[UIColor whiteColor] CGColor];
//        selectionMarquee.lineWidth = 3.0f;
//        selectionMarquee.lineJoin = kCALineJoinRound;
//        selectionMarquee.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
//        selectionMarquee.bounds = CGRectZero;
//        selectionMarquee.position = CGPointZero;
//    }
//    
//    return selectionMarquee;
//}
//
//- (CAShapeLayer *)selectionMarquee2
//{
//    if (!selectionMarquee2) {
//        selectionMarquee2 = [[CAShapeLayer layer] retain];
//        selectionMarquee2.fillColor = [[UIColor clearColor] CGColor];
//        selectionMarquee2.strokeColor = [[UIColor blackColor] CGColor];
//        selectionMarquee2.lineWidth = 3.0f;
//        selectionMarquee2.lineJoin = kCALineJoinRound;
//        selectionMarquee2.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:10], nil];
//        selectionMarquee2.bounds = CGRectZero;
//        selectionMarquee2.position = CGPointZero;
//    }
//    
//    return selectionMarquee2;
//}

//- (void)showSelectionMarqueesOnTransformableView:(UIView <AWBTransformableView> *)view
//{
//    [self showSelectionMarquee:self.selectionMarquee onTransformableView:view];
//    [self showSelectionMarquee:self.selectionMarquee2 onTransformableView:view];
//}
//
//- (void)showSelectionMarquee:(CAShapeLayer *)marquee onTransformableView:(UIView <AWBTransformableView> *)view
//{    
//    if (![marquee actionForKey:@"linePhase"]) {
//        CABasicAnimation *dashAnimation;
//        dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
//        [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
//        [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
//        [dashAnimation setDuration:0.25f];
//        [dashAnimation setRepeatCount:HUGE_VALF];
//        [marquee addAnimation:dashAnimation forKey:@"linePhase"];
//    }
//    
//    CGRect frame = view.frame;
//    marquee.bounds = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
//    marquee.position = CGPointMake(frame.origin.x, frame.origin.y);
//    
////    CGAffineTransform transform = view.transform;
//    
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, frame);        
//    [marquee setPath:path];
//    CGPathRelease(path);
//    
//    marquee.hidden = NO;
//}
//

@end
