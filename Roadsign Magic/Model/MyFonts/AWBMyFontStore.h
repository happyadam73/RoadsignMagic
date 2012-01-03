//
//  AWBMyFontStore.h
//  Roadsign Magic
//
//  Created by Buckley Adam on 02/01/2012.
//  Copyright (c) 2012 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kAWBInfoKeyMyFontSequenceNumber = @"MyFontSequenceNumber";
static NSString *const kAWBInfoKeyMyFontStoreMyFontIndex = @"MyFontStoreMyFontIndex";

@class AWBMyFont;

@interface AWBMyFontStore : NSObject {
    NSMutableArray *allMyFonts;
}

+ (AWBMyFontStore *)defaultStore;
- (NSArray *)allMyFonts;
- (BOOL)installMyFont:(AWBMyFont *)myFont;
- (void)removeMyFont:(AWBMyFont *)myFont;
- (void)moveMyFontAtIndex:(int)from toIndex:(int)to;
- (NSString *)myFontsArchivePath;
- (BOOL)saveAllMyFonts;
- (void)fetchAllMyFontsIfNecessary;
- (NSString *)nextDefaultMyFontFilenamePrefix;

@end
