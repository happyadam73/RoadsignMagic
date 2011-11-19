//
//  AWBTransformableImageView.h
//  CollageMaker
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBTransformableView.h"
#import "AWBTransforms.h"

@interface AWBTransformableImageView : UIView <AWBTransformableView>
{
    CGFloat minScale;
    CGFloat maxScale;
    NSString *imageKey;
    CGFloat borderThickness;
    CGFloat shadowOffset;
    UIImageView *imageView;
    CGFloat initialHeight;
    BOOL rotationAndScaleCurrentlyQuantised;
    CGFloat currentQuantisedScale;
    CGFloat currentQuantisedRotation;
}

@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, retain) UIImageView *imageView; 

- (void)initialiseLayerRotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip imageKey:(NSString *)key imageDocsSubDir:(NSString *)subDir;
- (id)initWithImage:(UIImage *)image rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip imageKey:(NSString *)key imageDocsSubDir:(NSString *)subDir;
- (id)initRandomWithImage:(UIImage *)image imageDocsSubDir:(NSString *)subDir;
- (id)initRandomWithImage:(UIImage *)image imageDocsSubDir:(NSString *)subDir minLengthPercentage:(CGFloat)minPerc maxLengthPercentage:(CGFloat)maxPerc minAngle:(CGFloat)minAngle maxAngle:(CGFloat)maxAngle;
- (void)initialiseImageKeyWithDocsSubdirPath:(NSString *)dirPath;
- (void)removeImageFromFilesystem;
- (void)addViewShadow;
- (void)removeViewShadow;
- (void)addViewBorder;
- (void)removeViewBorder;

@end
