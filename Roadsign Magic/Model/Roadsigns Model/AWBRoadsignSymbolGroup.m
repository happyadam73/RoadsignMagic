//
//  AWBRoadsignSymbolGroup.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 29/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignSymbolGroup.h"
#import "AWBRoadsignSymbol.h"

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

+ (AWBRoadsignSymbolGroup *)arrowSignSymbols
{
    NSArray *symbols = [NSArray arrayWithObjects:
                        [AWBRoadsignSymbol signSymbolWithIdentifier:1],
                        [AWBRoadsignSymbol signSymbolWithIdentifier:2],
                        [AWBRoadsignSymbol signSymbolWithIdentifier:3],
                        [AWBRoadsignSymbol signSymbolWithIdentifier:4],
                        [AWBRoadsignSymbol signSymbolWithIdentifier:5],
                        [AWBRoadsignSymbol signSymbolWithIdentifier:6],
                        nil];
    return [[[self alloc] initWithIdentifier:0 description:@"Arrow Sign Symbols" thumbnailImageFilename:@"S00.png" signSymbols:symbols] autorelease];
}

+ (AWBRoadsignSymbolGroup *)regulatorySignSymbols
{
    NSArray *symbols = [NSArray arrayWithObjects:
                        [AWBRoadsignSymbol signSymbolWithIdentifier:1001],
                        [AWBRoadsignSymbol signSymbolWithIdentifier:1002],
                        nil];
    return [[[self alloc] initWithIdentifier:0 description:@"Regulatory Sign Symbols" thumbnailImageFilename:@"S01.png" signSymbols:symbols] autorelease];
}

+ (AWBRoadsignSymbolGroup *)touristSignSymbols
{
    NSArray *symbols = [NSArray arrayWithObjects:
                        [AWBRoadsignSymbol signSymbolWithIdentifier:2001],
                        nil];
    return [[[self alloc] initWithIdentifier:0 description:@"Tourist Sign Symbols" thumbnailImageFilename:@"S02.png" signSymbols:symbols] autorelease];
}

+ (NSArray *)allSignSymbolCategories
{
    return [NSArray arrayWithObjects:
            [AWBRoadsignSymbolGroup arrowSignSymbols], 
            [AWBRoadsignSymbolGroup regulatorySignSymbols], 
            [AWBRoadsignSymbolGroup touristSignSymbols], 
            nil];
}

@end
