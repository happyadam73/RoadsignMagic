//
//  AWBMyFont.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 02/01/2012.
//  Copyright (c) 2012 Callcredit. All rights reserved.
//

#import "AWBMyFont.h"
#import "FontManager.h"
#import "ZFont.h"
#import "FileHelpers.h"

#define DEFAULT_FONT_POINT_SIZE 160.0

@implementation AWBMyFont

@synthesize familyName, fontName, postScriptName, filename, fileUrl, createdDate, fileSizeBytes, installUrl;

- (id)initWithUrl:(NSURL *)url
{
    self = [super init];
    if (self) {
        ZFont *font = [[FontManager sharedManager] zFontWithURL:url pointSize:DEFAULT_FONT_POINT_SIZE];
        if (font == nil) {
            [self release];
            return nil;
        }
        createdDate = [[NSDate alloc] init];
        self.familyName = font.familyName;
        self.postScriptName = font.postScriptName;
        self.filename = [url lastPathComponent];
        self.installUrl = url;
        if (font.fontName) {
            self.fontName = font.fontName;            
        } else {
            self.fontName = [url lastPathComponent];
        }
        NSDictionary *info = [[NSFileManager defaultManager] attributesOfItemAtPath:[url path] error:NULL];
        self.fileSizeBytes = [info fileSize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.familyName = [decoder decodeObjectForKey:kAWBInfoKeyMyFontFamilyName];
        self.fontName = [decoder decodeObjectForKey:kAWBInfoKeyMyFontFontName];
        self.postScriptName = [decoder decodeObjectForKey:kAWBInfoKeyMyFontPostscriptName];
        self.filename = [decoder decodeObjectForKey:kAWBInfoKeyMyFontFilename];
        self.fileSizeBytes = [decoder decodeIntegerForKey:kAWBInfoKeyMyFontFileSizeBytes];
        createdDate = [[decoder decodeObjectForKey:kAWBInfoKeyMyFontCreatedDate] retain];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.familyName forKey:kAWBInfoKeyMyFontFamilyName];
    [encoder encodeObject:self.fontName forKey:kAWBInfoKeyMyFontFontName];
    [encoder encodeObject:self.postScriptName forKey:kAWBInfoKeyMyFontPostscriptName];
    [encoder encodeObject:self.filename forKey:kAWBInfoKeyMyFontFilename];
    [encoder encodeObject:self.createdDate forKey:kAWBInfoKeyMyFontCreatedDate];
    [encoder encodeInteger:self.fileSizeBytes forKey:kAWBInfoKeyMyFontFileSizeBytes];
}

- (void)removeFromFileSystem
{
    NSString *path = [self.fileUrl path];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (void)removeFromInbox
{
    NSString *path = [self.installUrl path];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (NSURL *)fileUrl
{   
    NSString *filePath = AWBPathInMyFontsDocumentsSubdirectory(self.filename);
    return [NSURL fileURLWithPath:filePath];
}

- (void)dealloc
{
    [familyName release];
    [fontName release];
    [postScriptName release];
    [filename release];
    [installUrl release];
    [createdDate release];
    [super dealloc];
}

@end
