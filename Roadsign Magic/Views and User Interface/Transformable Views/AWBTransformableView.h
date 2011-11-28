//
//  AWBTransformableView.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@protocol AWBTransformableView	
@required
@property (assign) CGFloat rotationAngleInRadians;
@property (assign) CGFloat pendingRotationAngleInRadians;
@property (assign) CGFloat currentScale;
@property (assign) BOOL horizontalFlip;
@property (readonly) CGFloat quantisedRotation;
@property (readonly) CGFloat quantisedScale;
@property (nonatomic, retain) UIColor *viewBorderColor;
@property (nonatomic, retain) UIColor *viewShadowColor;
@property (nonatomic, assign) BOOL addShadow;
@property (nonatomic, assign) BOOL addBorder;
@property (nonatomic, assign) BOOL roundedBorder;

- (void)rotateAndScale;
- (void)rotateAndScaleWithSnapToGrid:(BOOL)snapToGrid gridSize:(CGFloat)gridSize;
- (void)applyPendingRotationToCapturedView;
- (void)initialiseForSelection;
- (void)removeSelection;
- (void)showSelection;
- (void)showSelectionWithAnimation:(BOOL)animateSelection;
- (void)hideSelection;
- (void)startSelectionAnimation;
- (void)stopSelectionAnimation;
- (void)setSelectionOpacity:(CGFloat)opacity;

@end
