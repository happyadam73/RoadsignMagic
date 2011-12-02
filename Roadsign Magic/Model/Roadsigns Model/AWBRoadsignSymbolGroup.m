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
                        [AWBRoadsignSymbol signSymbolWithIdentifier:1 fullSizeImageFilename:@"S20001.png" thumbnailImageFilename:@"S10001.png"],
                        [AWBRoadsignSymbol signSymbolWithIdentifier:2 fullSizeImageFilename:@"S20002.png" thumbnailImageFilename:@"S10002.png"],
                        [AWBRoadsignSymbol signSymbolWithIdentifier:3 fullSizeImageFilename:@"S20003.png" thumbnailImageFilename:@"S10003.png"],
                        [AWBRoadsignSymbol signSymbolWithIdentifier:4 fullSizeImageFilename:@"S20004.png" thumbnailImageFilename:@"S10004.png"],
                        [AWBRoadsignSymbol signSymbolWithIdentifier:5 fullSizeImageFilename:@"S20005.png" thumbnailImageFilename:@"S10005.png"],
                        [AWBRoadsignSymbol signSymbolWithIdentifier:6 fullSizeImageFilename:@"S20006.png" thumbnailImageFilename:@"S10006.png"],
                        nil];
    return [[[self alloc] initWithIdentifier:0 description:@"Arrow Sign Symbols" thumbnailImageFilename:@"S00.png" signSymbols:symbols] autorelease];
}

+ (AWBRoadsignSymbolGroup *)regulatorySignSymbols
{
    NSArray *symbols = [NSArray arrayWithObjects:
                        [AWBRoadsignSymbol signSymbolWithIdentifier:1001 fullSizeImageFilename:@"S21001.png" thumbnailImageFilename:@"S11001.png"],
                        [AWBRoadsignSymbol signSymbolWithIdentifier:1002 fullSizeImageFilename:@"S21002.png" thumbnailImageFilename:@"S11002.png"],
                        nil];
    return [[[self alloc] initWithIdentifier:0 description:@"Regulatory Sign Symbols" thumbnailImageFilename:@"S01.png" signSymbols:symbols] autorelease];
}

+ (AWBRoadsignSymbolGroup *)touristSignSymbols
{
    NSArray *symbols = [NSArray arrayWithObjects:
                        [AWBRoadsignSymbol signSymbolWithIdentifier:2001 fullSizeImageFilename:@"S22001.png" thumbnailImageFilename:@"S12001.png"],
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
