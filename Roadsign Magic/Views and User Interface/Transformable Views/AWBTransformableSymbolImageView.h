//
//  AWBTransformableImageView.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBTransformableView.h"
#import "AWBTransforms.h"

@interface AWBTransformableSymbolImageView : UIView <AWBTransformableView>
{
    CGFloat minScale;
    CGFloat maxScale;
//    NSString *imageKey;
    CGFloat borderThickness;
    CGFloat shadowOffset;
    UIImageView *imageView;
    CGFloat initialHeight;
    BOOL rotationAndScaleCurrentlyQuantised;
    CGFloat currentQuantisedScale;
    CGFloat currentQuantisedRotation;
    CAShapeLayer *selectionMarquee1;
    CAShapeLayer *selectionMarquee2;    
}

//@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, retain) UIImageView *imageView; 
@property (nonatomic, retain) CAShapeLayer *selectionMarquee1;
@property (nonatomic, retain) CAShapeLayer *selectionMarquee2;    

//- (void)initialiseLayerRotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip imageKey:(NSString *)key imageDocsSubDir:(NSString *)subDir;
- (void)initialiseLayerRotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip;
- (id)initWithImage:(UIImage *)image rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip;
//- (id)initWithImage:(UIImage *)image rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip imageKey:(NSString *)key imageDocsSubDir:(NSString *)subDir;
- (id)initRandomWithImage:(UIImage *)image;
- (id)initRandomWithImage:(UIImage *)image minLengthPercentage:(CGFloat)minPerc maxLengthPercentage:(CGFloat)maxPerc minAngle:(CGFloat)minAngle maxAngle:(CGFloat)maxAngle;
//- (void)initialiseImageKeyWithDocsSubdirPath:(NSString *)dirPath;
//- (void)removeImageFromFilesystem;
- (void)addViewShadow;
- (void)removeViewShadow;
- (void)addViewBorder;
- (void)removeViewBorder;

@end
