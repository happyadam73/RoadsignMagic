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

+ (AWBRoadsignSymbolGroup *)roadsignSymbolGroupWithCategoryId:(NSUInteger)categoryId count:(NSUInteger)count description:(NSString *)description
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
    
    return symbolGroup;
}

+ (NSArray *)allSignSymbolCategories
{
    return [NSArray arrayWithObjects:
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:0 count:42 description:@"Arrow Sign Symbols"],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:1 count:31 description:@"Regulatory Sign Symbols"],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:2 count:42 description:@"Tourist Sign Symbols"],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:3 count:26 description:@"Junction Sign Symbols"],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:4 count:40 description:@"People and Animal Sign Symbols"],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:5 count:38 description:@"Vehicle Sign Symbols"],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:6 count:23 description:@"Hazard Warning Sign Symbols"],
            nil];
}

@end
