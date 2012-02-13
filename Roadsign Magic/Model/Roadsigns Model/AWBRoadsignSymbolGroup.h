//
//  AWBRoadsignSymbolGroup.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 29/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AWBRoadsignSymbolGroupPurchasePackNone,
    AWBRoadsignSymbolGroupPurchasePack1,              
    AWBRoadsignSymbolGroupPurchasePack2,
    AWBRoadsignSymbolGroupPurchasePack3    
} AWBRoadsignSymbolGroupPurchasePack;

@interface AWBRoadsignSymbolGroup : NSObject {
    NSUInteger signSymbolGroupId;
    NSArray *signSymbols;
    NSString *groupDescription;
    NSString *thumbnailImageFilename;
    AWBRoadsignSymbolGroupPurchasePack purchasePack;
}

@property (nonatomic, assign) NSUInteger signSymbolGroupId;
@property (nonatomic, retain) NSArray *signSymbols;
@property (nonatomic, retain) NSString *groupDescription;
@property (nonatomic, retain) NSString *thumbnailImageFilename;
@property (nonatomic, assign) AWBRoadsignSymbolGroupPurchasePack purchasePack;
@property (nonatomic, readonly) BOOL isAvailable;

- (id)initWithIdentifier:(NSUInteger)symbolGroupId description:(NSString *)description thumbnailImageFilename:(NSString *)imageFilename signSymbols:(NSArray *)symbols;
- (UIImage *)purchasePackImage;
- (NSString *)purchasePackDescription;
+ (AWBRoadsignSymbolGroup *)roadsignSymbolGroupWithCategoryId:(NSUInteger)categoryId count:(NSUInteger)count description:(NSString *)description purchasePack:(AWBRoadsignSymbolGroupPurchasePack)purchasePackCode;
+ (NSArray *)allSignSymbolCategories;

@end
