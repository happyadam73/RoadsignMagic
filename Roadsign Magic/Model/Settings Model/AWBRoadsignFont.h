//
//  AWBCollageFonts.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFont.h"

typedef enum {
    AWBRoadsignFontTypeHelvetica,
    AWBRoadsignFontTypeArialRoundedMTBold,              
    AWBRoadsignFontTypeBritishRoadsign,
    AWBRoadsignFontTypeGillSans
} AWBRoadsignFontType;

@interface AWBRoadsignFont : NSObject {
    AWBRoadsignFontType fontType;
}

@property (nonatomic, assign) AWBRoadsignFontType fontType;
@property (nonatomic, readonly) BOOL isZFont;

- (id)initWithFontType:(AWBRoadsignFontType)aFontType;
- (NSString *)fontFamilyName;
- (NSString *)fontDescription;
- (UIFont *)fontWithSize:(CGFloat)size;
- (ZFont *)zFontWithSize:(CGFloat)size;
+ (BOOL)isZFont:(NSString *)fontName;
+ (BOOL)isFontNameMyFontURL:(NSString *)fontName;
+ (BOOL)isFontNameMyFontFilename:(NSString *)fontName;
+ (NSURL *)myFontUrlFromFontFilename:(NSString *)fontFilename;
+ (BOOL)myFontDoesExistWithFilename:(NSString *)fontFilename;

@end
