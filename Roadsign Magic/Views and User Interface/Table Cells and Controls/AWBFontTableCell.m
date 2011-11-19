//
//  AWBFontTableCell.m
//  Collage Maker
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBFontTableCell.h"
#import "AWBCollageFont.h"

@implementation AWBFontTableCell

- (void)initialiseWithFontType:(AWBCollageFontType)fontType
{
    AWBCollageFont *font = [[AWBCollageFont alloc] initWithFontType:fontType];
    [[self textLabel] setFont:[font fontWithSize:18.0]];    
    self.textLabel.text = [font fontDescription];
    [font release];
}

- (id)initWithFontType:(AWBCollageFontType)fontType reuseIdentifier:(NSString *)reuseIdentifier
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
    return [self initWithFontType:AWBCollageFontTypeHelvetica reuseIdentifier:reuseIdentifier];
}

- (void)updateCellWithSetting:(AWBSetting *)aSetting
{
    AWBCollageFontType fontType = [aSetting.settingValue integerValue];
    [self initialiseWithFontType:fontType];
}

@end
