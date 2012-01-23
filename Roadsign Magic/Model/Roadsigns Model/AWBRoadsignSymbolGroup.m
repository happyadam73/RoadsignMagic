//
//  AWBRoadsignSymbolGroup.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 29/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignSymbolGroup.h"
#import "AWBRoadsignSymbol.h"
#import "NSString+Helpers.h"

@implementation AWBRoadsignSymbolGroup

@synthesize signSymbols, signSymbolGroupId, groupDescription, thumbnailImageFilename;
@synthesize purchasePack, isAvailable;

- (id)initWithIdentifier:(NSUInteger)symbolGroupId description:(NSString *)description thumbnailImageFilename:(NSString *)imageFilename signSymbols:(NSArray *)symbols
{
    self = [super init];
    if (self) {
        self.signSymbolGroupId = symbolGroupId;
        self.groupDescription = description;
        self.thumbnailImageFilename = imageFilename;
        self.signSymbols = symbols;
    }
    return self;
}

- (void)dealloc
{
    [groupDescription release];
    [thumbnailImageFilename release];
    [signSymbols release];
    [super dealloc];
}

- (BOOL)isAvailable
{
    switch (self.purchasePack) {
        case AWBRoadsignSymbolGroupPurchasePack1:
            return IS_SIGNPACK1_PURCHASED;
            break;
        case AWBRoadsignSymbolGroupPurchasePack2:
            return IS_SIGNPACK2_PURCHASED;
        default:
            return YES;
            break;
    }
}

- (UIImage *)purchasePackImage
{
    switch (self.purchasePack) {
        case AWBRoadsignSymbolGroupPurchasePack1:
            return [UIImage imageNamed:@"signpack1"];
            break;
        case AWBRoadsignSymbolGroupPurchasePack2:
            return [UIImage imageNamed:@"signpack2"];
        default:
            return nil;
            break;
    }    
}

- (NSString *)purchasePackDescription
{
    switch (self.purchasePack) {
        case AWBRoadsignSymbolGroupPurchasePack1:
            return @"Signs & Symbols (Pack 1)";
            break;
        case AWBRoadsignSymbolGroupPurchasePack2:
            return @"Signs & Symbols (Pack 2)";
        default:
            return nil;
            break;
    }    
}

+ (AWBRoadsignSymbolGroup *)roadsignSymbolGroupWithCategoryId:(NSUInteger)categoryId count:(NSUInteger)count description:(NSString *)description purchasePack:(AWBRoadsignSymbolGroupPurchasePack)purchasePackCode
{
    NSUInteger signSymbolId = (categoryId * 1000) + 1;
    NSMutableArray *symbols = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSUInteger symbolId = signSymbolId; symbolId < (signSymbolId + count); symbolId++) {
        [symbols addObject:[AWBRoadsignSymbol signSymbolWithIdentifier:symbolId]];
    }
    
    NSString *imageNumberString = [[NSString stringWithFormat:@"%d", categoryId] stringByPaddingTheLeftToLength:2 withString:@"0" startingAtIndex:0];
    NSString *thumbnailFilename = [NSString stringWithFormat:@"S%@.png", imageNumberString];    
    AWBRoadsignSymbolGroup *symbolGroup = [[[self alloc] initWithIdentifier:categoryId description:description thumbnailImageFilename:thumbnailFilename signSymbols:symbols] autorelease];
    [symbols release];
    symbolGroup.purchasePack = purchasePackCode;
    return symbolGroup;
}

+ (NSArray *)allSignSymbolCategories
{
    return [NSArray arrayWithObjects:
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:0 count:48 description:@"Arrow Sign Symbols" purchasePack:AWBRoadsignSymbolGroupPurchasePackNone],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:3 count:32 description:@"Junction Sign Symbols" purchasePack:AWBRoadsignSymbolGroupPurchasePackNone],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:7 count:31 description:@"Road Hazard Sign Symbols" purchasePack:AWBRoadsignSymbolGroupPurchasePackNone],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:1 count:40 description:@"Regulatory Sign Symbols" purchasePack:AWBRoadsignSymbolGroupPurchasePackNone],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:4 count:42 description:@"People and Animal Sign Symbols" purchasePack:AWBRoadsignSymbolGroupPurchasePack1],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:5 count:41 description:@"Vehicle Sign Symbols" purchasePack:AWBRoadsignSymbolGroupPurchasePack1],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:2 count:44 description:@"Tourist Sign Symbols" purchasePack:AWBRoadsignSymbolGroupPurchasePack2],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:6 count:30 description:@"Hazard Warning Sign Symbols" purchasePack:AWBRoadsignSymbolGroupPurchasePack2],
            nil];
}

@end
