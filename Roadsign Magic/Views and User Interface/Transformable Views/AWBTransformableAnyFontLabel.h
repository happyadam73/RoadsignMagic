//
//  AWBTransformableAnyFontLabel.h
//  Roadsign Magic
//
//  Created by Buckley Adam on 16/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AWBTransformableView.h"
#import "AWBLabel.h"
#import "FontLabel.h"
#import "ZFont.h"

@interface AWBTransformableAnyFontLabel : UIView <AWBTransformableView> 
{
    CGFloat minScale;
    CGFloat maxScale;   
    CGFloat borderThickness;
    CGFloat maxWidth;
    CGFloat maxHeight;
    CGFloat totalHeight;
    CGFloat initialHeight;
    BOOL rotationCurrentlyQuantised;
    BOOL scaleCurrentlyQuantised;
    CGFloat currentQuantisedScale;
    CGFloat currentQuantisedRotation;
    CGFloat currentSnapToGridSize;
    CAShapeLayer *selectionMarquee1;
    CAShapeLayer *selectionMarquee2;
    UILabel *labelView;
    BOOL isZFontLabel;
    NSString *myFontUrl;
    UIColor *textBackgroundColor;
}

@property (nonatomic, retain) CAShapeLayer *selectionMarquee1;
@property (nonatomic, retain) CAShapeLayer *selectionMarquee2;    
@property (nonatomic, retain) UILabel *labelView;
@property (nonatomic, assign) BOOL isZFontLabel;
@property (nonatomic, assign) BOOL addTextBackground;
@property (nonatomic, retain) UIColor *textBackgroundColor;
@property (nonatomic, retain) NSString *myFontUrl;

- (void)initialiseLayerRotation:(CGFloat)rotation scale:(CGFloat)scale;
- (id)initWithText:(NSString *)text offset:(CGPoint)point;
- (id)initWithText:(NSString *)text offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale;
- (id)initWithText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment;
- (id)initWithTextLines:(NSArray *)lines fontName:(NSString *)fontName fontSize:(CGFloat)fontSize offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment;
- (id)initWithTextLines:(NSArray *)lines zFont:(ZFont *)font offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment myFontURL:(NSString *)fontURL;
- (id)initWithTextLines:(NSArray *)lines iOSFont:(UIFont *)font offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment;
- (void)addViewShadow;
- (void)removeViewShadow;
- (void)addViewBorder;
- (void)removeViewBorder;
- (void)addViewTextBackground;
- (void)removeViewTextBackground;
- (void)updateTextDimensionsWithLines:(NSArray *)lines zFont:(ZFont *)font;
- (void)updateTextDimensionsWithLines:(NSArray *)lines iOSFont:(UIFont *)font;
- (void)updateLabelTextLines:(NSArray *)lines withFontName:(NSString *)fontName fontSize:(CGFloat)fontSize;
- (void)updateLabelTextLines:(NSArray *)lines withZFont:(ZFont *)font myFontURL:(NSString *)fontURL;
- (void)updateLabelTextLines:(NSArray *)lines withiOSFont:(UIFont *)font;
- (void)updateLabelTextWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize;

@end
