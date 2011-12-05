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
            [AWBRoadsignBackgroundGroup roadsignBackgroundGroupWithCategoryId:7 count:13 description:@"Triangles and Circular Backgrounds"],            
            nil];
}

@end
