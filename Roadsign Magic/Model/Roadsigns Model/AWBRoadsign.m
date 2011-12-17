//
//  AWBRoadsign.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/12/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsign.h"
#import "AWBTransformableAnyFontLabel.h"
#import "AWBTransformableSymbolImageView.h"
#import "AWBSettingsGroup.h"

@implementation AWBRoadsign

@synthesize exportSize; 
@synthesize roadsignBackgroundId, roadsignViews;
@synthesize totalSymbols, totalLabels, totalImageMemoryBytes;
@synthesize objectsLocked, canvasAnchored, snapToGrid, snapRotation, snapToGridSize;
@synthesize exportFormatSelectedIndex, pngExportTransparentBackground, jpgExportQualityValue;
@synthesize roadsignBackgroundColor, roadsignBackgroundTexture, useBackgroundTexture;
@synthesize labelTextAlignment, labelTextColor, labelTextFont, labelTextLine1, labelTextLine2, labelTextLine3;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.roadsignViews = [aDecoder decodeObjectForKey:kAWBInfoKeyRoadsignViews];
    self.roadsignBackgroundId = [aDecoder decodeIntegerForKey:kAWBInfoKeyRoadsignBackgroundId];
    self.exportSize = [aDecoder decodeFloatForKey:kAWBInfoKeyExportSizeValue];
    self.objectsLocked = [aDecoder decodeBoolForKey:kAWBInfoKeyLockCanvas];
    self.canvasAnchored = [aDecoder decodeBoolForKey:kAWBInfoKeyScrollLocked];
    self.snapToGrid = [aDecoder decodeBoolForKey:kAWBInfoKeySnapToGrid];
    self.snapRotation = [aDecoder decodeBoolForKey:kAWBInfoKeySnapRotation];
    self.snapToGridSize = [aDecoder decodeFloatForKey:kAWBInfoKeySnapToGridSize];
    self.exportFormatSelectedIndex = [aDecoder decodeIntegerForKey:kAWBInfoKeyExportFormatSelectedIndex];
    self.pngExportTransparentBackground = [aDecoder decodeBoolForKey:kAWBInfoKeyPNGExportTransparentBackground];
    self.jpgExportQualityValue = [aDecoder decodeFloatForKey:kAWBInfoKeyJPGExportQualityValue];
    self.roadsignBackgroundColor = [aDecoder decodeObjectForKey:kAWBInfoKeyRoadsignBackgroundColor];
    self.roadsignBackgroundTexture = [aDecoder decodeObjectForKey:kAWBInfoKeyRoadsignBackgroundTexture];
    self.useBackgroundTexture = [aDecoder decodeBoolForKey:kAWBInfoKeyRoadsignUseBackgroundTexture];
    self.labelTextColor = [aDecoder decodeObjectForKey:kAWBInfoKeyTextColor];
    self.labelTextFont = [aDecoder decodeObjectForKey:kAWBInfoKeyTextFontName];
    self.labelTextLine1 = [aDecoder decodeObjectForKey:kAWBInfoKeyLabelTextLine1];
    self.labelTextLine2 = [aDecoder decodeObjectForKey:kAWBInfoKeyLabelTextLine2];
    self.labelTextLine3 = [aDecoder decodeObjectForKey:kAWBInfoKeyLabelTextLine3];
    self.labelTextAlignment = [aDecoder decodeIntegerForKey:kAWBInfoKeyTextAlignment];
    
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
                if ([view isKindOfClass:[AWBTransformableAnyFontLabel class]]) {
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
                if ([view isKindOfClass:[AWBTransformableAnyFontLabel class]]) {
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
    [aCoder encodeBool:self.objectsLocked forKey:kAWBInfoKeyLockCanvas]; 
    [aCoder encodeBool:self.canvasAnchored forKey:kAWBInfoKeyScrollLocked]; 
    [aCoder encodeBool:self.snapToGrid forKey:kAWBInfoKeySnapToGrid]; 
    [aCoder encodeBool:self.snapRotation forKey:kAWBInfoKeySnapRotation]; 
    [aCoder encodeFloat:self.snapToGridSize forKey:kAWBInfoKeySnapToGridSize]; 
    [aCoder encodeInteger:self.exportFormatSelectedIndex forKey:kAWBInfoKeyExportFormatSelectedIndex]; 
    [aCoder encodeBool:self.pngExportTransparentBackground forKey:kAWBInfoKeyPNGExportTransparentBackground]; 
    [aCoder encodeFloat:self.jpgExportQualityValue forKey:kAWBInfoKeyJPGExportQualityValue]; 
    [aCoder encodeObject:self.roadsignBackgroundColor forKey:kAWBInfoKeyRoadsignBackgroundColor]; 
    [aCoder encodeObject:self.roadsignBackgroundTexture forKey:kAWBInfoKeyRoadsignBackgroundTexture]; 
    [aCoder encodeBool:self.useBackgroundTexture forKey:kAWBInfoKeyRoadsignUseBackgroundTexture]; 
    [aCoder encodeObject:self.labelTextColor forKey:kAWBInfoKeyTextColor]; 
    [aCoder encodeObject:self.labelTextFont forKey:kAWBInfoKeyTextFontName]; 
    [aCoder encodeObject:self.labelTextLine1 forKey:kAWBInfoKeyLabelTextLine1]; 
    [aCoder encodeObject:self.labelTextLine2 forKey:kAWBInfoKeyLabelTextLine2]; 
    [aCoder encodeObject:self.labelTextLine3 forKey:kAWBInfoKeyLabelTextLine3]; 
    [aCoder encodeInteger:self.labelTextAlignment forKey:kAWBInfoKeyTextAlignment];     
}

- (void)dealloc
{
    [labelTextColor release];
    [labelTextFont release];
    [labelTextLine1 release];
    [labelTextLine2 release];
    [labelTextLine3 release];
    [roadsignViews release];
    [roadsignBackgroundColor release];
    [roadsignBackgroundTexture release];
    [super dealloc];
}

@end
