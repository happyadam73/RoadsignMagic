//
//  AWBQualitySliderCell.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBQualitySliderCell.h"
#import "AWBTransforms.h"

@implementation AWBQualitySliderCell

@synthesize qualityValue, qualitySlider;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithQualityValue:2.0 reuseIdentifier:reuseIdentifier];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithQualityValue:2.0 reuseIdentifier:reuseIdentifier];
}

- (id)initWithQualityValue:(CGFloat)value reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        qualitySlider = [[UISlider alloc] initWithFrame:CGRectZero];
        [qualitySlider setMinimumValue:0.1];
        [qualitySlider setMaximumValue:2.0];
        [qualitySlider setValue:value];
        [qualitySlider setMinimumValueImage:[UIImage imageNamed:@"0.1x.png"]];
        [qualitySlider setMaximumValueImage:[UIImage imageNamed:@"2x.png"]];
        [qualitySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [[self contentView] addSubview:qualitySlider];
        [qualitySlider release];
        [self.textLabel setText:@"Size"];
        [self.detailTextLabel setText:AWBImageSizeFromQualityValue(self.qualityValue)];
    }
    return self;    
}

- (CGFloat)qualityValue
{
    return (((int)(10.0 * qualitySlider.value)) / 10.0);
}

- (void)setQualityValue:(CGFloat)value
{
    [qualitySlider setValue:value];
}

- (void)layoutSubviews  
{
    [super layoutSubviews];
    qualitySlider.frame = CGRectMake(100.0f, 2.0f, [[self contentView] bounds].size.width - 120.0, 40.0f);
}

- (void)sliderValueChanged:(id)sender
{
    [self.detailTextLabel setText:AWBImageSizeFromQualityValue(self.qualityValue)];
}

@end
