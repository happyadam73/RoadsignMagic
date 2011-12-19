//
//  AWBZFontTableCell.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 19/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBZFontTableCell.h"

@implementation AWBZFontTableCell

- (id)initWithFontType:(AWBRoadsignFontType)fontType reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        AWBRoadsignFont *font = [[AWBRoadsignFont alloc] initWithFontType:fontType];
        fontLabel = [[FontLabel alloc] initWithFrame:CGRectZero zFont:[font zFontWithSize:18.0]];
        fontLabel.backgroundColor = [UIColor clearColor];
        fontLabel.text = [font fontDescription];
        [[self contentView] addSubview:fontLabel];
        [font release];
        [fontLabel release];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithFontType:AWBRoadsignFontTypeHelvetica reuseIdentifier:reuseIdentifier];
}

- (void)updateCellWithSetting:(AWBSetting *)aSetting
{
    AWBRoadsignFontType fontType = [aSetting.settingValue integerValue];
    AWBRoadsignFont *font = [[AWBRoadsignFont alloc] initWithFontType:fontType];
    fontLabel.zFont = [font zFontWithSize:18.0];
    fontLabel.text = [font fontDescription];
    [font release];    
}

- (void)layoutSubviews  
{
    [super layoutSubviews];
    fontLabel.frame = CGRectMake(10.0, 0.0, (self.contentView.bounds.size.width - 20.0), self.contentView.bounds.size.height);
}

@end
