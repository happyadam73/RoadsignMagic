//
//  AWBTextValueTableCell.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 19/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBSettingTableCell.h"

@interface AWBTextValueTableCell : UITableViewCell 

- (void)initialiseWithText:(NSString *)text value:(NSString *)value;
- (id)initWithWithText:(NSString *)text value:(NSString *)value reuseIdentifier:(NSString *)reuseIdentifier;

@end
