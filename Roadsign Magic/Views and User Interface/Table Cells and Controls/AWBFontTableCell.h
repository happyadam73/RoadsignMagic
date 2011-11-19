//
//  AWBFontTableCell.h
//  Collage Maker
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBCollageFont.h"
#import "AWBSettingTableCell.h"

@interface AWBFontTableCell : UITableViewCell 

- (void)initialiseWithFontType:(AWBCollageFontType)fontType;
- (id)initWithFontType:(AWBCollageFontType)fontType reuseIdentifier:(NSString *)reuseIdentifier;

@end
