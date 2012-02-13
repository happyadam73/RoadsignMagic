//
//  AWBRoadsignBackgroundGroup.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 25/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignBackgroundGroup.h"
#import "AWBRoadsignBackground.h"
#import "NSString+Helpers.h"

@implementation AWBRoadsignBackgroundGroup

@synthesize signBackgrounds, signBackgroundGroupId, groupDescription, thumbnailImageFilename;
@synthesize purchasePack, isAvailable;

- (id)initWithIdentifier:(NSUInteger)backgroundGroupId description:(NSString *)description thumbnailImageFilename:(NSString *)imageFilename signBackgrounds:(NSArray *)backgrounds
{
    self = [super init];
    if (self) {
        self.signBackgroundGroupId = backgroundGroupId;
        self.groupDescription = description;
        self.thumbnailImageFilename = imageFilename;
        self.signBackgrounds = backgrounds;
    }
    return self;
}

- (void)dealloc
{
    [groupDescription release];
    [thumbnailImageFilename release];
    [signBackgrounds release];
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
        case AWBRoadsignSymbolGroupPurchasePack3:
            return IS_SIGNPACK3_PURCHASED;   
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
        case AWBRoadsignSymbolGroupPurchasePack3:
            return [UIImage imageNamed:@"signpack3"];
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
        case AWBRoadsignSymbolGroupPurchasePack3:
            return @"US Highway Signs & Symbols";
        default:
            return nil;
            break;
    }    
}

+ (AWBRoadsignBackgroundGroup *)roadsignBackgroundGroupWithCategoryId:(NSUInteger)categoryId count:(NSUInteger)count description:(NSString *)description purchasePack:(AWBRoadsignSymbolGroupPurchasePack)purchasePackCode
{
    NSUInteger signBackgroundId = (categoryId * 1000) + 1;
    NSMutableArray *signs = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSUInteger signId = signBackgroundId; signId < (signBackgroundId + count); signId++) {
        [signs addObject:[AWBRoadsignBackground signBackgroundWithIdentifier:signId]];
    }
    
    NSString *imageNumberString = [[NSString stringWithFormat:@"%d", categoryId] stringByPaddingTheLeftToLength:2 withString:@"0" startingAtIndex:0];
    NSString *thumbnailFilename = [NSString stringWithFormat:@"%@.png", imageNumberString];    
    AWBRoadsignBackgroundGroup *signGroup = [[[self alloc] initWithIdentifier:categoryId description:description thumbnailImageFilename:thumbnailFilename signBackgrounds:signs] autorelease];
    [signs release];
    signGroup.purchasePack = purchasePackCode;

    return signGroup;
}

+ (NSArray *)allSignBackgroundCategories
{
    return [NSArray arrayWithObjects:
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:8 count:4 description:@"No Sign Backgrounds" purchasePack:AWBRoadsignSymbolGroupPurchasePackNone],            
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:0 count:15 description:@"Blue Rectangular Backgrounds" purchasePack:AWBRoadsignSymbolGroupPurchasePackNone],
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:1 count:9 description:@"Green Rectangular Backgrounds" purchasePack:AWBRoadsignSymbolGroupPurchasePackNone],
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:2 count:14 description:@"Brown Rectangular Backgrounds" purchasePack:AWBRoadsignSymbolGroupPurchasePackNone],
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:3 count:21 description:@"White Rectangular Backgrounds" purchasePack:AWBRoadsignSymbolGroupPurchasePackNone],
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:4 count:10 description:@"Red Rectangular Backgrounds" purchasePack:AWBRoadsignSymbolGroupPurchasePackNone],
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:5 count:15 description:@"Yellow Rectangular Backgrounds" purchasePack:AWBRoadsignSymbolGroupPurchasePackNone],
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:7 count:15 description:@"Triangles and Circular Backgrounds" purchasePack:AWBRoadsignSymbolGroupPurchasePack1],            
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:6 count:28 description:@"Signpost Backgrounds" purchasePack:AWBRoadsignSymbolGroupPurchasePack2],  
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:9 count:50 description:@"US Signpost Backgrounds" purchasePack:AWBRoadsignSymbolGroupPurchasePack3],  
            nil];
}

@end
