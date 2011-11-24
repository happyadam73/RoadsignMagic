//
//  NSString+Helpers.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 22/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "NSString+Helpers.h"

@implementation NSString (Helpers)

- (NSString *)stringByPaddingTheLeftToLength:(NSUInteger) newLength withString:(NSString *) padString startingAtIndex:(NSUInteger) padIndex
{
    if ([self length] <= newLength)
        return [[@"" stringByPaddingToLength:newLength - [self length] withString:padString startingAtIndex:padIndex] stringByAppendingString:self];
    else
        return [[self copy] autorelease];
}

@end
