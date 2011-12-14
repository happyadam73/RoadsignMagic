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
        textView.backgroundColor = [UIColor clearColor];
        textView.text = text;
        UIFont *textFont;
        if (IS_IPAD) {
            textFont = [UIFont systemFontOfSize:20.0];
        } else {
            textFont = [UIFont systemFontOfSize:14.0];
        }
        textView.font = textFont;        
        [[self contentView] addSubview:textView];
        [textView release];
    }
    return self;    
}

- (void)layoutSubviews  
{
    [super layoutSubviews];
    CGFloat marginX = 5.0;
    CGFloat marginY = 5.0;
    CGSize contentViewSize = self.contentView.bounds.size;
    textView.frame = CGRectMake(marginX, marginY, contentViewSize.width - (2.0 * marginX), contentViewSize.height - (2.0 * marginY));
}

@end
