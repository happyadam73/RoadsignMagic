//
//  AWBMyFontPreviewTableCell.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 03/01/2012.
//  Copyright (c) 2012 Callcredit. All rights reserved.
//

#import "AWBMyFontPreviewTableCell.h"
#import "FontManager.h"
#import "ZFont.h"

@implementation AWBMyFontPreviewTableCell

- (id)initWithFontFileUrl:(NSURL *)fontFileUrl previewText:(NSString *)previewText reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        ZFont *myFont = [[FontManager sharedManager] zFontWithURL:fontFileUrl pointSize:(DEVICE_IS_IPAD? 44.0 : 28.0)];
        fontLabel = [[FontLabel alloc] initWithFrame:CGRectZero zFont:myFont];
        fontLabel.backgroundColor = [UIColor clearColor];
        fontLabel.textAlignment = UITextAlignmentCenter;
        fontLabel.numberOfLines = 0;
        fontLabel.text = previewText;
        [[self contentView] addSubview:fontLabel];
        [fontLabel release];
    }
    return self;
}

- (void)layoutSubviews  
{
    [super layoutSubviews];
    fontLabel.frame = CGRectMake(10.0, 0.0, (self.contentView.bounds.size.width - 20.0), self.contentView.bounds.size.height);
}

@end
