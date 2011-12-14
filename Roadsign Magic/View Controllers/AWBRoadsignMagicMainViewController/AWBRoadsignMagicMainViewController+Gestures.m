//
//  AWBRoadsignMagicMainViewController+Gestures.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 22/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
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
    
//    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPresses:)];
//    self.longPressGestureRecognizer = longPressRecognizer;
//    [longPressRecognizer release];
//    [self.view addGestureRecognizer:self.longPressGestureRecognizer];
    
//    UILongPressGestureRecognizer *longDoublePressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongDoublePresses:)];
//    longDoublePressRecognizer.numberOfTouchesRequired = 2;
//    self.longDoublePressGestureRecognizer = longDoublePressRecognizer;
//    [longDoublePressRecognizer release];
//    [self.view addGestureRecognizer:self.longDoublePressGestureRecognizer];
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
        if (!currentlyPinching) {
            CGPoint point = [paramSender locationInView:self.signBackgroundView]; 
            capturedView = [self.signBackgroundView topTransformableViewAtPoint:point];            
        }
    }
    
    if (capturedView) {
        if (paramSender.state == UIGestureRecognizerStateBegan) {
            currentlyRotating = YES;
        }
        [self.signBackgroundView bringSubviewToFront:capturedView];
        if (paramSender.state == UIGestureRecognizerStateBegan) {
            [capturedView applyPendingRotationToCapturedView];
        } else {
            capturedView.pendingRotationAngleInRadians = paramSender.rotation;
        }
        [capturedView rotateAndScaleWithSnapToGrid:snapToGrid gridSize:snapToGridSize snapRotation:snapRotation]; 
        
        if ((paramSender.state == UIGestureRecognizerStateEnded) || (paramSender.state == UIGestureRecognizerStateFailed) || (paramSender.state == UIGestureRecognizerStateCancelled)) {
            currentlyRotating = NO;
            if (!self.isSignInEditMode) {
                [capturedView hideSelection];                
            }
        } else {
            if (!self.isSignInEditMode) {
                [capturedView showSelectionWithAnimation:YES];                
            } else {
                [capturedView showSelection];
            }
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

        if (!currentlyRotating) {
            CGPoint point = [paramSender locationInView:self.signBackgroundView]; 
            capturedView = [self.signBackgroundView topTransformableViewAtPoint:point];            
        }
    }
    
    if (capturedView) {
        if (paramSender.state == UIGestureRecognizerStateBegan) {
            currentlyPinching = YES;
        }
        
        [self.signBackgroundView bringSubviewToFront:capturedView];
        
        if (paramSender.state == UIGestureRecognizerStateBegan && capturedView.currentScale != 0.0) {
            paramSender.scale = capturedView.currentScale;
        }  else {
            capturedView.currentScale = paramSender.scale;
        }
        [capturedView rotateAndScaleWithSnapToGrid:snapToGrid gridSize:snapToGridSize snapRotation:snapRotation];  
        
        
        if ((paramSender.state == UIGestureRecognizerStateEnded) || (paramSender.state == UIGestureRecognizerStateFailed) || (paramSender.state == UIGestureRecognizerStateCancelled)) {
            currentlyPinching = NO;
            if (!self.isSignInEditMode) {
                [capturedView hideSelection];                
            }
        } else {
            if (!self.isSignInEditMode) {
                [capturedView showSelectionWithAnimation:YES];                
            } else {
                [capturedView showSelection];
            }
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
        if ((paramSender.state != UIGestureRecognizerStateEnded) && (paramSender.state != UIGestureRecognizerStateFailed) && (paramSender.state != UIGestureRecognizerStateCancelled)) { 
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
        } else {
            if (!self.isSignInEditMode) {
                [capturedView hideSelection];                
            }
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
                newScale = 1.0;
            } else if (mainScrollView.zoomScale == 1.0) {
                newScale = mainScrollView.maximumZoomScale;
            } else  {
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
        [view rotateAndScaleWithSnapToGrid:snapToGrid gridSize:snapToGridSize snapRotation:snapRotation];       
    }
}

- (void)handleLongPresses:(UILongPressGestureRecognizer *)paramSender
{
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        if (!self.isSignInEditMode && self.navigationController.toolbarHidden) {
            [self toggleFullscreen];
        }
        lockedView.canvasAnchored = !lockedView.canvasAnchored;
        mainScrollView.scrollEnabled = !lockedView.canvasAnchored;
    }
}

- (void)handleLongDoublePresses:(UILongPressGestureRecognizer *)paramSender
{
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        if (!self.isSignInEditMode && self.navigationController.toolbarHidden) {
            [self toggleFullscreen];
        }
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

@end
