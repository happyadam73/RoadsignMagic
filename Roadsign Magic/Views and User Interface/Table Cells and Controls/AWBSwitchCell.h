//
//  AWBSwitchCell.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBSettingTableCell.h"

@interface AWBSwitchCell : UITableViewCell {
    UISwitch *cellSwitch;
}

@property (nonatomic, assign) BOOL switchValue;
@property (nonatomic, readonly) UISwitch *cellSwitch;

- (void)initialiseWithText:(NSString *)text detailText:(NSString *)detailText value:(BOOL)value;
- (id)initWithSwitchValue:(BOOL)value reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithText:(NSString *)text value:(BOOL)value reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithText:(NSString *)text detailText:(NSString *)detailText value:(BOOL)value reuseIdentifier:(NSString *)reuseIdentifier;

@end
