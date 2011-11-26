//
//  AWBTransformableLabel.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AWBTransformableView.h"
#import "AWBLabel.h"
#import "FontLabel.h"
#import "ZFont.h"

@interface AWBTransformableZFontLabel : UIView <AWBTransformableView> 
{
    CGFloat minScale;
    CGFloat maxScale;   
    CGFloat borderThickness;
    CGFloat maxWidth;
    CGFloat maxHeight;
    CGFloat totalHeight;
    FontLabel *labelView;
    CGFloat initialHeight;
    BOOL rotationAndScaleCurrentlyQuantised;
    CGFloat currentQuantisedScale;
    CGFloat currentQuantisedRotation;
}

@property (nonatomic, retain) FontLabel *labelView;

- (void)initialiseLayerRotation:(CGFloat)rotation scale:(CGFloat)scale;
- (id)initWithText:(NSString *)text offset:(CGPoint) point;
- (id)initWithText:(NSString *)text offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale;
- (id)initWithText:(NSString *)text font:(ZFont *)font offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment;
- (id)initWithTextLines:(NSArray *)lines font:(ZFont *)font offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment;
- (void)setTextBackgroundColor:(UIColor *)backgroundColor;
- (void)addViewShadow;
- (void)removeViewShadow;
- (void)addViewBorder;
- (void)removeViewBorder;
- (void)updateTextDimensionsWithLines:(NSArray *)lines font:(ZFont *)font;
- (void)updateLabelTextLines:(NSArray *)lines withFont:(ZFont *)font;
- (void)updateLabelTextWithFont:(ZFont *)font;

@end
