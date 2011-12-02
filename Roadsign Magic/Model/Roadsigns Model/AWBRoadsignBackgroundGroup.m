//
//  AWBRoadsignBackgroundGroup.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 25/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignBackgroundGroup.h"
#import "AWBRoadsignBackground.h"
#import "NSString+Helpers.h"

@implementation AWBRoadsignBackgroundGroup

@synthesize signBackgrounds, signBackgroundGroupId, groupDescription, thumbnailImageFilename;

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

//+ (AWBRoadsignBackgroundGroup *)blueRectangularSignBackgrounds
//{
//    return [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:0 count:15 description:@"Blue Rectangular Backgrounds"]; 
//}
//
//+ (AWBRoadsignBackgroundGroup *)greenRectangularSignBackgrounds
//{
//    
//    NSArray *signs = [NSArray arrayWithObjects:
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:1001],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:1002],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:1003],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:1004],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:1005],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:1006],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:1007],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:1008],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:1009],
//                      nil];
//    return [[[self alloc] initWithIdentifier:1 description:@"Green Rectangular Backgrounds" thumbnailImageFilename:@"01.png" signBackgrounds:signs] autorelease];
//}
//
//+ (AWBRoadsignBackgroundGroup *)brownRectangularSignBackgrounds
//{
//    NSArray *signs = [NSArray arrayWithObjects:
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2001],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2002],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2003],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2004],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2005],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2006],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2007],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2008],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2009],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2010],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2011],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2012],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2013],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:2014],
//                      nil];
//    return [[[self alloc] initWithIdentifier:2 description:@"Brown Rectangular Backgrounds" thumbnailImageFilename:@"02.png" signBackgrounds:signs] autorelease];
//}
//
//+ (AWBRoadsignBackgroundGroup *)whiteRectangularSignBackgrounds
//{
//    NSArray *signs = [NSArray arrayWithObjects:
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3001],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3002],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3003],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3004],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3005],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3006],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3007],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3008],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3009],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3010],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3011],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3012],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3013],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3014],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3015],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3016],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3017],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3018],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:3019],
//                      nil];
//    return [[[self alloc] initWithIdentifier:3 description:@"White Rectangular Backgrounds" thumbnailImageFilename:@"03.png" signBackgrounds:signs] autorelease];
//}
//
//+ (AWBRoadsignBackgroundGroup *)redRectangularSignBackgrounds
//{
//    NSArray *signs = [NSArray arrayWithObjects:
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:4001],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:4002],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:4003],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:4004],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:4005],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:4006],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:4007],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:4008],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:4009],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:4010],
//                      nil];
//    return [[[self alloc] initWithIdentifier:4 description:@"Red Rectangular Backgrounds" thumbnailImageFilename:@"04.png" signBackgrounds:signs] autorelease];
//}
//
//+ (AWBRoadsignBackgroundGroup *)yellowRectangularSignBackgrounds
//{
//    NSArray *signs = [NSArray arrayWithObjects:
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5001],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5002],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5003],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5004],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5005],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5006],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5007],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5008],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5009],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5010],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5011],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5012],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5013],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5014],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:5015],
//                      nil];
//    return [[[self alloc] initWithIdentifier:5 description:@"Yellow Rectangular Backgrounds" thumbnailImageFilename:@"05.png" signBackgrounds:signs] autorelease];
//}
//
//+ (AWBRoadsignBackgroundGroup *)signpostSignBackgrounds
//{
//    NSArray *signs = [NSArray arrayWithObjects:
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6001],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6002],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6003],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6004],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6005],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6006],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6007],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6008],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6009],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6010],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6011],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6012],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6013],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6014],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6015],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6016],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6017],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6018],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6019],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6020],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6021],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6022],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6023],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6024],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6025],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6026],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6027],
//                      [AWBRoadsignBackground signBackgroundWithIdentifier:6028],
//                      nil];
//    return [[[self alloc] initWithIdentifier:6 description:@"Signpost Backgrounds" thumbnailImageFilename:@"06.png" signBackgrounds:signs] autorelease];    
//}

+ (AWBRoadsignBackgroundGroup *)roadsignBackgroundGroupWithCategoryId:(NSUInteger)categoryId count:(NSUInteger)count description:(NSString *)description
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
    
    return signGroup;
}

+ (NSArray *)allSignBackgroundCategories
{
    return [NSArray arrayWithObjects:
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:0 count:15 description:@"Blue Rectangular Backgrounds"],
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:1 count:9 description:@"Green Rectangular Backgrounds"],
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:2 count:14 description:@"Brown Rectangular Backgrounds"],
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:3 count:19 description:@"White Rectangular Backgrounds"],
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:4 count:10 description:@"Red Rectangular Backgrounds"],
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:5 count:15 description:@"Yellow Rectangular Backgrounds"],
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:6 count:28 description:@"Signpost Backgrounds"],            
//            [AWBRoadsignBackgroundGroup blueRectangularSignBackgrounds], 
//            [AWBRoadsignBackgroundGroup greenRectangularSignBackgrounds], 
//            [AWBRoadsignBackgroundGroup brownRectangularSignBackgrounds], 
//            [AWBRoadsignBackgroundGroup whiteRectangularSignBackgrounds], 
//            [AWBRoadsignBackgroundGroup redRectangularSignBackgrounds], 
//            [AWBRoadsignBackgroundGroup yellowRectangularSignBackgrounds], 
//            [AWBRoadsignBackgroundGroup signpostSignBackgrounds],
            nil];
}

@end
