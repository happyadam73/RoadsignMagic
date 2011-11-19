//
//  AWBImageAndTextTableCell.h
//  Collage Maker
//
//  Created by Adam Buckley on 15/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBSettingTableCell.h"

@interface AWBImageAndTextTableCell : UITableViewCell 

- (void)initialiseWithText:(NSString *)text image:(UIImage *)image;
- (id)initWithWithText:(NSString *)text image:(UIImage *)image reuseIdentifier:(NSString *)reuseIdentifier;
- (CGFloat)borderThickness;

@end
