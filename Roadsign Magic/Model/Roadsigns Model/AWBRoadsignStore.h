//
//  AWBRoadsignStore.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/12/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kAWBInfoKeyRoadsignSequenceNumber = @"RoadsignSequenceNumber";
static NSString *const kAWBInfoKeyRoadsignStoreRoadsignIndex = @"RoadsignStoreRoadsignIndex";
static NSString *const kAWBInfoKeyScrollToRoadsignStoreRoadsignIndex = @"ScrollToRoadsignStoreRoadsignIndex";

@class AWBRoadsignDescriptor;

@interface AWBRoadsignStore : NSObject {
    NSMutableArray *allRoadsigns;
}

+ (AWBRoadsignStore *)defaultStore;

- (NSArray *)allRoadsigns;
- (AWBRoadsignDescriptor *)createRoadsign;
- (void)removeRoadsign:(AWBRoadsignDescriptor *)roadsign;
- (void)moveRoadsignAtIndex:(int)from toIndex:(int)to;
- (NSString *)roadsignDescriptorArchivePath;
- (BOOL)saveAllRoadsigns;
- (void)fetchRoadsignsIfNecessary;
- (NSString *)nextDefaultRoadsignName;

@end
