//
//  AWBRoadsignDescriptor.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/12/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kAWBInfoKeyRoadsignName = @"RoadsignName";
static NSString *const kAWBInfoKeyRoadsignDocumentsSubdirectory = @"RoadsignDocumentsSubdirectory";
static NSString *const kAWBInfoKeyRoadsignCreatedDate = @"RoadsignCreatedDate";
//static NSString *const kAWBInfoKeyCollageThemeType = @"CollageThemeType";
static NSString *const kAWBInfoKeyRoadsignTotalImageObjects = @"RoadsignTotalImageObjects";
static NSString *const kAWBInfoKeyRoadsignTotalLabelObjects = @"RoadsignTotalLabelObjects";
static NSString *const kAWBInfoKeyRoadsignTotalImageMemoryBytes = @"RoadsignTotalImageMemoryBytes";
static NSString *const kAWBInfoKeyRoadsignTotalDiskBytes = @"RoadsignTotalDiskBytes";

@interface AWBRoadsignDescriptor : NSObject {
    NSString *roadsignSaveDocumentsSubdirectory; 
    NSString *roadsignName;
    NSDate *createdDate;
//    CollageThemeType themeType;
    NSUInteger totalImageObjects;
    NSUInteger totalLabelObjects; 
    NSUInteger totalImageMemoryBytes;
//    BOOL addContentOnCreation;
}

@property (nonatomic, retain) NSString *roadsignSaveDocumentsSubdirectory;
@property (nonatomic, retain) NSString *roadsignName;
@property (nonatomic, readonly) NSDate *createdDate;
//@property (nonatomic, assign) CollageThemeType themeType;
@property (nonatomic, assign) NSUInteger totalImageObjects;
@property (nonatomic, assign) NSUInteger totalLabelObjects;
@property (nonatomic, readonly) NSUInteger totalObjects;
@property (nonatomic, assign) NSUInteger totalImageMemoryBytes; 
//@property (nonatomic, assign) BOOL addContentOnCreation;

- (id)initWithRoadsignName:(NSString *)name documentsSubdirectory:(NSString *)subDirectory;
- (id)initWithRoadsignDocumentsSubdirectory:(NSString *)subDirectory;
//- (CollageTheme *)theme;
- (UIImageView *)roadsignThumbnailImageView;
- (UIView *)roadsignInfoHeaderView;
- (UILabel *)roadsignNameLabel;
- (UILabel *)roadsignCreatedDateLabel;
- (UILabel *)roadsignUpdatedDateLabel;

@end
