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
    NSUInteger roadsignBackgroundId;
    NSMutableArray *roadsignViews;
    NSUInteger totalLabels;
    NSUInteger totalSymbols;
    NSUInteger totalImageMemoryBytes;
    CGFloat exportSize;
    BOOL objectsLocked;
    BOOL canvasAnchored;
    BOOL snapToGrid;
    BOOL snapRotation;
    CGFloat snapToGridSize;
    NSUInteger exportFormatSelectedIndex;
    BOOL pngExportTransparentBackground;
    CGFloat jpgExportQualityValue;
    UIColor *roadsignBackgroundColor;
    NSString *roadsignBackgroundTexture;
    BOOL useBackgroundTexture;
    NSString *labelTextLine1;
    NSString *labelTextLine2;
    NSString *labelTextLine3;
    UIColor *labelTextColor;
    NSString *labelTextFont;
    UITextAlignment labelTextAlignment;
    BOOL addTextBorders;
    BOOL textRoundedBorders;
    BOOL addTextBackground;
    UIColor *textBorderColor;
    UIColor *textBackgroundColor;
}

@property (nonatomic, assign) NSUInteger roadsignBackgroundId;
@property (nonatomic, retain) NSMutableArray *roadsignViews;
@property (nonatomic, readonly) NSUInteger totalLabels;
@property (nonatomic, readonly) NSUInteger totalSymbols;
@property (nonatomic, readonly) NSUInteger totalImageMemoryBytes;
@property (nonatomic, assign) CGFloat exportSize;
@property (nonatomic, assign) BOOL canvasAnchored;
@property (nonatomic, assign) BOOL objectsLocked;
@property (nonatomic, assign) BOOL snapToGrid;
@property (nonatomic, assign) BOOL snapRotation;
@property (nonatomic, assign) CGFloat snapToGridSize;
@property (nonatomic, assign) NSUInteger exportFormatSelectedIndex;
@property (nonatomic, assign) BOOL pngExportTransparentBackground;
@property (nonatomic, assign) CGFloat jpgExportQualityValue;
@property (nonatomic, retain) UIColor *roadsignBackgroundColor;
@property (nonatomic, retain) NSString *roadsignBackgroundTexture;
@property (nonatomic, assign) BOOL useBackgroundTexture;
@property (nonatomic, retain) NSString *labelTextLine1;
@property (nonatomic, retain) NSString *labelTextLine2;
@property (nonatomic, retain) NSString *labelTextLine3;
@property (nonatomic, retain) UIColor *labelTextColor;
@property (nonatomic, retain) NSString *labelTextFont;
@property (nonatomic, assign) UITextAlignment labelTextAlignment;
@property (nonatomic, assign) BOOL addTextBorders;
@property (nonatomic, assign) BOOL textRoundedBorders;
@property (nonatomic, assign) BOOL addTextBackground;
@property (nonatomic, retain) UIColor *textBorderColor;
@property (nonatomic, retain) UIColor *textBackgroundColor;

- (void)addRoadsignToView:(UIView *)roadsignBackgroundView;
- (void)initRoadsignFromView:(UIImageView *)roadsignBackgroundView;
- (AWBRoadsignBackground *)roadsignBackground;

@end
