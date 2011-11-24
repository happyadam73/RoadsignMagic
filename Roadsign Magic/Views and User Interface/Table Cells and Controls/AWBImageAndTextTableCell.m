//
//  AWBImageAndTextTableCell.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 15/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBImageAndTextTableCell.h"
#import "UIImage+Scale.h"

@implementation AWBImageAndTextTableCell

- (void)initialiseWithText:(NSString *)text image:(UIImage *)image
{
    self.textLabel.text = text;
    self.imageView.image = [image imageBorderedWithColor:[UIColor clearColor] thickness:5.0];
}

- (id)initWithWithText:(NSString *)text image:(UIImage *)image reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initialiseWithText:text image:image];
    }
    return self;
}

- (void)updateCellWithSetting:(AWBSetting *)aSetting
{
    [self initialiseWithText:aSetting.text image:aSetting.settingValue];
}

- (CGFloat)borderThickness
{
    if (DEVICE_IS_IPAD) {
        return 2.0;
    } else {
        return 1.0;    
    }    
}

@end
