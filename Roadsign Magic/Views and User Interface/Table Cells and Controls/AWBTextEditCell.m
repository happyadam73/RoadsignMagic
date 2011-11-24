//
//  AWBTextEditCell.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 08/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBTextEditCell.h"


@implementation AWBTextEditCell

@synthesize textField;

- (void)initialiseWithWithLabel:(NSString *)label textValue:(NSString *)value
{
    self.textLabel.text = label;
    textField.placeholder = [NSString stringWithFormat:@"<Enter %@ Text>", self.textLabel.text];
    textField.text = value;    
}

- (id)initWithLabel:(NSString *)label textValue:(NSString *)value reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.clearsOnBeginEditing = NO;
        textField.textAlignment = UITextAlignmentLeft;
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self initialiseWithWithLabel:label textValue:value];
        [self.contentView addSubview:textField];
        [textField release];
    }
    return self;    
}

- (void)updateCellWithSetting:(AWBSetting *)aSetting
{
    [textField removeTarget:nil action:@selector(controlValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [textField addTarget:aSetting action:@selector(controlValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self initialiseWithWithLabel:aSetting.text textValue:aSetting.settingValue];
}

- (UITextField *)cellTextField
{
    return textField;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UILabel *cellLabel = (UILabel *)[self textLabel];
    CGSize labelSize = [[cellLabel text] sizeWithFont:[cellLabel font]];
    CGRect labelRect = CGRectMake(LeftRightMargin, 12.0, labelSize.width, 25.0);
    CGRect textEditRect = CGRectMake(self.contentView.bounds.size.width - LeftRightMargin, 12.0, -(self.contentView.bounds.size.width - (2*LeftRightMargin) - MarginBetweenControls - labelSize.width), 25.0);
    [textField setFrame:textEditRect];
    [cellLabel setFrame:labelRect];
}

@end
