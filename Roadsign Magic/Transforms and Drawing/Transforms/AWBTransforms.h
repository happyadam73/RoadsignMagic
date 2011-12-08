//
//  AWBTransforms.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 11/08/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AWBTransformableView.h"
#import <stdlib.h>

CGAffineTransform AWBCGAffineTransformMakeRotationAndScale(CGFloat rotation, CGFloat scale, BOOL horizontalFlip);
CGFloat AWBDistanceBetweenTwoPoints(CGPoint point1,CGPoint point2);
CGFloat AWBAreaOfTriangle(CGPoint p0, CGPoint p1, CGPoint p2);
BOOL AWBIsPointWithinRotatedBoundsOfFramedRect(CGPoint point, CGSize rotatedRectSize, CGFloat rotation, CGSize frameRectSize);
CGPoint AWBTransformedViewCenterOffsetFromPoint(UIView <AWBTransformableView> *transformedView, CGPoint point);
int AWBRandomIntInRange(int min, int max);
CGFloat AWBCGSizeRandomScaleFromMinMaxLength(CGSize size, CGFloat minLength, CGFloat maxLength);
CGFloat AWBRandomRotationFromMinMaxRadians(CGFloat min, CGFloat max);
void AWBBuildRotatedBoundsPointsPath(CGMutablePathRef path, CGSize rotatedRectSize, CGFloat rotation, CGSize frameRectSize);
int AWBRandomSortComparitor(id obj1, id obj2, void *context );
CGFloat AWBQuantizeFloat(CGFloat value, CGFloat quantizationFactor, BOOL roundUp);
NSString *AWBImageSizeFromQualityValue(CGFloat value);
