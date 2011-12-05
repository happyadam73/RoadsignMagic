//
//  NSString+Helpers.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 22/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helpers)

- (NSString *)stringByPaddingTheLeftToLength:(NSUInteger) newLength withString:(NSString *) padString startingAtIndex:(NSUInteger) padIndex;

@end
