//
//  AWBTransformableImageView.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBTransformableView.h"
#import "AWBTransforms.h"
#import "AWBRoadsignSymbol.h"

@interface AWBTransformableSymbolImageView : UIView <AWBTransformableView>
{
    CGFloat minScale;
    CGFloat maxScale;
    CGFloat borderThickness;
    CGFloat shadowOffset;
    UIImageView *imageView;
    CGFloat initialHeight;
//    BOOL rotationAndScaleCurrentlyQuantised;
    BOOL rotationCurrentlyQuantised;
    BOOL scaleCurrentlyQuantised;
    CGFloat currentQuantisedScale;
    CGFloat currentQuantisedRotation;
    CAShapeLayer *selectionMarquee1;
    CAShapeLayer *selectionMarquee2;
    AWBRoadsignSymbol *roadsignSymbol;
}

@property (nonatomic, retain) UIImageView *imageView; 
@property (nonatomic, retain) CAShapeLayer *selectionMarquee1;
@property (nonatomic, retain) CAShapeLayer *selectionMarquee2;    
@property (nonatomic, retain) AWBRoadsignSymbol *roadsignSymbol;

- (void)initialiseLayerRotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip;
- (id)initWithSymbol:(AWBRoadsignSymbol *)symbol;
- (id)initWithSymbol:(AWBRoadsignSymbol *)symbol rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip;
- (id)initWithImage:(UIImage *)image rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip;
- (void)addViewShadow;
- (void)removeViewShadow;
- (void)addViewBorder;
- (void)removeViewBorder;

@end
