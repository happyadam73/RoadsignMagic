//
//  UIView+HitTest.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 14/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "UIView+HitTest.h"
#import "AWBTransforms.h"

@implementation UIView (HitTest)

- (UIView <AWBTransformableView> *)topTransformableViewAtPoint:(CGPoint)point //withDistanceThreshold:(CGFloat)distance
{
    //iterate through any transformable subview in the current view (with front most views first)
    for(UIView <AWBTransformableView> *view in [[self subviews] reverseObjectEnumerator]) {
        
        //iterator will still go through every view including non transformable, so ensure conformance to the transformable protocol
        if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
            
            //CGFloat theta = [view rotationAngleInRadians]+[view pendingRotationAngleInRadians];
            CGFloat theta = [view quantisedRotation];
            CGFloat scale = [view quantisedScale];
            
            //for views with a non-zero rotation, need to use more complex hit testing to exclude external frame sections not within the rotated bounds
            if ((theta != 0.0) && (scale != 0.0)) {

                //adjust rotation angle, and hit point to have (0,0) origin in top left
                CGPoint hitPoint = CGPointMake(point.x - [view frame].origin.x, point.y - [view frame].origin.y);
                
                //adjust bounded frame size to take into account the scale transform (don't need to do this for the frame size)
                CGSize scaledBoundRectSize = CGSizeMake([view quantisedScale]*[view bounds].size.width, [view quantisedScale]*[view bounds].size.height);

                //check to see if point is within the rotated bound rectangle that sits rotated (by theta) within the outer non-rotated external frame
                if (AWBIsPointWithinRotatedBoundsOfFramedRect(hitPoint, scaledBoundRectSize, theta, [view frame].size)) {
                    return view;
                }
            
            //for non-rotated views simply check the point is in the sub-view's frame
            } else {
                if (CGRectContainsPoint([view frame], point)) {
                    return view;                
                }
            }
        }            
    }    
    
    //didn't find any view that's been hit
    return nil;
}

@end

