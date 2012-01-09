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
        
//        NSLog(@"MyFont: ratio: %f unitsPerEm: %d", myFont.ratio, CGFontGetUnitsPerEm(myFont.cgFont));
//        NSLog(@"ascender: %f", myFont.ascender);
//        NSLog(@"descender: %f", myFont.descender);
//        NSLog(@"leading: %f", myFont.leading);
//        NSLog(@"xHeight: %f", myFont.xHeight);
//        NSLog(@"capHeight: %f", myFont.capHeight);
//        CGRect fontRect = CGFontGetFontBBox(myFont.cgFont);
//        NSLog(@"fontRect: %f %f %f %f", fontRect.origin.x, fontRect.origin.y, fontRect.size.width, fontRect.size.height);
        
        fontLabel = [[FontLabel alloc] initWithFrame:CGRectZero zFont:myFont];
        fontLabel.backgroundColor = [UIColor clearColor];
        fontLabel.textAlignment = UITextAlignmentCenter;
        fontLabel.numberOfLines = 0;
        fontLabel.text = previewText;
        //fontLabel.text = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz 0123456789";
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
