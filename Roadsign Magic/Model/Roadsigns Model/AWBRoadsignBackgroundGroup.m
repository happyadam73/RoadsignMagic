//
//  AWBRoadsignBackgroundGroup.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 25/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignBackgroundGroup.h"
#import "AWBRoadsignBackground.h"

@implementation AWBRoadsignBackgroundGroup

@synthesize signBackgrounds, signBackgroundGroupId, groupDescription, thumbnailImageFilename;

- (id)initWithIdentifier:(NSUInteger)backgroundGroupId description:(NSString *)description thumbnailImageFilename:(NSString *)imageFilename signBackgrounds:(NSArray *)backgrounds;
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

+ (AWBRoadsignBackgroundGroup *)blueRectangularSignBackgrounds
{
    AWBSignColorCode colorCode = kAWBSignColorCodeBlueSignBackgroundColor;
    NSArray *signs = [NSArray arrayWithObjects:
                      [AWBRoadsignBackground signBackgroundWithIdentifier:1 fullSizeImageFilename:@"20001.png" thumbnailImageFilename:@"10001.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2 fullSizeImageFilename:@"20002.png" thumbnailImageFilename:@"10002.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3 fullSizeImageFilename:@"20003.png" thumbnailImageFilename:@"10003.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:4 fullSizeImageFilename:@"20004.png" thumbnailImageFilename:@"10004.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5 fullSizeImageFilename:@"20005.png" thumbnailImageFilename:@"10005.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:6 fullSizeImageFilename:@"20006.png" thumbnailImageFilename:@"10006.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:7 fullSizeImageFilename:@"20007.png" thumbnailImageFilename:@"10007.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:8 fullSizeImageFilename:@"20008.png" thumbnailImageFilename:@"10008.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:9 fullSizeImageFilename:@"20009.png" thumbnailImageFilename:@"10009.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:10 fullSizeImageFilename:@"20010.png" thumbnailImageFilename:@"10010.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:11 fullSizeImageFilename:@"20011.png" thumbnailImageFilename:@"10011.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:12 fullSizeImageFilename:@"20012.png" thumbnailImageFilename:@"10012.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:13 fullSizeImageFilename:@"20013.png" thumbnailImageFilename:@"10013.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:14 fullSizeImageFilename:@"20014.png" thumbnailImageFilename:@"10014.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:15 fullSizeImageFilename:@"20015.png" thumbnailImageFilename:@"10015.png" colorCode:colorCode],
                      nil];
    return [[[self alloc] initWithIdentifier:0 description:@"Blue Rectangular Backgrounds" thumbnailImageFilename:@"00.png" signBackgrounds:signs] autorelease];
}

+ (AWBRoadsignBackgroundGroup *)greenRectangularSignBackgrounds
{
    AWBSignColorCode colorCode = kAWBSignColorCodeDarkGreenSignBackgroundColor;
    NSArray *signs = [NSArray arrayWithObjects:
                      [AWBRoadsignBackground signBackgroundWithIdentifier:1001 fullSizeImageFilename:@"21001.png" thumbnailImageFilename:@"11001.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:1002 fullSizeImageFilename:@"21002.png" thumbnailImageFilename:@"11002.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:1003 fullSizeImageFilename:@"21003.png" thumbnailImageFilename:@"11003.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:1004 fullSizeImageFilename:@"21004.png" thumbnailImageFilename:@"11004.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:1005 fullSizeImageFilename:@"21005.png" thumbnailImageFilename:@"11005.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:1006 fullSizeImageFilename:@"21006.png" thumbnailImageFilename:@"11006.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:1007 fullSizeImageFilename:@"21007.png" thumbnailImageFilename:@"11007.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:1008 fullSizeImageFilename:@"21008.png" thumbnailImageFilename:@"11008.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:1009 fullSizeImageFilename:@"21009.png" thumbnailImageFilename:@"11009.png" colorCode:colorCode],
                      nil];
    return [[[self alloc] initWithIdentifier:1 description:@"Green Rectangular Backgrounds" thumbnailImageFilename:@"01.png" signBackgrounds:signs] autorelease];
}

+ (AWBRoadsignBackgroundGroup *)brownRectangularSignBackgrounds
{
    AWBSignColorCode colorCode = kAWBSignColorCodeBrownSignBackgroundColor;
    NSArray *signs = [NSArray arrayWithObjects:
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2001 fullSizeImageFilename:@"22001.png" thumbnailImageFilename:@"12001.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2002 fullSizeImageFilename:@"22002.png" thumbnailImageFilename:@"12002.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2003 fullSizeImageFilename:@"22003.png" thumbnailImageFilename:@"12003.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2004 fullSizeImageFilename:@"22004.png" thumbnailImageFilename:@"12004.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2005 fullSizeImageFilename:@"22005.png" thumbnailImageFilename:@"12005.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2006 fullSizeImageFilename:@"22006.png" thumbnailImageFilename:@"12006.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2007 fullSizeImageFilename:@"22007.png" thumbnailImageFilename:@"12007.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2008 fullSizeImageFilename:@"22008.png" thumbnailImageFilename:@"12008.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2009 fullSizeImageFilename:@"22009.png" thumbnailImageFilename:@"12009.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2010 fullSizeImageFilename:@"22010.png" thumbnailImageFilename:@"12010.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2011 fullSizeImageFilename:@"22011.png" thumbnailImageFilename:@"12011.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2012 fullSizeImageFilename:@"22012.png" thumbnailImageFilename:@"12012.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2013 fullSizeImageFilename:@"22013.png" thumbnailImageFilename:@"12013.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:2014 fullSizeImageFilename:@"22014.png" thumbnailImageFilename:@"12014.png" colorCode:colorCode],
                      nil];
    return [[[self alloc] initWithIdentifier:2 description:@"Brown Rectangular Backgrounds" thumbnailImageFilename:@"02.png" signBackgrounds:signs] autorelease];
}

+ (AWBRoadsignBackgroundGroup *)whiteRectangularSignBackgrounds
{
    AWBSignColorCode colorCode = kAWBSignColorCodeWhiteBackgroundColor;
    NSArray *signs = [NSArray arrayWithObjects:
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3001 fullSizeImageFilename:@"23001.png" thumbnailImageFilename:@"13001.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3002 fullSizeImageFilename:@"23002.png" thumbnailImageFilename:@"13002.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3003 fullSizeImageFilename:@"23003.png" thumbnailImageFilename:@"13003.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3004 fullSizeImageFilename:@"23004.png" thumbnailImageFilename:@"13004.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3005 fullSizeImageFilename:@"23005.png" thumbnailImageFilename:@"13005.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3006 fullSizeImageFilename:@"23006.png" thumbnailImageFilename:@"13006.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3007 fullSizeImageFilename:@"23007.png" thumbnailImageFilename:@"13007.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3008 fullSizeImageFilename:@"23008.png" thumbnailImageFilename:@"13008.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3009 fullSizeImageFilename:@"23009.png" thumbnailImageFilename:@"13009.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3010 fullSizeImageFilename:@"23010.png" thumbnailImageFilename:@"13010.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3011 fullSizeImageFilename:@"23011.png" thumbnailImageFilename:@"13011.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3012 fullSizeImageFilename:@"23012.png" thumbnailImageFilename:@"13012.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3013 fullSizeImageFilename:@"23013.png" thumbnailImageFilename:@"13013.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3014 fullSizeImageFilename:@"23014.png" thumbnailImageFilename:@"13014.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3015 fullSizeImageFilename:@"23015.png" thumbnailImageFilename:@"13015.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3016 fullSizeImageFilename:@"23016.png" thumbnailImageFilename:@"13016.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3017 fullSizeImageFilename:@"23017.png" thumbnailImageFilename:@"13017.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3018 fullSizeImageFilename:@"23018.png" thumbnailImageFilename:@"13018.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:3019 fullSizeImageFilename:@"23019.png" thumbnailImageFilename:@"13019.png" colorCode:colorCode],
                      nil];
    return [[[self alloc] initWithIdentifier:3 description:@"White Rectangular Backgrounds" thumbnailImageFilename:@"03.png" signBackgrounds:signs] autorelease];
}

+ (AWBRoadsignBackgroundGroup *)redRectangularSignBackgrounds
{
    AWBSignColorCode colorCode = kAWBSignColorCodeRedSignBackgroundColor;
    NSArray *signs = [NSArray arrayWithObjects:
                      [AWBRoadsignBackground signBackgroundWithIdentifier:4001 fullSizeImageFilename:@"24001.png" thumbnailImageFilename:@"14001.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:4002 fullSizeImageFilename:@"24002.png" thumbnailImageFilename:@"14002.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:4003 fullSizeImageFilename:@"24003.png" thumbnailImageFilename:@"14003.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:4004 fullSizeImageFilename:@"24004.png" thumbnailImageFilename:@"14004.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:4005 fullSizeImageFilename:@"24005.png" thumbnailImageFilename:@"14005.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:4006 fullSizeImageFilename:@"24006.png" thumbnailImageFilename:@"14006.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:4007 fullSizeImageFilename:@"24007.png" thumbnailImageFilename:@"14007.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:4008 fullSizeImageFilename:@"24008.png" thumbnailImageFilename:@"14008.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:4009 fullSizeImageFilename:@"24009.png" thumbnailImageFilename:@"14009.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:4010 fullSizeImageFilename:@"24010.png" thumbnailImageFilename:@"14010.png" colorCode:colorCode],
                      nil];
    return [[[self alloc] initWithIdentifier:4 description:@"Red Rectangular Backgrounds" thumbnailImageFilename:@"04.png" signBackgrounds:signs] autorelease];
}

+ (AWBRoadsignBackgroundGroup *)yellowRectangularSignBackgrounds
{
    AWBSignColorCode colorCode = kAWBSignColorCodeYellowSignBackgroundColor;
    NSArray *signs = [NSArray arrayWithObjects:
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5001 fullSizeImageFilename:@"25001.png" thumbnailImageFilename:@"15001.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5002 fullSizeImageFilename:@"25002.png" thumbnailImageFilename:@"15002.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5003 fullSizeImageFilename:@"25003.png" thumbnailImageFilename:@"15003.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5004 fullSizeImageFilename:@"25004.png" thumbnailImageFilename:@"15004.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5005 fullSizeImageFilename:@"25005.png" thumbnailImageFilename:@"15005.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5006 fullSizeImageFilename:@"25006.png" thumbnailImageFilename:@"15006.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5007 fullSizeImageFilename:@"25007.png" thumbnailImageFilename:@"15007.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5008 fullSizeImageFilename:@"25008.png" thumbnailImageFilename:@"15008.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5009 fullSizeImageFilename:@"25009.png" thumbnailImageFilename:@"15009.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5010 fullSizeImageFilename:@"25010.png" thumbnailImageFilename:@"15010.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5011 fullSizeImageFilename:@"25011.png" thumbnailImageFilename:@"15011.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5012 fullSizeImageFilename:@"25012.png" thumbnailImageFilename:@"15012.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5013 fullSizeImageFilename:@"25013.png" thumbnailImageFilename:@"15013.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5014 fullSizeImageFilename:@"25014.png" thumbnailImageFilename:@"15014.png" colorCode:colorCode],
                      [AWBRoadsignBackground signBackgroundWithIdentifier:5015 fullSizeImageFilename:@"25015.png" thumbnailImageFilename:@"15015.png" colorCode:colorCode],
                      nil];
    return [[[self alloc] initWithIdentifier:5 description:@"Yellow Rectangular Backgrounds" thumbnailImageFilename:@"05.png" signBackgrounds:signs] autorelease];
}

+ (NSArray *)allSignBackgroundCategories
{
    return [NSArray arrayWithObjects:
            [AWBRoadsignBackgroundGroup blueRectangularSignBackgrounds], 
            [AWBRoadsignBackgroundGroup greenRectangularSignBackgrounds], 
            [AWBRoadsignBackgroundGroup brownRectangularSignBackgrounds], 
            [AWBRoadsignBackgroundGroup whiteRectangularSignBackgrounds], 
            [AWBRoadsignBackgroundGroup redRectangularSignBackgrounds], 
            [AWBRoadsignBackgroundGroup yellowRectangularSignBackgrounds],             
            nil];
}

@end
