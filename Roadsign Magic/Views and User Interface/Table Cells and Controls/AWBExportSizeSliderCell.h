//
//  AWBQualitySliderCell.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AWBExportSizeSliderCell : UITableViewCell {
    UISlider *exportSizeSlider;
}

@property (nonatomic, assign) CGFloat exportSizeValue;
@property (nonatomic, readonly) UISlider *exportSizeSlider;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithExportSizeValue:(CGFloat)value reuseIdentifier:(NSString *)reuseIdentifier;
- (void)sliderValueChanged:(id)sender;

@end
