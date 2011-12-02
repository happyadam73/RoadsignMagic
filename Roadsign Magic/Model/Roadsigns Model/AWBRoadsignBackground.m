//
//  AWBRoadsignBackground.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 25/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignBackground.h"
#import "NSString+Helpers.h"

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

+ (id)signBackgroundWithIdentifier:(NSUInteger)backgroundId
{
    NSString *imageNumberString = [[NSString stringWithFormat:@"%d", backgroundId] stringByPaddingTheLeftToLength:4 withString:@"0" startingAtIndex:0];
    NSString *fullSizeFilename = [NSString stringWithFormat:@"2%@.png", imageNumberString];
    NSString *thumbnailFilename = [NSString stringWithFormat:@"1%@.png", imageNumberString];    
    AWBSignColorCode colorCode = [AWBRoadsignBackground signColorCodeFromSignId:backgroundId];
        
    return [[[self alloc] initWithIdentifier:backgroundId fullSizeImageFilename:fullSizeFilename thumbnailImageFilename:thumbnailFilename colorCode:colorCode] autorelease];
}

+ (AWBSignColorCode)signColorCodeFromSignId:(NSUInteger)signId
{
    AWBSignColorCode primaryColorCode;
    
    switch (signId) {
        case 1 ... 2:
        case 4 ... 11:
        case 13 ... 15:
        case 6019 ... 6022:
            primaryColorCode = kAWBSignColorCodeBlueSignBackgroundColor; 
            break;
        case 1001 ... 1009:
            primaryColorCode = kAWBSignColorCodeDarkGreenSignBackgroundColor;
            break;
        case 2001 ... 2014:
        case 6011 ... 6018:
            primaryColorCode = kAWBSignColorCodeBrownSignBackgroundColor;
            break;
        case 3:
        case 12:
        case 3001 ... 3012:
        case 3015 ... 3018:
        case 6001 ... 6004:
            primaryColorCode = kAWBSignColorCodeWhiteBackgroundColor;
            break;
        case 3013 ... 3014:
        case 3019:
        case 6025 ... 6026:
            primaryColorCode = kAWBSignColorCodeBlackBackgroundColor;
            break;
        case 4001 ... 4010:
        case 6027 ... 6028:
            primaryColorCode = kAWBSignColorCodeRedSignBackgroundColor;
            break;
        case 5001 ... 5015:
        case 6005 ... 6010:
            primaryColorCode = kAWBSignColorCodeYellowSignBackgroundColor;
            break;
        case 6023 ... 6024:
            primaryColorCode = kAWBSignColorCodeLightGreenSignBackgroundColor;
            break;
        default:
            primaryColorCode = kAWBSignColorCodeWhiteBackgroundColor;
            break;
    }
    
    return primaryColorCode;
}

@end
