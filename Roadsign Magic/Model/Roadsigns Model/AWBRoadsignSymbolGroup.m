//
//  AWBRoadsignSymbolGroup.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 29/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
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

//+ (AWBRoadsignSymbolGroup *)arrowSignSymbols
//{
//    NSArray *symbols = [NSArray arrayWithObjects:
//                        [AWBRoadsignSymbol signSymbolWithIdentifier:1],
//                        [AWBRoadsignSymbol signSymbolWithIdentifier:2],
//                        [AWBRoadsignSymbol signSymbolWithIdentifier:3],
//                        [AWBRoadsignSymbol signSymbolWithIdentifier:4],
//                        [AWBRoadsignSymbol signSymbolWithIdentifier:5],
//                        [AWBRoadsignSymbol signSymbolWithIdentifier:6],
//                        nil];
//    return [[[self alloc] initWithIdentifier:0 description:@"Arrow Sign Symbols" thumbnailImageFilename:@"S00.png" signSymbols:symbols] autorelease];
//}
//
//+ (AWBRoadsignSymbolGroup *)regulatorySignSymbols
//{
//    NSArray *symbols = [NSArray arrayWithObjects:
//                        [AWBRoadsignSymbol signSymbolWithIdentifier:1001],
//                        [AWBRoadsignSymbol signSymbolWithIdentifier:1002],
//                        nil];
//    return [[[self alloc] initWithIdentifier:0 description:@"Regulatory Sign Symbols" thumbnailImageFilename:@"S01.png" signSymbols:symbols] autorelease];
//}
//
//+ (AWBRoadsignSymbolGroup *)touristSignSymbols
//{
//    NSArray *symbols = [NSArray arrayWithObjects:
//                        [AWBRoadsignSymbol signSymbolWithIdentifier:2001],
//                        nil];
//    return [[[self alloc] initWithIdentifier:0 description:@"Tourist Sign Symbols" thumbnailImageFilename:@"S02.png" signSymbols:symbols] autorelease];
//}

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
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:0 count:14 description:@"Arrow Sign Symbols"],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:1 count:2 description:@"Regulatory Sign Symbols"],
            [AWBRoadsignSymbolGroup roadsignSymbolGroupWithCategoryId:2 count:1 description:@"Tourist Sign Symbols"],
//            [AWBRoadsignSymbolGroup arrowSignSymbols], 
//            [AWBRoadsignSymbolGroup regulatorySignSymbols], 
//            [AWBRoadsignSymbolGroup touristSignSymbols], 
            nil];
}

@end
