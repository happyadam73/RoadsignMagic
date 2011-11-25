//
//  AWBRoadsignBackground.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 25/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignBackground.h"

@implementation AWBRoadsignBackground

@synthesize signBackgroundId, fullsizeImageFilename, thumbnailImageFilename, primaryColorCode;

- (id)initWithIdentifier:(NSUInteger)backgroundId fullSizeImageFilename:(NSString *)fullSizeFilename thumbnailImageFilename:(NSString *)thumbnailFilename colorCode:(AWBSignColorCode)colorCode
{
    self = [super init];
    if (self) {
        self.signBackgroundId = backgroundId;
        self.fullsizeImageFilename = fullSizeFilename;
        self.thumbnailImageFilename = thumbnailFilename;
        self.primaryColorCode = colorCode;
    }
    return self;
}

- (void)dealloc
{
    [fullsizeImageFilename release];
    [thumbnailImageFilename release];
    [super dealloc];
}

+ (id)signBackgroundWithIdentifier:(NSUInteger)backgroundId fullSizeImageFilename:(NSString *)fullSizeFilename thumbnailImageFilename:(NSString *)thumbnailFilename colorCode:(AWBSignColorCode)colorCode
{
    return [[[self alloc] initWithIdentifier:backgroundId fullSizeImageFilename:fullSizeFilename thumbnailImageFilename:thumbnailFilename colorCode:colorCode] autorelease];
}

@end
