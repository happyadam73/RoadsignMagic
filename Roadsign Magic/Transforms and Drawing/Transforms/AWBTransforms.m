//
//  AWBTransforms.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 11/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBTransforms.h"

CGAffineTransform AWBCGAffineTransformMakeRotationAndScale(CGFloat rotation, CGFloat scale, BOOL horizontalFlip)
{
    if (scale <= 0.0 || scale == NAN) {
        scale = 1.0;
    }    

    return CGAffineTransformScale(CGAffineTransformMakeRotation(rotation), horizontalFlip? -scale : scale, scale);
}

CGFloat AWBDistanceBetweenTwoPoints(CGPoint point1,CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
}

//returns area of a triangle made of the points p0, p1 and p2 - note can return negative or positive
CGFloat AWBAreaOfTriangle(CGPoint p0, CGPoint p1, CGPoint p2)
{
    return (0.5 * ((p1.x * p2.y) - (p1.y * p2.x) - (p0.x * p2.y) + (p0.y * p2.x) + (p0.x * p1.y) - (p0.y * p1.x)));
}

//returns true if the point is within the rotated rectangle (rotatedRectSize) that is rotated by theta (radians) within
//the non-rotated external frame (frameRectSize)
BOOL AWBIsPointWithinRotatedBoundsOfFramedRect(CGPoint point, CGSize rotatedRectSize, CGFloat rotation, CGSize frameRectSize)
{
    CGFloat theta = rotation;
    
    theta = fmodf(theta, M_PI_2);   
    if (theta < 0) {
        theta = -theta;
    } else {
        theta = M_PI_2 - theta;
    }
    
    BOOL flipWidthAndHeight = ((int)(floorf(rotation/M_PI_2))%2)==0;
    
    CGFloat hb = rotatedRectSize.height;
    CGFloat wb = rotatedRectSize.width;
    CGFloat hf = frameRectSize.height;
    CGFloat wf = frameRectSize.width;
    
    if (flipWidthAndHeight) {
        hb = rotatedRectSize.width;
        wb = rotatedRectSize.height;
    }
        
    //convert hit point into standard cartesian co-ordinates with (0,0) at bottom left of frameRectSize
    CGPoint p = CGPointMake(point.x, hf - point.y);
    
    //calculate the 4 points of the rotated rectangle (p1->p2->p3->p4) - again (0,0) at bottom left
    CGPoint p1 = CGPointMake(hb * sinf(theta), 0);
    CGPoint p2 = CGPointMake(0, hb * cosf(theta));
    CGPoint p3 = CGPointMake(wb * cosf(theta), hf);
    CGPoint p4 = CGPointMake(wf, wb * sinf(theta));
    
    //calculate the 4 triangular areas
    CGFloat a1 = AWBAreaOfTriangle(p1, p2, p);
    CGFloat a2 = AWBAreaOfTriangle(p2, p3, p);
    CGFloat a3 = AWBAreaOfTriangle(p3, p4, p);
    CGFloat a4 = AWBAreaOfTriangle(p4, p1, p);
    
    //if all are negative then we have a hit
    if ((a1 < 0) && (a2 < 0) && (a3 < 0) && (a4 < 0)) {
        return YES;
    } else {
        return NO;
    }   
    
}

//returns true if the point is within the rotated rectangle (rotatedRectSize) that is rotated by theta (radians) within
//the non-rotated external frame (frameRectSize)
void AWBBuildRotatedBoundsPointsPath(CGMutablePathRef path, CGSize rotatedRectSize, CGFloat rotation, CGSize frameRectSize)
{
    CGFloat theta = rotation;
    
    theta = fmodf(theta, M_PI_2);   
    if (theta < 0) {
        theta = -theta;
    } else {
        theta = M_PI_2 - theta;
    }
    
    BOOL flipWidthAndHeight = ((int)(floorf(rotation/M_PI_2))%2)==0;
    
    CGFloat hb = rotatedRectSize.height;
    CGFloat wb = rotatedRectSize.width;
    CGFloat hf = frameRectSize.height;
    CGFloat wf = frameRectSize.width;
    
    if (flipWidthAndHeight) {
        hb = rotatedRectSize.width;
        wb = rotatedRectSize.height;
    }
    
    CGPoint points[5];
    
    //calculate the 4 points of the rotated rectangle (p1->p2->p3->p4) - again (0,0) at bottom left
    points[0] = CGPointMake(hb * sinf(theta), hf);
    points[1] = CGPointMake(0, wb * sinf(theta));
    points[2] = CGPointMake(wb * cosf(theta), 0);
    points[3] = CGPointMake(wf, hb * cosf(theta));
    points[4] = points[0];

    CGPathAddLines(path, NULL, points, 5);
}


CGPoint AWBTransformedViewCenterOffsetFromPoint(UIView <AWBTransformableView> *transformedView, CGPoint point)
{
    CGFloat deltaX = ([transformedView horizontalFlip]? -1 : 1) * [transformedView quantisedScale] * (point.x - (transformedView.bounds.size.width/2.0));
    CGFloat deltaY = [transformedView quantisedScale] * (point.y - (transformedView.bounds.size.height/2.0));
    CGFloat rotatedDeltaX = (deltaX * cosf([transformedView quantisedRotation])) - (deltaY * sinf([transformedView quantisedRotation]));
    CGFloat rotatedDeltaY = (deltaX * sinf([transformedView quantisedRotation])) + (deltaY * cosf([transformedView quantisedRotation]));
    
    return CGPointMake(rotatedDeltaX, rotatedDeltaY);
}

int AWBRandomIntInRange(int min, int max)
{
    if (arc4random_uniform != NULL) {
        return min + arc4random_uniform((max-min)+1);
    } else {
        return min + (arc4random() % ((max-min)+1));
    }
}

CGFloat AWBCGSizeRandomScaleFromMinMaxLength(CGSize size, CGFloat minLength, CGFloat maxLength)
{
    CGFloat maxSizeLength = (size.width > size.height? size.width : size.height);
    CGFloat randomLength = AWBRandomIntInRange(minLength, maxLength);
    return (randomLength/maxSizeLength);
}

CGFloat AWBRandomRotationFromMinMaxRadians(CGFloat min, CGFloat max)
{
    //convert into degress to get range with better units (since it's integer range)
    CGFloat radsToDegs = (180.0/M_PI);
    int randomDegrees = AWBRandomIntInRange(min*radsToDegs, max*radsToDegs);
    return (randomDegrees/radsToDegs);
}

int AWBRandomSortComparitor(id obj1, id obj2, void *context ) 
{
    return (AWBRandomIntInRange(0, 2)-1);
}

CGFloat AWBQuantizeFloat(CGFloat value, CGFloat quantizationFactor, BOOL roundUp)
{
    if (roundUp) {
        return (quantizationFactor * ceilf(value/quantizationFactor));        
    } else {
        return (quantizationFactor * floorf(value/quantizationFactor));
    }
}

NSString *AWBScreenSizeFromQualityValue(CGFloat value)
{
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;    
    
    return [NSString stringWithFormat:@"%d x %d", (int)(screenSize.height * value), (int)(screenSize.width * value)];
}
