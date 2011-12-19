//
//  AWBFontTableCell.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBRoadsignFont.h"
#import "AWBSettingTableCell.h"

@interface AWBFontTableCell : UITableViewCell 

- (void)initialiseWithFontType:(AWBRoadsignFontType)fontType;
- (id)initWithFontType:(AWBRoadsignFontType)fontType reuseIdentifier:(NSString *)reuseIdentifier;

@end
