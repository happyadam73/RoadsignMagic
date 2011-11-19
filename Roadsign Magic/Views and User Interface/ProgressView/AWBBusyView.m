//
//  AWBProgressView.m
//  Collage Maker
//
//  Created by Adam Buckley on 10/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBBusyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AWBBusyView

@synthesize busyIndicator;

- (id)initWithText:(NSString *)labelText detailText:(NSString *)detailText parentView:(UIView *)parentView centerAtPoint:(CGPoint)point;
{
    
    CGFloat maxLabelWidth = 180.0;
    CGFloat frameHeight = 70.0;
    CGFloat labelWidth = 0.0;

    if (labelText != nil) {
        labelWidth = [labelText sizeWithFont:[UIFont systemFontOfSize:16.0]].width;
        if (labelWidth > maxLabelWidth) {
            maxLabelWidth = labelWidth;
        }
        frameHeight += 30.0;
    }
    
    if (detailText != nil) {
        labelWidth = [detailText sizeWithFont:[UIFont systemFontOfSize:14.0]].width;
        if (labelWidth > maxLabelWidth) {
            maxLabelWidth = labelWidth;
        }
        frameHeight += 26.0;
    }
    
    self = [super initWithFrame:CGRectMake(0.0, 0.0, maxLabelWidth + 20.0, frameHeight)];    

    if (self) {
        // Initialization code
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = CGPointMake(100.0, 35.0);
        indicator.hidesWhenStopped = YES;
        self.busyIndicator = indicator;
        [indicator release];
        
        self.backgroundColor = [UIColor darkGrayColor];
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.borderWidth = 2.0;
        self.layer.cornerRadius = 8.0;
        [self addSubview:self.busyIndicator];
        
        CGFloat currentY = 70.0;
        if (labelText) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, currentY, maxLabelWidth, 20.0)];
            label.textAlignment = UITextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.text = labelText;
            label.font = [UIFont systemFontOfSize:16.0];
            label.backgroundColor = [UIColor darkGrayColor];
            [self addSubview:label];
            [label release]; 
            currentY += 25.0;
        }

        if (detailText) {
            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, currentY, maxLabelWidth, 18.0)];
            detailLabel.textAlignment = UITextAlignmentCenter;
            detailLabel.textColor = [UIColor whiteColor];
            detailLabel.text = detailText;
            detailLabel.font = [UIFont systemFontOfSize:14.0];
            detailLabel.backgroundColor = [UIColor darkGrayColor];
            [self addSubview:detailLabel];
            [detailLabel release]; 
        }

        [self presentOnTopOfView:parentView centerAtPoint:point];
    }
    return self;    
}

- (void)presentOnTopOfView:(UIView *)parentView centerAtPoint:(CGPoint)point;
{
    self.center = point;
    [self.busyIndicator startAnimating];
    [parentView addSubview:self];
}

- (void)removeFromParentView
{
    [self.busyIndicator stopAnimating];
    [self removeFromSuperview];
}

- (void)dealloc
{
    [busyIndicator release];
    [super dealloc];
}

@end
