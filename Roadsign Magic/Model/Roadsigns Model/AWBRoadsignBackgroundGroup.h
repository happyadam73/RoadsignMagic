//
//  AWBRoadsignBackgroundGroup.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 25/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWBRoadsignBackgroundGroup : NSObject {
    NSUInteger signBackgroundGroupId;
    NSArray *signBackgrounds;
    NSString *groupDescription;
    NSString *thumbnailImageFilename;
}

@property (nonatomic, assign) NSUInteger signBackgroundGroupId;
@property (nonatomic, retain) NSArray *signBackgrounds;
@property (nonatomic, retain) NSString *groupDescription;
@property (nonatomic, retain) NSString *thumbnailImageFilename;

- (id)initWithIdentifier:(NSUInteger)backgroundGroupId description:(NSString *)description thumbnailImageFilename:(NSString *)imageFilename signBackgrounds:(NSArray *)backgrounds;

+ (AWBRoadsignBackgroundGroup *)roadsignBackgroundGroupWithCategoryId:(NSUInteger)categoryId count:(NSUInteger)count description:(NSString *)description;
+ (NSArray *)allSignBackgroundCategories;

@end
