//
//  AWBSizeableImageTableCell2.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 31/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBSizeableImageTableCell2.h"

@implementation AWBSizeableImageTableCell2

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat contentViewWidth = self.contentView.frame.size.width;
    CGFloat contentViewHeight = self.contentView.frame.size.height;
    CGFloat marginWidth = floorf(0.03 * contentViewWidth);
    CGFloat imageViewWidth = floorf(0.3 * contentViewWidth);
    CGFloat labelViewWidth = floorf(0.64 * contentViewWidth);
    
    self.imageView.frame = CGRectMake(marginWidth, marginWidth, imageViewWidth, contentViewHeight - (2.0 * marginWidth));
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = (2.0 * marginWidth) + imageViewWidth;
    textLabelFrame.origin.y = (contentViewHeight / 2.0) - (textLabelFrame.size.height / 2.0);    
    textLabelFrame.size.width = labelViewWidth;
    self.textLabel.frame = textLabelFrame;
}

@end
