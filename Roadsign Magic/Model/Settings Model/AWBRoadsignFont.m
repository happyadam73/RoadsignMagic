//
//  AWBCollageFonts.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignFont.h"
#import "FontManager.h"
#import "FileHelpers.h"

@implementation AWBRoadsignFont

@synthesize fontType;

- (id)initWithFontType:(AWBRoadsignFontType)aFontType
{
    self = [super init];
    if (self) {
        fontType = aFontType;
    }
    return self;
}

- (BOOL)isZFont
{
    switch (fontType) {
        case AWBRoadsignFontTypeArialRoundedMTBold:
            return NO;
        case AWBRoadsignFontTypeHelvetica:
            return NO;
        case AWBRoadsignFontTypeGillSans:
            return NO;            
        case AWBRoadsignFontTypeBritishRoadsign:
            return YES;
        case AWBRoadsignFontTypeUSFreeway:
            return YES;
        case AWBRoadsignFontTypeUSHighwayNarrow:
            return YES;
        case AWBRoadsignFontTypeUSHighwayWide:
            return YES;
        case AWBRoadsignFontTypeGraffiti:
            return YES;    
        default:
            return NO;
    }
}

- (NSString *)fontFamilyName
{
    switch (fontType) {
        case AWBRoadsignFontTypeArialRoundedMTBold:
            return @"ArialRoundedMTBold";
        case AWBRoadsignFontTypeHelvetica:
            return @"Helvetica";
        case AWBRoadsignFontTypeGillSans:
            return @"GillSans";            
        case AWBRoadsignFontTypeBritishRoadsign:
            return @"BritishRoadsign";
        case AWBRoadsignFontTypeUSFreeway:
            return @"Freeway Gothic";
        case AWBRoadsignFontTypeUSHighwayNarrow:
            return @"Highway Gothic Narrow";
        case AWBRoadsignFontTypeUSHighwayWide:
            return @"Highway Gothic Wide";
        case AWBRoadsignFontTypeGraffiti:
            return @"Most Wasted";
        default:
            return @"Helvetica";
    }
}

- (NSString *)fontDescription
{
    switch (fontType) {
        case AWBRoadsignFontTypeArialRoundedMTBold:
            return @"Arial Bold";
        case AWBRoadsignFontTypeHelvetica:
            return @"Helvetica";
        case AWBRoadsignFontTypeGillSans:
            return @"Gill Sans";            
        case AWBRoadsignFontTypeBritishRoadsign:
            return @"British Roadsign";
        case AWBRoadsignFontTypeUSFreeway:
            return @"US Freeway";
        case AWBRoadsignFontTypeUSHighwayNarrow:
            return @"US Highway Narrow";
        case AWBRoadsignFontTypeUSHighwayWide:
            return @"US Highway Wide";
        case AWBRoadsignFontTypeGraffiti:
            return @"Graffiti";
        default:
            return @"Helvetica";
    }
}

- (UIFont *)fontWithSize:(CGFloat)size
{
    if (self.isZFont) {
        return nil;
    }
    return [UIFont fontWithName:[self fontFamilyName] size:size];
}

- (ZFont *)zFontWithSize:(CGFloat)size
{
    if (!self.isZFont) {
        return nil;
    }
    return [[FontManager sharedManager] zFontWithName:[self fontFamilyName] pointSize:size];
}

+ (BOOL)isZFont:(NSString *)fontName
{
    if ([fontName isEqualToString:@"BritishRoadsign"]) {
        return YES;
    } else if ([fontName isEqualToString:@"Freeway Gothic"]) {
        return YES;
    } else if ([fontName isEqualToString:@"Highway Gothic Narrow"]) {
        return YES;
    } else if ([fontName isEqualToString:@"Highway Gothic Wide"]) {
        return YES;
    } else if ([fontName isEqualToString:@"Most Wasted"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isFontNameMyFontURL:(NSString *)fontName
{
    NSURL *fileUrl = [NSURL URLWithString:fontName];
    if (fileUrl) {
        if ([fileUrl isFileURL]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

+ (BOOL)isFontNameMyFontFilename:(NSString *)fontName
{
    if ([fontName hasPrefix:@"mf"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSURL *)myFontUrlFromFontFilename:(NSString *)fontFilename
{
    NSString *filepath = AWBPathInMyFontsDocumentsSubdirectory(fontFilename);
    return [NSURL fileURLWithPath:filepath];
}

+ (BOOL)myFontDoesExistWithFilename:(NSString *)fontFilename
{
    NSString *filepath = AWBPathInMyFontsDocumentsSubdirectory(fontFilename);
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

@end
