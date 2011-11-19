//
//  AWBColorPickerSegmentedControl.h
//  Collage Maker
//
//  Created by Adam Buckley on 03/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AWBColorPickerSegmentedControl : UISegmentedControl
{
    NSArray *pickerColors;
}

@property (nonatomic, retain) UIColor *selectedColor;

- (void)initialiseSegments;
- (NSArray *)pickerSegmentImages;

@end
