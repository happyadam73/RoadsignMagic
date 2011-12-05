//
//  AWBSwitchCell.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBSwitchCell.h"


@implementation AWBSwitchCell

@synthesize switchValue, cellSwitch;

- (void)initialiseWithText:(NSString *)text detailText:(NSString *)detailText value:(BOOL)value
{
    cellSwitch.on = value;
    [self.textLabel setText:text];
    if (detailText) {
        [self.detailTextLabel setText:detailText];            
    }    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithText:nil detailText:nil value:NO reuseIdentifier:reuseIdentifier];
}

- (id)initWithSwitchValue:(BOOL)value reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithText:nil detailText:nil value:value reuseIdentifier:reuseIdentifier];
}

- (id)initWithText:(NSString *)text value:(BOOL)value reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithText:text detailText:nil value:value reuseIdentifier:reuseIdentifier];
}

- (id)initWithText:(NSString *)text detailText:(NSString *)detailText value:(BOOL)value reuseIdentifier:(NSString *)reuseIdentifier
{
    UITableViewCellStyle style = UITableViewCellStyleDefault;
    if (detailText) {
        style = UITableViewCellStyleSubtitle;
    }
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        cellSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        self.accessoryView = cellSwitch;
        [cellSwitch release];
        [self initialiseWithText:text detailText:detailText value:value];
    }
    return self;    
}

- (BOOL)switchValue
{
    return cellSwitch.on;
}

- (void)setSwitchValue:(BOOL)value    
{
    cellSwitch.on = value;
}

- (void)updateCellWithSetting:(AWBSetting *)aSetting
{
    [cellSwitch removeTarget:nil action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [cellSwitch addTarget:aSetting action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self initialiseWithText:aSetting.text detailText:aSetting.detailText value:[aSetting.settingValue boolValue]];
}

@end
