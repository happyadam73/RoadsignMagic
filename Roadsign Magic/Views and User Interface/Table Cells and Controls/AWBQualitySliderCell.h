//
//  AWBQualitySliderCell.h
//  Collage Maker
//
//  Created by Adam Buckley on 05/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AWBQualitySliderCell : UITableViewCell {
    UISlider *qualitySlider;
}

@property (nonatomic, assign) CGFloat qualityValue;
@property (nonatomic, readonly) UISlider *qualitySlider;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithQualityValue:(CGFloat)value reuseIdentifier:(NSString *)reuseIdentifier;
- (void)sliderValueChanged:(id)sender;

@end
