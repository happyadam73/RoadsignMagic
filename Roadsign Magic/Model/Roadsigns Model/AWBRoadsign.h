//
//  AWBRoadsign.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/12/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBRoadsignBackground.h"

static NSString *const kAWBInfoKeyRoadsignViews = @"RoadsignViews";
static NSString *const kAWBInfoKeyRoadsignBackgroundId = @"RoadsignBackgroundId";

@interface AWBRoadsign : NSObject {
    CGFloat exportSize;
    NSUInteger roadsignBackgroundId;
    NSMutableArray *roadsignViews;
    NSUInteger totalLabels;
    NSUInteger totalSymbols;
    NSUInteger totalImageMemoryBytes;
}

@property (nonatomic, assign) CGFloat exportSize;
@property (nonatomic, assign) NSUInteger roadsignBackgroundId;
@property (nonatomic, retain) NSMutableArray *roadsignViews;
@property (nonatomic, readonly) NSUInteger totalLabels;
@property (nonatomic, readonly) NSUInteger totalSymbols;
@property (nonatomic, readonly) NSUInteger totalImageMemoryBytes;

- (void)addRoadsignToView:(UIView *)roadsignBackgroundView;
- (void)initRoadsignFromView:(UIImageView *)roadsignBackgroundView;
- (AWBRoadsignBackground *)roadsignBackground;

@end
