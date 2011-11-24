//
//  AWBProgressView.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 10/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AWBBusyView : UIView {
    UIActivityIndicatorView *busyIndicator;
}

@property (nonatomic, retain) UIActivityIndicatorView *busyIndicator;

- (id)initWithText:(NSString *)labelText detailText:(NSString *)detailText parentView:(UIView *)parentView centerAtPoint:(CGPoint)point;
- (void)presentOnTopOfView:(UIView *)parentView centerAtPoint:(CGPoint)point;
- (void)removeFromParentView;

@end
