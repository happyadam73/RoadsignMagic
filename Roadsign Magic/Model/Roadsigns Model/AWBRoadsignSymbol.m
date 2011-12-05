//
//  AWBRoadsignSymbol.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 29/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignSymbol.h"
#import "NSString+Helpers.h"

@implementation AWBRoadsignSymbol

@synthesize signSymbolId, fullsizeImageFilename, thumbnailImageFilename;

- (id)initWithIdentifier:(NSUInteger)symbolId fullSizeImageFilename:(NSString *)fullSizeFilename thumbnailImageFilename:(NSString *)thumbnailFilename
{
    self = [super init];
    if (self) {
        self.signSymbolId = symbolId;
        self.fullsizeImageFilename = fullSizeFilename;
        self.thumbnailImageFilename = thumbnailFilename;
    }
    return self;
}

- (void)dealloc
{
    [fullsizeImageFilename release];
    [thumbnailImageFilename release];
    [super dealloc];
}

+ (id)signSymbolWithIdentifier:(NSUInteger)symbolId fullSizeImageFilename:(NSString *)fullSizeFilename thumbnailImageFilename:(NSString *)thumbnailFilename
{
    return [[[self alloc] initWithIdentifier:symbolId fullSizeImageFilename:fullSizeFilename thumbnailImageFilename:thumbnailFilename] autorelease];
}

+ (id)signSymbolWithIdentifier:(NSUInteger)symbolId
{
    NSString *imageNumberString = [[NSString stringWithFormat:@"%d", symbolId] stringByPaddingTheLeftToLength:4 withString:@"0" startingAtIndex:0];
    NSString *fullSizeFilename = [NSString stringWithFormat:@"S2%@.png", imageNumberString];
    NSString *thumbnailFilename = [NSString stringWithFormat:@"S1%@.png", imageNumberString];    
    return [[[self alloc] initWithIdentifier:symbolId fullSizeImageFilename:fullSizeFilename thumbnailImageFilename:thumbnailFilename] autorelease];
}

@end
