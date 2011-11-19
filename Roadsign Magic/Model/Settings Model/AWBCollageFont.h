//
//  AWBCollageFonts.h
//  Collage Maker
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AWBCollageFontTypeHelvetica,
    AWBCollageFontTypeArialRoundedMTBold,              
    AWBCollageFontTypeMarkerFeltThin,
    AWBCollageFontTypeAmericanTypewriter,
    AWBCollageFontTypeSnellRoundhand,
    AWBCollageFontTypeZapfino,
    AWBCollageFontTypeAppleGothic,
    AWBCollageFontTypeTrebuchetMSItalic,
    AWBCollageFontTypeChalkduster,
    AWBCollageFontTypeAcademyEngravedLetPlain,
    AWBCollageFontTypeBradleyHandITCTTBold,
    AWBCollageFontTypePapyrus,
    AWBCollageFontTypePartyLetPlain
} AWBCollageFontType;

@interface AWBCollageFont : NSObject {
    AWBCollageFontType fontType;
}

@property (nonatomic, assign) AWBCollageFontType fontType;

- (id)initWithFontType:(AWBCollageFontType)aFontType;
- (NSString *)fontFamilyName;
- (NSString *)fontDescription;
- (UIFont *)fontWithSize:(CGFloat)size;

@end
