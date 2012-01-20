//
//  AWBMyFont.h
//  Roadsign Magic
//
//  Created by Buckley Adam on 02/01/2012.
//  Copyright (c) 2012 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kAWBInfoKeyMyFontFamilyName = @"MyFontFamilyName";
static NSString *const kAWBInfoKeyMyFontFontName = @"MyFontFontName";
static NSString *const kAWBInfoKeyMyFontPostscriptName = @"MyFontPostscriptName";
static NSString *const kAWBInfoKeyMyFontFilename = @"MyFontFilename";
static NSString *const kAWBInfoKeyMyFontFileUrl = @"MyFontFileUrl";
static NSString *const kAWBInfoKeyMyFontCreatedDate = @"MyFontCreatedDate";
static NSString *const kAWBInfoKeyMyFontFileSizeBytes = @"MyFontFileSizeBytes";

@interface AWBMyFont : NSObject {
    NSString *familyName; 
    NSString *fontName;
    NSString *postScriptName;
    NSString *filename;
    NSURL *installUrl;
    NSDate *createdDate;
    NSUInteger fileSizeBytes;
}

@property (nonatomic, retain) NSString *familyName; 
@property (nonatomic, retain) NSString *fontName;
@property (nonatomic, retain) NSString *postScriptName;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSURL *installUrl;
@property (nonatomic, readonly) NSURL *fileUrl;
@property (nonatomic, readonly) NSDate *createdDate;
@property (nonatomic, assign) NSUInteger fileSizeBytes;

- (id)initWithUrl:(NSURL *)url;
- (void)removeFromFileSystem;
- (void)removeFromInbox;

@end
