//
//  AWBCollageFonts.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBCollageFont.h"

@implementation AWBCollageFont

@synthesize fontType;

- (id)initWithFontType:(AWBCollageFontType)aFontType
{
    self = [super init];
    if (self) {
        fontType = aFontType;
    }
    return self;
}

- (NSString *)fontFamilyName
{
    switch (fontType) {
        case AWBCollageFontTypeAmericanTypewriter:
            return @"AmericanTypewriter";
        case AWBCollageFontTypeAppleGothic:
            return @"AppleGothic";
        case AWBCollageFontTypeArialRoundedMTBold:
            return @"ArialRoundedMTBold";
        case AWBCollageFontTypeHelvetica:
            return @"Helvetica";
        case AWBCollageFontTypeMarkerFeltThin:
            return @"MarkerFelt-Thin";
        case AWBCollageFontTypeSnellRoundhand:
            return @"SnellRoundhand";
        case AWBCollageFontTypeTrebuchetMSItalic:
            return @"TrebuchetMS-Italic";
        case AWBCollageFontTypeZapfino:
            return @"Zapfino";
        case AWBCollageFontTypeChalkduster:
            return @"Chalkduster";
        case AWBCollageFontTypeAcademyEngravedLetPlain:
            return @"AcademyEngravedLetPlain";
        case AWBCollageFontTypeBradleyHandITCTTBold:
            return @"BradleyHandITCTT-Bold";
        case AWBCollageFontTypePapyrus:
            return @"Papyrus";
        case AWBCollageFontTypePartyLetPlain:
            return @"PartyLetPlain";
        default:
            return @"Helvetica";
    }
}

- (NSString *)fontDescription
{
    switch (fontType) {
        case AWBCollageFontTypeAmericanTypewriter:
            return @"Typewriter";
        case AWBCollageFontTypeAppleGothic:
            return @"Gothic";
        case AWBCollageFontTypeArialRoundedMTBold:
            return @"Arial Bold";
        case AWBCollageFontTypeHelvetica:
            return @"Helvetica";
        case AWBCollageFontTypeMarkerFeltThin:
            return @"Marker Pen";
        case AWBCollageFontTypeSnellRoundhand:
            return @"Roundhand";
        case AWBCollageFontTypeTrebuchetMSItalic:
            return @"Trebuchet Italic";
        case AWBCollageFontTypeZapfino:
            return @"Zapfino";
        case AWBCollageFontTypeChalkduster:
            return @"Chalkduster";
        case AWBCollageFontTypeAcademyEngravedLetPlain:
            return @"Engraved";
        case AWBCollageFontTypeBradleyHandITCTTBold:
            return @"Handwriting";
        case AWBCollageFontTypePapyrus:
            return @"Papyrus";
        case AWBCollageFontTypePartyLetPlain:
            return @"Party";
        default:
            return @"Helvetica";
    }
}

- (UIFont *)fontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:[self fontFamilyName] size:size];
}

@end
