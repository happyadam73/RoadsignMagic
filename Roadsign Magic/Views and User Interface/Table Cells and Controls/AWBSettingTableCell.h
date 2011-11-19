//
//  AWBSettingTableCell.h
//  Collage Maker
//
//  Created by Adam Buckley on 08/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBSetting.h"

@interface UITableViewCell (Settings)

- (void)updateCellWithSetting:(AWBSetting *)aSetting;
- (UIControl *)cellControl;
- (UITextField *)cellTextField;

@end
