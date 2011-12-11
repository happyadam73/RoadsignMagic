//
//  AWBRoadsign.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/12/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsign.h"
#import "AWBTransformableZFontLabel.h"
#import "AWBTransformableSymbolImageView.h"
#import "AWBSettingsGroup.h"

@implementation AWBRoadsign

@synthesize exportSize; 
@synthesize roadsignBackgroundId, roadsignViews;
@synthesize totalSymbols, totalLabels, totalImageMemoryBytes;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.roadsignViews = [aDecoder decodeObjectForKey:kAWBInfoKeyRoadsignViews];
    self.roadsignBackgroundId = [aDecoder decodeIntegerForKey:kAWBInfoKeyRoadsignBackgroundId];
    self.exportSize = [aDecoder decodeFloatForKey:kAWBInfoKeyExportSizeValue];
    
    return  self;   
}

- (AWBRoadsignBackground *)roadsignBackground
{
    return [AWBRoadsignBackground signBackgroundWithIdentifier:self.roadsignBackgroundId];
}

- (void)addRoadsignToView:(UIView *)roadsignBackgroundView
{
    if (roadsignBackgroundView) {      
        
        totalSymbols = 0;
        totalLabels = 0;
        
        if (self.roadsignViews) {
            for(UIView <AWBTransformableView> *view in self.roadsignViews) {
                [roadsignBackgroundView addSubview:view];
                [view initialiseForSelection];
                if ([view isKindOfClass:[AWBTransformableZFontLabel class]]) {
                    totalLabels += 1;
                }
                if ([view isKindOfClass:[AWBTransformableSymbolImageView class]]) {
                    totalSymbols += 1;
                }     
            }  
            self.roadsignViews = nil;
        }
    }
}

- (void)initRoadsignFromView:(UIImageView *)roadsignBackgroundView
{
    if (roadsignBackgroundView) {   
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.roadsignViews = tempArray;
        [tempArray release];
        totalSymbols = 0;
        totalLabels = 0;
        totalImageMemoryBytes = 0;
        
        if (roadsignBackgroundView.image) {
            totalImageMemoryBytes += (roadsignBackgroundView.image.size.width * roadsignBackgroundView.image.size.height * 4);
        }
        
        for(UIView <AWBTransformableView> *view in [roadsignBackgroundView subviews]) {
            //iterator will still go through every view including non transformable, so ensure conformance to the transformable protocol
            if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
                if (view) {
                    [self.roadsignViews addObject:view];
                }
                if ([view isKindOfClass:[AWBTransformableZFontLabel class]]) {
                    totalLabels += 1;
                }
                if ([view isKindOfClass:[AWBTransformableSymbolImageView class]]) {
                    totalSymbols += 1;
                    AWBTransformableSymbolImageView *transformableImageView = (AWBTransformableSymbolImageView *)view;
                    totalImageMemoryBytes += (transformableImageView.imageView.image.size.width * transformableImageView.imageView.image.size.height * 4);
                }                
            }            
        }    
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{   
    [aCoder encodeObject:self.roadsignViews forKey:kAWBInfoKeyRoadsignViews];
    [aCoder encodeInteger:self.roadsignBackgroundId forKey:kAWBInfoKeyRoadsignBackgroundId];
    [aCoder encodeFloat:self.exportSize forKey:kAWBInfoKeyExportSizeValue];    
}

- (void)dealloc
{
    [roadsignViews release];
    [super dealloc];
}

@end
