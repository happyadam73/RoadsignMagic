//
//  AWBMyFontStore.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 02/01/2012.
//  Copyright (c) 2012 Callcredit. All rights reserved.
//

#import "AWBMyFontStore.h"
#import "AWBMyFont.h"
#import "FileHelpers.h"

static AWBMyFontStore *defaultStore = nil;

@implementation AWBMyFontStore

+ (AWBMyFontStore *)defaultStore
{
    if (!defaultStore) {
        // Create the singleton
        defaultStore = [[super allocWithZone:NULL] init];
    }
    return defaultStore;
}

// Prevent creation of additional instances
+ (id)allocWithZone:(NSZone *)zone
{
    return [[self defaultStore] retain];
}

- (id)init
{
    // If we already have an instance of CollageStoreStore...
    if (defaultStore) {
        
        // Return the old one
        return defaultStore;
    }
    
    self = [super init];
    return self;
}

- (id)retain
{
    // Do nothing
    return self;
}

- (oneway void)release
{
    // Do nothing
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (NSArray *)allMyFonts
{
    // This ensures allMyFonts is created
    [self fetchAllMyFontsIfNecessary];
    
    return allMyFonts;
}

- (BOOL)installMyFont:(AWBMyFont *)myFont
{
    //first create new font url
    NSString *filename = [NSString stringWithFormat:@"%@%@", [self nextDefaultMyFontFilenamePrefix], myFont.filename];
    NSString *newFilePath = AWBPathInDocumentSubdirectory(@"My Fonts", filename);
    NSURL *newFileUrl = [NSURL fileURLWithPath:newFilePath];
    BOOL success = [[NSFileManager defaultManager] moveItemAtURL:myFont.fileUrl toURL:newFileUrl error:nil];
    if (success) {
        myFont.filename = filename;
        myFont.fileUrl = newFileUrl;
        NSInteger sequenceId = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyMyFontSequenceNumber];
        sequenceId += 1;
        [[NSUserDefaults standardUserDefaults] setInteger:sequenceId forKey:kAWBInfoKeyMyFontSequenceNumber];
        [self fetchAllMyFontsIfNecessary];
        [allMyFonts addObject:myFont];
        [self saveAllMyFonts];
    }
    
    return success;
}

- (NSString *)nextDefaultMyFontFilenamePrefix
{
    NSInteger sequenceId = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyMyFontSequenceNumber];
    sequenceId += 1;
    return [NSString stringWithFormat:@"mf%d", sequenceId];
}

- (void)removeMyFont:(AWBMyFont *)myFont
{
    NSError *error;
    NSString *path = [myFont.fileUrl path];
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    [allMyFonts removeObjectIdenticalTo:myFont];
}

- (void)moveMyFontAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    // Get pointer to object being moved
    AWBMyFont *myFont = [allMyFonts objectAtIndex:from];
    
    // Retain it... (retain count of p = 2)
    [myFont retain];
    
    // Remove p from array, it is automatically sent release (retain count of p = 1)
    [allMyFonts removeObjectAtIndex:from];
    
    // Insert p in array at new location, retained by array (retain count of p = 2)
    [allMyFonts insertObject:myFont atIndex:to];
    
    // Release p (retain count = 1, only owner is now array)
    [myFont release];
}

- (NSString *)myFontsArchivePath
{
    return AWBPathInDocumentSubdirectory(@"My Fonts", @"myFonts.data");
}

- (BOOL)saveAllMyFonts
{
    // returns success or failure
    return [NSKeyedArchiver archiveRootObject:allMyFonts 
                                       toFile:[self myFontsArchivePath]];
}

- (void)fetchAllMyFontsIfNecessary
{
    if (!allMyFonts) {
        NSString *path = [self myFontsArchivePath];
        allMyFonts = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] retain];
    }
    
    if (!allMyFonts) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kAWBInfoKeyMyFontSequenceNumber];
        allMyFonts = [[NSMutableArray alloc] init];
    }
}

@end
