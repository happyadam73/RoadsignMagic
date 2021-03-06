//
//  UIView+HitTest.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 14/08/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBTransformableView.h"

@interface UIView (HitTest)

- (UIView <AWBTransformableView> *)topTransformableViewAtPoint:(CGPoint)point; 

@end
