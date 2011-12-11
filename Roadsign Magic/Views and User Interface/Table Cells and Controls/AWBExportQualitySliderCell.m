//
//  AWBExportQualitySliderCell.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 11/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBExportQualitySliderCell.h"

@implementation AWBExportQualitySliderCell

@synthesize exportQualityValue, exportQualitySlider;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithExportQualityValue:2.0 reuseIdentifier:reuseIdentifier];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithExportQualityValue:2.0 reuseIdentifier:reuseIdentifier];
}

- (id)initWithExportQualityValue:(CGFloat)value reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        exportQualitySlider = [[UISlider alloc] initWithFrame:CGRectZero];
        [exportQualitySlider setMinimumValue:0.5];
        [exportQualitySlider setMaximumValue:1.0];
        [exportQualitySlider setValue:value];
        [exportQualitySlider setMinimumValueImage:[UIImage imageNamed:@"LoQuality.png"]];
        [exportQualitySlider setMaximumValueImage:[UIImage imageNamed:@"HiQuality.png"]];
        [exportQualitySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [[self contentView] addSubview:exportQualitySlider];
        [exportQualitySlider release];
        [self.textLabel setText:@"Quality"];
        [self.detailTextLabel setText:AWBExportQualityDescriptionFromValue(self.exportQualityValue)];
    }
    return self;    
}

- (CGFloat)exportQualityValue
{
    return (((int)(10.0 * exportQualitySlider.value)) / 10.0);
}

- (void)setExportQualityValue:(CGFloat)value
{
    [exportQualitySlider setValue:value];
}

- (void)layoutSubviews  
{
    [super layoutSubviews];
    exportQualitySlider.frame = CGRectMake(100.0f, 2.0f, [[self contentView] bounds].size.width - 120.0, 40.0f);
}

- (void)sliderValueChanged:(id)sender
{
    [self.detailTextLabel setText:AWBExportQualityDescriptionFromValue(self.exportQualityValue)];
}

@end
