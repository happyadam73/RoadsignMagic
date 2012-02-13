//
//  AWBRoadsignStore.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/12/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kAWBInfoKeyMyRoadsignSequenceNumber = @"RoadsignSequenceNumber";
static NSString *const kAWBInfoKeyMyRoadsignStoreRoadsignIndex = @"RoadsignStoreRoadsignIndex";
static NSString *const kAWBInfoKeyScrollToRoadsignStoreMyRoadsignIndex = @"ScrollToRoadsignStoreRoadsignIndex";
static NSString *const kAWBInfoKeyScrollToTemplateStoreMyTemplateIndex = @"ScrollToTemplateStoreMyTemplateIndex";

@class AWBRoadsignDescriptor;

@interface AWBRoadsignStore : NSObject {
    NSMutableArray *myRoadsigns;
    NSMutableArray *templateRoadsigns;
}

+ (AWBRoadsignStore *)defaultStore;

- (NSArray *)myRoadsigns;
- (NSArray *)templateRoadsigns;
- (AWBRoadsignDescriptor *)createMyRoadsign;
- (AWBRoadsignDescriptor *)createMyRoadsignFromTemplateRoadsign:(AWBRoadsignDescriptor *)templateRoadsign;
- (void)removeMyRoadsign:(AWBRoadsignDescriptor *)roadsign;
- (void)moveMyRoadsignAtIndex:(int)from toIndex:(int)to;
- (NSString *)myRoadsignDescriptorArchivePath;
- (NSString *)templateRoadsignDescriptorArchivePath;
- (BOOL)saveMyRoadsigns;
- (void)fetchMyRoadsignsIfNecessary;
- (void)fetchTemplateRoadsignsIfNecessary;
- (NSString *)nextDefaultRoadsignName;

@end
