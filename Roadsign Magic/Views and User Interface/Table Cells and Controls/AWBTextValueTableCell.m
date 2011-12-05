//
//  AWBTextValueTableCell.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 19/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBTextValueTableCell.h"

@implementation AWBTextValueTableCell

- (void)initialiseWithText:(NSString *)text value:(NSString *)value
{
    self.textLabel.text = text;
    self.detailTextLabel.text = value;
}

- (id)initWithWithText:(NSString *)text value:(NSString *)value reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initialiseWithText:text value:value];
    }
    return self;
}

- (void)updateCellWithSetting:(AWBSetting *)aSetting
{
    [self initialiseWithText:aSetting.text value:aSetting.settingValue];
}

@end
