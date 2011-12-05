//
//  AWBSubtitleTableCell.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBSubtitleTableCell.h"
#import "UIImage+Scale.h"

@implementation AWBSubtitleTableCell

- (void)initialiseWithText:(NSString *)text detailText:(NSString *)detailText image:(UIImage *)image
{
    self.textLabel.text = text;
    self.detailTextLabel.text = detailText;
    self.imageView.image = [image imageBorderedWithColor:[UIColor clearColor] thickness:5.0];
}

- (id)initWithWithText:(NSString *)text detailText:(NSString *)detailText image:(UIImage *)image reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initialiseWithText:text detailText:detailText image:image];
    }
    return self;
}

- (void)updateCellWithSetting:(AWBSetting *)aSetting
{
    [self initialiseWithText:aSetting.text detailText:aSetting.detailText image:aSetting.settingValue];
}

@end
