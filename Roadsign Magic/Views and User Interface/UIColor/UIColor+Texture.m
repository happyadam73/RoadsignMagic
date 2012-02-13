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

+ (id)skyTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"sky.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)brickWallTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"brick.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)metalHolesTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"metalholes.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)concrete2TextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"concrete2.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)asphalt2TextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"asphalt2.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)wood2TextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"wood2.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (NSArray *)allTextureColors
{
    return [NSArray arrayWithObjects:[UIColor concreteTextureColor], [UIColor asphaltTextureColor], [UIColor woodTextureColor], [UIColor metalTextureColor], [UIColor brightLightsTextureColor], [UIColor skyTextureColor], [UIColor brickWallTextureColor], [UIColor metalHolesTextureColor], [UIColor concrete2TextureColor], [UIColor asphalt2TextureColor], [UIColor wood2TextureColor], nil];
}

+ (NSArray *)allTextureColorDescriptions
{
    return [NSArray arrayWithObjects:@"Concrete", @"Asphalt", @"Wood", @"Metal", @"Bright Lights", @"Sky", @"Brick Wall", @"Metal Holes", @"Concrete 2", @"Asphalt 2", @"Wood 2", nil];
}

+ (NSArray *)allTextureColorImages
{
    return [NSArray arrayWithObjects:[UIImage imageFromFile:@"concrete100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"asphalt100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"wood100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"metal100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"brightlights100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"sky100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"brick100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"metalholes100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"concrete2100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"asphalt2100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"wood2100.jpg" withNoUpscaleForNonRetina:YES], nil];
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
    } else if ([colorDescription isEqualToString:@"Sky"]) {
        return [UIColor skyTextureColor];
    } else if ([colorDescription isEqualToString:@"Brick Wall"]) {
        return [UIColor brickWallTextureColor];
    } else if ([colorDescription isEqualToString:@"Metal Holes"]) {
        return [UIColor metalHolesTextureColor];
    } else if ([colorDescription isEqualToString:@"Concrete 2"]) {
        return [UIColor concrete2TextureColor];
    } else if ([colorDescription isEqualToString:@"Asphalt 2"]) {
        return [UIColor asphalt2TextureColor];
    } else if ([colorDescription isEqualToString:@"Wood 2"]) {
        return [UIColor wood2TextureColor];
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
    } else if ([colorDescription isEqualToString:@"Sky"]) {
        return [UIImage imageFromFile:@"sky.jpg"];
    } else if ([colorDescription isEqualToString:@"Brick Wall"]) {
        return [UIImage imageFromFile:@"brick.jpg"];
    } else if ([colorDescription isEqualToString:@"Metal Holes"]) {
        return [UIImage imageFromFile:@"metalholes.jpg"];
    } else if ([colorDescription isEqualToString:@"Concrete 2"]) {
        return [UIImage imageFromFile:@"concrete2.jpg"];
    } else if ([colorDescription isEqualToString:@"Asphalt 2"]) {
        return [UIImage imageFromFile:@"asphalt2.jpg"];
    } else if ([colorDescription isEqualToString:@"Wood 2"]) {
        return [UIImage imageFromFile:@"wood2.jpg"];
    } else {
        return [UIImage imageFromFile:@"concrete.jpg"];
    } 
}

@end


