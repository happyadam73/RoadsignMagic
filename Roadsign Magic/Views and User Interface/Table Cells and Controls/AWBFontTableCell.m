//
//  AWBFontTableCell.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBFontTableCell.h"
#import "AWBRoadsignFont.h"

@implementation AWBFontTableCell

- (void)initialiseWithFontType:(AWBRoadsignFontType)fontType
{
    AWBRoadsignFont *font = [[AWBRoadsignFont alloc] initWithFontType:fontType];
    [[self textLabel] setFont:[font fontWithSize:18.0]];    
    self.textLabel.text = [font fontDescription];
    [font release];
}

- (id)initWithFontType:(AWBRoadsignFontType)fontType reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initialiseWithFontType:fontType];
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
    [self initialiseWithFontType:fontType];
}

@end
