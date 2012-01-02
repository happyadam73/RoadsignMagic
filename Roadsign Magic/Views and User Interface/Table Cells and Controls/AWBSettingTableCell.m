//
//  AWBSettingTableCell.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 08/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBSettingTableCell.h"


@implementation UITableViewCell (Settings)

- (void)updateCellWithSetting:(AWBSetting *)aSetting
{
    // do nothing
}

- (UIControl *)cellControl
{
    return nil;
}

- (UITextField *)cellTextField
{
    return nil;
}

@end


@implementation AWBSettingTableCell

- (void)updateCellWithSetting:(AWBSetting *)aSetting
{
    self.textLabel.text = aSetting.text;
}

@end