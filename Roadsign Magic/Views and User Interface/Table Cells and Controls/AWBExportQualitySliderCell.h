//
//  AWBExportQualitySliderCell.h
//  Roadsign Magic
//
//  Created by Buckley Adam on 11/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWBExportQualitySliderCell : UITableViewCell {
    UISlider *exportQualitySlider;
}

@property (nonatomic, assign) CGFloat exportQualityValue;
@property (nonatomic, readonly) UISlider *exportQualitySlider;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithExportQualityValue:(CGFloat)value reuseIdentifier:(NSString *)reuseIdentifier;
- (void)sliderValueChanged:(id)sender;

@end
