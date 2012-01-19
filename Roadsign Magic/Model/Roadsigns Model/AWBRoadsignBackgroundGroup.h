//
//  AWBRoadsignBackgroundGroup.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 25/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBRoadsignSymbolGroup.h"

@interface AWBRoadsignBackgroundGroup : NSObject {
    NSUInteger signBackgroundGroupId;
    NSArray *signBackgrounds;
    NSString *groupDescription;
    NSString *thumbnailImageFilename;
    AWBRoadsignSymbolGroupPurchasePack purchasePack;
    BOOL isAvailable;
}

@property (nonatomic, assign) NSUInteger signBackgroundGroupId;
@property (nonatomic, retain) NSArray *signBackgrounds;
@property (nonatomic, retain) NSString *groupDescription;
@property (nonatomic, retain) NSString *thumbnailImageFilename;
@property (nonatomic, assign) AWBRoadsignSymbolGroupPurchasePack purchasePack;
@property (nonatomic, readonly) BOOL isAvailable;

- (id)initWithIdentifier:(NSUInteger)backgroundGroupId description:(NSString *)description thumbnailImageFilename:(NSString *)imageFilename signBackgrounds:(NSArray *)backgrounds;
- (UIImage *)purchasePackImage;
- (NSString *)purchasePackDescription;

+ (AWBRoadsignBackgroundGroup *)roadsignBackgroundGroupWithCategoryId:(NSUInteger)categoryId count:(NSUInteger)count description:(NSString *)description purchasePack:(AWBRoadsignSymbolGroupPurchasePack)purchasePackCode;
+ (NSArray *)allSignBackgroundCategories;

@end
