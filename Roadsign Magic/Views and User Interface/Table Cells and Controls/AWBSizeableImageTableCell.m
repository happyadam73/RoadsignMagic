//
//  AWBSizeableImageTableCell.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBSizeableImageTableCell.h"

@implementation AWBSizeableImageTableCell

- (void)layoutSubviews {
    
    [super layoutSubviews];

    CGFloat contentViewWidth = self.contentView.frame.size.width;
    CGFloat contentViewHeight = self.contentView.frame.size.height;
    CGFloat marginWidth = floorf(0.03 * contentViewWidth);
    CGFloat marginHeight = floorf(0.08 * contentViewHeight);
    CGFloat imageViewWidth = floorf(0.3 * contentViewWidth);
    CGFloat labelViewWidth = floorf(0.64 * contentViewWidth);

    self.imageView.frame = CGRectMake(marginWidth, marginWidth, imageViewWidth, contentViewHeight - (2.0 * marginWidth));
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = (2.0 * marginWidth) + imageViewWidth;
    textLabelFrame.origin.y = (2.0 * marginHeight);    
    textLabelFrame.size.width = labelViewWidth;
    self.textLabel.frame = textLabelFrame;
    
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    detailTextLabelFrame.origin.x = (2.0 * marginWidth) + imageViewWidth;
    detailTextLabelFrame.origin.y = (3.0 * marginHeight) + self.textLabel.frame.size.height;
    detailTextLabelFrame.size.width = labelViewWidth;
    self.detailTextLabel.frame = detailTextLabelFrame;

}

@end
