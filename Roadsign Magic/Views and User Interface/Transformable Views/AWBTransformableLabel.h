//
//  AWBTransformableLabel.h
//  CollageMaker
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AWBTransformableView.h"
#import "AWBLabel.h"

@interface AWBTransformableLabel : UIView <AWBTransformableView> 
{
    CGFloat minScale;
    CGFloat maxScale;   
    CGFloat borderThickness;
    CGFloat maxWidth;
    CGFloat maxHeight;
    CGFloat totalHeight;
    AWBLabel *labelView;
    CGFloat initialHeight;
    BOOL rotationAndScaleCurrentlyQuantised;
    CGFloat currentQuantisedScale;
    CGFloat currentQuantisedRotation;
}

@property (nonatomic, retain) AWBLabel *labelView;

- (void)initialiseLayerRotation:(CGFloat)rotation scale:(CGFloat)scale;
- (id)initWithText:(NSString *)text offset:(CGPoint) point;
- (id)initWithText:(NSString *)text offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale;
- (id)initWithText:(NSString *)text font:(UIFont *)font offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color;
- (id)initWithTextLines:(NSArray *)lines font:(UIFont *)font offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color;
- (void)setTextBackgroundColor:(UIColor *)backgroundColor;
- (void)addViewShadow;
- (void)removeViewShadow;
- (void)addViewBorder;
- (void)removeViewBorder;
- (void)updateTextDimensionsWithLines:(NSArray *)lines font:(UIFont *)font;
- (void)updateLabelTextLines:(NSArray *)lines withFont:(UIFont *)font;
- (void)updateLabelTextWithFont:(UIFont *)font;

@end
