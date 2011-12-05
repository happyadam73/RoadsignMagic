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

- (NSArray *)allRoadsigns
{
    // This ensures allCollages is created
    [self fetchRoadsignsIfNecessary];
    
    return allRoadsigns;
}

- (AWBRoadsignDescriptor *)createRoadsign
{
    [self fetchRoadsignsIfNecessary];
    
    NSInteger sequenceId = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyRoadsignSequenceNumber];
    sequenceId += 1;
    [[NSUserDefaults standardUserDefaults] setInteger:sequenceId forKey:kAWBInfoKeyRoadsignSequenceNumber];
    AWBRoadsignDescriptor *roadsign = [[[AWBRoadsignDescriptor alloc] initWithRoadsignDocumentsSubdirectory:[NSString stringWithFormat:@"Roadsign %d", sequenceId]] autorelease];
//    collage.themeType = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyCollageThemeType];
    if (roadsign) {
        [allRoadsigns addObject:roadsign];
    }
    
    return roadsign;
}

- (NSString *)nextDefaultRoadsignName
{
    NSInteger sequenceId = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyRoadsignSequenceNumber];
    sequenceId += 1;
    return [NSString stringWithFormat:@"Roadsign %d", sequenceId];
}

- (void)removeRoadsign:(AWBRoadsignDescriptor *)roadsign
{
    NSError *error;
    NSString *path = AWBDocumentSubdirectory([roadsign roadsignSaveDocumentsSubdirectory]);
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    [allRoadsigns removeObjectIdenticalTo:roadsign];
}

- (void)moveRoadsignAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    // Get pointer to object being moved
    AWBRoadsignDescriptor *roadsign = [allRoadsigns objectAtIndex:from];
    
    // Retain it... (retain count of p = 2)
    [roadsign retain];
    
    // Remove p from array, it is automatically sent release (retain count of p = 1)
    [allRoadsigns removeObjectAtIndex:from];
    
    // Insert p in array at new location, retained by array (retain count of p = 2)
    [allRoadsigns insertObject:roadsign atIndex:to];
    
    // Release p (retain count = 1, only owner is now array)
    [roadsign release];
}

- (NSString *)roadsignDescriptorArchivePath
{
    return AWBPathInDocumentDirectory(@"roadsignDescriptors.data");
}

- (BOOL)saveAllRoadsigns
{
    // returns success or failure
    return [NSKeyedArchiver archiveRootObject:allRoadsigns 
                                       toFile:[self roadsignDescriptorArchivePath]];
}

- (void)fetchRoadsignsIfNecessary
{
    if (!allRoadsigns) {
        NSString *path = [self roadsignDescriptorArchivePath];
        allRoadsigns = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] retain];
    }
    
    // If we tried to read one from disk but does not exist, then first try and copy the help collages from the bundle 
    if (!allRoadsigns) {
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:kAWBInfoKeyRoadsignSequenceNumber];
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:kAWBInfoKeyRoadsignStoreRoadsignIndex];
//        BOOL success = AWBCopyRoadsignHelpFilesForDevice();  
//        if (success) {
//            NSString *path = [self roadsignDescriptorArchivePath];
//            allRoadsigns = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] retain];
//        }
    }
    
    if (!allRoadsigns) {
        //collage help files not copied so create empty collage store
        allRoadsigns = [[NSMutableArray alloc] init];
    }
}

@end
