//
//  AWBColorPickerTableCell.h
//  Collage Maker
//
//  Created by Adam Buckley on 03/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBColorPickerSegmentedControl.h"
#import "AWBSettingTableCell.h"

@interface AWBColorPickerTableCell : UITableViewCell {
    AWBColorPickerSegmentedControl *picker;
}

@property (nonatomic, readonly) AWBColorPickerSegmentedControl *picker;

- (id)initWithSelectedColor:(UIColor *)selectedColor reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
