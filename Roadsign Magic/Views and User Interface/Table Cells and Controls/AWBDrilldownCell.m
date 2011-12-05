//
//  AWBDrilldownCell.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 07/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBDrilldownCell.h"
#import "AWBSetting.h"

@implementation AWBDrilldownCell

- (id)initWithText:(NSString *)text textValue:(NSString *)value reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.textLabel setText:text];
        [self.detailTextLabel setText:value];
    }
    return self;    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithText:nil textValue:nil reuseIdentifier:reuseIdentifier];
}

- (void)updateCellWithSetting:(AWBSetting *)aSetting
{
    [self.detailTextLabel setText:[aSetting settingValueDescription]];
}

@end

