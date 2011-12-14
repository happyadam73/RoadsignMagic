//
//  UIColor+Texture.m
//  Collage Maker
//
//  Created by Adam Buckley on 08/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "UIColor+Texture.h"
#import "UIImage+NonCached.h"

@implementation UIColor (Texture)

+ (id)concreteTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"concrete.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)asphaltTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"asphalt.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)woodTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"wood.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)metalTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"metal.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)brightLightsTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"brightlights.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (NSArray *)allTextureColors
{
    return [NSArray arrayWithObjects:[UIColor concreteTextureColor], [UIColor asphaltTextureColor], [UIColor woodTextureColor], [UIColor metalTextureColor], [UIColor brightLightsTextureColor], nil];
}

+ (NSArray *)allTextureColorDescriptions
{
    return [NSArray arrayWithObjects:@"Concrete", @"Asphalt", @"Wood", @"Metal", @"Bright Lights", nil];
}

+ (NSArray *)allTextureColorImages
{
    return [NSArray arrayWithObjects:[UIImage imageFromFile:@"concrete100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"asphalt100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"wood100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"metal100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"brightlights100.jpg" withNoUpscaleForNonRetina:YES], nil];
}

+ (id)textureColorWithDescription:(NSString *)colorDescription
{
    if ([colorDescription isEqualToString:@"Concrete"]) {
        return [UIColor concreteTextureColor];
    } else if ([colorDescription isEqualToString:@"Asphalt"]) {
        return [UIColor asphaltTextureColor];
    } else if ([colorDescription isEqualToString:@"Wood"]) {
        return [UIColor woodTextureColor];
    } else if ([colorDescription isEqualToString:@"Metal"]) {
        return [UIColor metalTextureColor];
    } else if ([colorDescription isEqualToString:@"Bright Lights"]) {
        return [UIColor brightLightsTextureColor];
    } else {
        return [UIColor concreteTextureColor];
    } 
}

+ (UIImage *)textureImageWithDescription:(NSString *)colorDescription
{
    if ([colorDescription isEqualToString:@"Concrete"]) {
        return [UIImage imageFromFile:@"concrete.jpg"];
    } else if ([colorDescription isEqualToString:@"Asphalt"]) {
        return [UIImage imageFromFile:@"asphalt.jpg"];
    } else if ([colorDescription isEqualToString:@"Wood"]) {
        return [UIImage imageFromFile:@"wood.jpg"];
    } else if ([colorDescription isEqualToString:@"Metal"]) {
        return [UIImage imageFromFile:@"metal.jpg"];
    } else if ([colorDescription isEqualToString:@"Bright Lights"]) {
        return [UIImage imageFromFile:@"brightlights.jpg"];
    } else {
        return [UIImage imageFromFile:@"concrete.jpg"];
    } 
}

@end

