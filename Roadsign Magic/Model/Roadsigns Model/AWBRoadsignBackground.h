//
//  AWBRoadsignBackground.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 25/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+SignColors.h"

@interface AWBRoadsignBackground : NSObject {
    NSUInteger signBackgroundId;
    NSString *fullsizeImageFilename;
    NSString *thumbnailImageFilename;
    AWBSignColorCode primaryColorCode;
}

@property (nonatomic, assign) NSUInteger signBackgroundId;
@property (nonatomic, retain) NSString *fullsizeImageFilename;
@property (nonatomic, retain) NSString *thumbnailImageFilename;
@property (nonatomic, assign) AWBSignColorCode primaryColorCode;

- (id)initWithIdentifier:(NSUInteger)backgroundId fullSizeImageFilename:(NSString *)fullSizeFilename thumbnailImageFilename:(NSString *)thumbnailFilename colorCode:(AWBSignColorCode)colorCode;
+ (id)signBackgroundWithIdentifier:(NSUInteger)backgroundId fullSizeImageFilename:(NSString *)fullSizeFilename thumbnailImageFilename:(NSString *)thumbnailFilename colorCode:(AWBSignColorCode)colorCode;
+ (id)signBackgroundWithIdentifier:(NSUInteger)backgroundId;
+ (AWBSignColorCode)signColorCodeFromSignId:(NSUInteger)signId;

@end
