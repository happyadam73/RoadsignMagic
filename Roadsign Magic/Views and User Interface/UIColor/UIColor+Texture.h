//
//  UIColor+Texture.h
//  Collage Maker
//
//  Created by Adam Buckley on 08/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (Texture) 

+ (id)concreteTextureColor;
+ (id)asphaltTextureColor;
+ (id)woodTextureColor;
+ (id)metalTextureColor;
+ (id)brightLightsTextureColor;
+ (NSArray *)allTextureColors;
+ (NSArray *)allTextureColorDescriptions;
+ (NSArray *)allTextureColorImages;
+ (id)textureColorWithDescription:(NSString *)colorDescription;
+ (UIImage *)textureImageWithDescription:(NSString *)colorDescription;

@end
