//
//  AWBColorPickerSegmentedControl.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 03/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
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
