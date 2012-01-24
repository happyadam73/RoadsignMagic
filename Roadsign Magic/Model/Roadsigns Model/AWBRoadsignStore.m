//
//  AWBRoadsignStore.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/12/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignStore.h"
#import "AWBRoadsignDescriptor.h"
#import "FileHelpers.h"

static AWBRoadsignStore *defaultStore = nil;

@implementation AWBRoadsignStore

+ (AWBRoadsignStore *)defaultStore
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

- (NSArray *)myRoadsigns
{
    // This ensures allRoadsigns is created
    [self fetchMyRoadsignsIfNecessary];
    
    return myRoadsigns;
}

- (NSArray *)templateRoadsigns
{
    // This ensures sample roadsigns are created
    [self fetchTemplateRoadsignsIfNecessary];
    
    return templateRoadsigns;
}

- (AWBRoadsignDescriptor *)createMyRoadsign
{
    [self fetchMyRoadsignsIfNecessary];
    
    NSInteger sequenceId = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyMyRoadsignSequenceNumber];
    sequenceId += 1;
    //for some reason - this can still end of 1 (and overwrite the help sign) so guard against this
    if (sequenceId < 3) {
        sequenceId = 3;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:sequenceId forKey:kAWBInfoKeyMyRoadsignSequenceNumber];
    AWBRoadsignDescriptor *roadsign = [[[AWBRoadsignDescriptor alloc] initWithRoadsignDocumentsSubdirectory:[NSString stringWithFormat:@"Roadsign %d", sequenceId]] autorelease];
    if (roadsign) {
        [myRoadsigns addObject:roadsign];
    }
    
    return roadsign;
}

- (AWBRoadsignDescriptor *)createMyRoadsignFromTemplateRoadsign:(AWBRoadsignDescriptor *)templateRoadsign
{
    
    [self fetchMyRoadsignsIfNecessary];
    [self fetchTemplateRoadsignsIfNecessary];
    
    NSInteger sequenceId = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyMyRoadsignSequenceNumber];
    sequenceId += 1;
    //for some reason - this can still end of 1 (and overwrite the help sign) so guard against this
    if (sequenceId < 3) {
        sequenceId = 3;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:sequenceId forKey:kAWBInfoKeyMyRoadsignSequenceNumber];

    NSString *bundleSubPath = @"Template Roadsigns";
    NSString *templateRoadsignPath = [bundleSubPath stringByAppendingPathComponent:templateRoadsign.roadsignSaveDocumentsSubdirectory];
    NSString *docSubPath = [NSString stringWithFormat:@"Roadsign %d", sequenceId];
    
    BOOL success = AWBCopyBundleFolderToDocumentsFolder(templateRoadsignPath, docSubPath);
    if (success) {
        AWBRoadsignDescriptor *roadsign = [[[AWBRoadsignDescriptor alloc] initWithRoadsignDocumentsSubdirectory:docSubPath] autorelease];
        if (roadsign) {
            roadsign.roadsignName = templateRoadsign.roadsignName;
            roadsign.totalImageMemoryBytes = templateRoadsign.totalImageMemoryBytes;
            roadsign.totalLabelObjects = templateRoadsign.totalLabelObjects;
            roadsign.totalSymbolObjects = templateRoadsign.totalSymbolObjects;
            [myRoadsigns addObject:roadsign];
        }
        return roadsign;           
    } else {
        return nil;
    }
}

- (NSString *)nextDefaultRoadsignName
{
    NSInteger sequenceId = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyMyRoadsignSequenceNumber];
    sequenceId += 1;
    //for some reason - this can still end of 1 (and overwrite the help sign) so guard against this
    if (sequenceId < 3) {
        sequenceId = 3;
    }
    return [NSString stringWithFormat:@"Roadsign %d", sequenceId];
}

- (void)removeMyRoadsign:(AWBRoadsignDescriptor *)roadsign
{
    NSError *error;
    NSString *path = AWBDocumentSubdirectory([roadsign roadsignSaveDocumentsSubdirectory]);
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    [myRoadsigns removeObjectIdenticalTo:roadsign];
}

- (void)moveMyRoadsignAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    // Get pointer to object being moved
    AWBRoadsignDescriptor *roadsign = [myRoadsigns objectAtIndex:from];
    
    // Retain it... (retain count of p = 2)
    [roadsign retain];
    
    // Remove p from array, it is automatically sent release (retain count of p = 1)
    [myRoadsigns removeObjectAtIndex:from];
    
    // Insert p in array at new location, retained by array (retain count of p = 2)
    [myRoadsigns insertObject:roadsign atIndex:to];
    
    // Release p (retain count = 1, only owner is now array)
    [roadsign release];
}

- (NSString *)myRoadsignDescriptorArchivePath
{
    return AWBPathInDocumentDirectory(@"roadsignDescriptors.data");
}

- (NSString *)templateRoadsignDescriptorArchivePath
{
    return AWBPathInMainBundleSubdirectory(@"Template Roadsigns", @"roadsignDescriptors.data");
}

- (BOOL)saveMyRoadsigns
{
    // returns success or failure
    return [NSKeyedArchiver archiveRootObject:myRoadsigns 
                                       toFile:[self myRoadsignDescriptorArchivePath]];
}

- (void)fetchMyRoadsignsIfNecessary
{
    if (!myRoadsigns) {
        NSString *path = [self myRoadsignDescriptorArchivePath];
        myRoadsigns = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] retain];
    }
    
    // If we tried to read one from disk but does not exist, then first try and copy the help collages from the bundle 
    if (!myRoadsigns) {
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:kAWBInfoKeyMyRoadsignSequenceNumber];
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:kAWBInfoKeyMyRoadsignStoreRoadsignIndex];
        BOOL success = AWBCopyRoadsignHelpFilesForDevice();  
        if (success) {
            NSString *path = [self myRoadsignDescriptorArchivePath];
            myRoadsigns = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] retain];
        }
    }
    
    if (!myRoadsigns) {
        //roadsign help files not copied so create empty collage store
        myRoadsigns = [[NSMutableArray alloc] init];
    }
}

- (void)fetchTemplateRoadsignsIfNecessary
{
    if (!templateRoadsigns) {
        NSString *path = [self templateRoadsignDescriptorArchivePath];
        templateRoadsigns = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] retain];
    }
    
    if (!templateRoadsigns) {
        //shouldn't happen - but don't want a nil if it does
        templateRoadsigns = [[NSMutableArray alloc] init];
    }
}

@end
