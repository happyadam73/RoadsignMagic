//
//  AWBTextViewCell.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 11/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBTextViewCell.h"

@implementation AWBTextViewCell

@synthesize textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithText:nil reuseIdentifier:reuseIdentifier];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithText:nil reuseIdentifier:reuseIdentifier];
}

- (id)initWithText:(NSString *)text reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        textView = [[UITextView alloc] initWithFrame:CGRectZero];
        textView.editable = NO;
        textView.text = text;
        [[self contentView] addSubview:textView];
        [textView release];
    }
    return self;    
}

- (void)layoutSubviews  
{
    [super layoutSubviews];
    textView.frame = self.contentView.bounds;
}

@end
