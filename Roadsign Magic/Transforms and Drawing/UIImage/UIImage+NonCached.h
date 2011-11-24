//
//  UIImage+NonCached.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 09/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (NonCached)

+ (UIImage *)imageFromFile:(NSString*)aFileName;

@end
