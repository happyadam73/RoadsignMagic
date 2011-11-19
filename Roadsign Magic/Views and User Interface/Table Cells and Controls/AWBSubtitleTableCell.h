//
//  AWBSubtitleTableCell.h
//  Collage Maker
//
//  Created by Adam Buckley on 24/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBSettingTableCell.h"

@interface AWBSubtitleTableCell : UITableViewCell

- (void)initialiseWithText:(NSString *)text detailText:(NSString *)detailText image:(UIImage *)image;
- (id)initWithWithText:(NSString *)text detailText:(NSString *)detailText image:(UIImage *)image reuseIdentifier:(NSString *)reuseIdentifier;

@end
