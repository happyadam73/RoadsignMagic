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
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"concrete.jpg"]];
}

+ (id)asphaltTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"asphalt.jpg"]];
}

+ (id)woodTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"wood.jpg"]];
}

+ (NSArray *)allTextureColors
{
    return [NSArray arrayWithObjects:[UIColor concreteTextureColor], [UIColor asphaltTextureColor], [UIColor woodTextureColor], nil];
}

+ (NSArray *)allTextureColorDescriptions
{
    return [NSArray arrayWithObjects:@"Concrete", @"Asphalt", @"Wood", nil];
}

+ (NSArray *)allTextureColorImages
{
    return [NSArray arrayWithObjects:[UIImage imageFromFile:@"concrete100.jpg"], [UIImage imageFromFile:@"asphalt100.jpg"], [UIImage imageFromFile:@"wood100.jpg"], nil];
}

+ (id)textureColorWithDescription:(NSString *)colorDescription
{
    if ([colorDescription isEqualToString:@"Concrete"]) {
        return [UIColor concreteTextureColor];
    } else if ([colorDescription isEqualToString:@"Asphalt"]) {
        return [UIColor asphaltTextureColor];
    } else if ([colorDescription isEqualToString:@"Wood"]) {
        return [UIColor woodTextureColor];
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
    } else {
        return [UIImage imageFromFile:@"concrete.jpg"];
    } 
}

@end

