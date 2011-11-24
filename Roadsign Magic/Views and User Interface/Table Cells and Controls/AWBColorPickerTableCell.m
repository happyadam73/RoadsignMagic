//
//  AWBColorPickerTableCell.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 03/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBColorPickerTableCell.h"

@implementation AWBColorPickerTableCell

@synthesize picker;

- (id)initWithSelectedColor:(UIColor *)selectedColor reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        picker = [[AWBColorPickerSegmentedControl alloc] initWithFrame:CGRectZero];
        [picker setSelectedColor:selectedColor];
        [[self contentView] addSubview:picker];
        [picker release];
    }
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithSelectedColor:[UIColor blackColor] reuseIdentifier:reuseIdentifier];
}

- (void)layoutSubviews  
{
    [super layoutSubviews];
    picker.frame = CGRectMake(0.0f, 0.0f, [[self contentView] bounds].size.width, 45.0f);
}

- (UIControl *)cellControl
{
    return picker;
}

- (void)updateCellWithSetting:(AWBSetting *)aSetting
{
    [picker removeTarget:nil action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [picker addTarget:aSetting action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [picker setSelectedColor:(UIColor *)aSetting.settingValue];

}

@end
