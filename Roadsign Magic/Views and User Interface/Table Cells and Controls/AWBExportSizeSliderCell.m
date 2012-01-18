//
//  AWBQualitySliderCell.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBExportSizeSliderCell.h"
#import "AWBTransforms.h"

@implementation AWBExportSizeSliderCell

@synthesize exportSizeValue, exportSizeSlider;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithExportSizeValue:2.0 reuseIdentifier:reuseIdentifier];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithExportSizeValue:2.0 reuseIdentifier:reuseIdentifier];
}

- (id)initWithExportSizeValue:(CGFloat)value reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        exportSizeSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        [exportSizeSlider setMinimumValue:0.1];
        [exportSizeSlider setMaximumValue:2.0];
        
        if (!IS_GOPRO_PURCHASED) {
            value = 0.5;
            exportSizeSlider.enabled = NO;
        }
        
        [exportSizeSlider setValue:value];
        [exportSizeSlider setMinimumValueImage:[UIImage imageNamed:@"0.1x.png"]];
        [exportSizeSlider setMaximumValueImage:[UIImage imageNamed:@"2x.png"]];
        [exportSizeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [[self contentView] addSubview:exportSizeSlider];
        [exportSizeSlider release];
        [self.textLabel setText:@"Size"];
        [self.detailTextLabel setText:AWBImageSizeFromExportSizeValue(self.exportSizeValue)];
    }
    return self;    
}

- (CGFloat)exportSizeValue
{
    return (((int)(10.0 * exportSizeSlider.value)) / 10.0);
}

- (void)setExportSizeValue:(CGFloat)value
{
    [exportSizeSlider setValue:value];
}

- (void)layoutSubviews  
{
    [super layoutSubviews];
    exportSizeSlider.frame = CGRectMake(100.0f, 2.0f, [[self contentView] bounds].size.width - 120.0, 40.0f);
}

- (void)sliderValueChanged:(id)sender
{
    [self.detailTextLabel setText:AWBImageSizeFromExportSizeValue(self.exportSizeValue)];
}

@end
