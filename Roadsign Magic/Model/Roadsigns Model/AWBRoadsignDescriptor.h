//
//  AWBRoadsignDescriptor.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/12/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBRoadsignSymbolGroup.h"

static NSString *const kAWBInfoKeyRoadsignName = @"RoadsignName";
static NSString *const kAWBInfoKeyRoadsignDocumentsSubdirectory = @"RoadsignDocumentsSubdirectory";
static NSString *const kAWBInfoKeyRoadsignCreatedDate = @"RoadsignCreatedDate";
static NSString *const kAWBInfoKeyRoadsignTotalImageObjects = @"RoadsignTotalImageObjects";
static NSString *const kAWBInfoKeyRoadsignTotalLabelObjects = @"RoadsignTotalLabelObjects";
static NSString *const kAWBInfoKeyRoadsignTotalImageMemoryBytes = @"RoadsignTotalImageMemoryBytes";
static NSString *const kAWBInfoKeyRoadsignTotalDiskBytes = @"RoadsignTotalDiskBytes";

@interface AWBRoadsignDescriptor : NSObject {
    NSString *roadsignSaveDocumentsSubdirectory; 
    NSString *roadsignName;
    NSDate *createdDate;
    NSUInteger totalSymbolObjects;
    NSUInteger totalLabelObjects; 
    NSUInteger totalImageMemoryBytes;
}

@property (nonatomic, retain) NSString *roadsignSaveDocumentsSubdirectory;
@property (nonatomic, retain) NSString *roadsignName;
@property (nonatomic, readonly) NSDate *createdDate;
@property (nonatomic, assign) NSUInteger totalSymbolObjects;
@property (nonatomic, assign) NSUInteger totalLabelObjects;
@property (nonatomic, readonly) NSUInteger totalObjects;
@property (nonatomic, assign) NSUInteger totalImageMemoryBytes; 
@property (nonatomic, readonly) AWBRoadsignSymbolGroupPurchasePack templatePurchasePack;
@property (nonatomic, readonly) BOOL isTemplateAvailable;

- (id)initWithRoadsignName:(NSString *)name documentsSubdirectory:(NSString *)subDirectory;
- (id)initWithRoadsignDocumentsSubdirectory:(NSString *)subDirectory;
- (UIImageView *)roadsignThumbnailImageView;
- (UIView *)roadsignInfoHeaderView;
- (UILabel *)roadsignNameLabel;
- (UILabel *)roadsignCreatedDateLabel;
- (UILabel *)roadsignUpdatedDateLabel;
- (UIImage *)templatePurchasePackImage;
- (NSString *)templatePurchasePackDescription;

@end
