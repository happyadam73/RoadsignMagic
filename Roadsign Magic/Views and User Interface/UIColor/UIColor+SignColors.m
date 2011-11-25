//
//  UIColor+SignColors.m
//  TestRoadFont
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "UIColor+SignColors.h"

@implementation UIColor (SignColors)

+ (id)colorWithSignColorCode:(AWBSignColorCode)colorCode
{
    UIColor *color = nil;
    switch (colorCode) {
        case kAWBSignColorCodeBlackBackgroundColor:
            color = [UIColor blackColor];
            break;
        case kAWBSignColorCodeWhiteBackgroundColor:
            color = [UIColor whiteColor];
            break;
        case kAWBSignColorCodeDarkGreenSignBackgroundColor:
            color = [UIColor darkGreenSignBackgroundColor];
            break;
        case kAWBSignColorCodeRedSignBackgroundColor:
            color = [UIColor redSignBackgroundColor];
            break;
        case kAWBSignColorCodeBlueSignBackgroundColor:
            color = [UIColor blueSignBackgroundColor];
            break;
        case kAWBSignColorCodeYellowSignBackgroundColor:
            color = [UIColor yellowSignBackgroundColor];
            break;
        case kAWBSignColorCodeBrownSignBackgroundColor:
            color = [UIColor brownSignBackgroundColor];
            break;
        case kAWBSignColorCodeLightGreenSignBackgroundColor:
            color = [UIColor lightGreenSignBackgroundColor];
            break;
        case kAWBSignColorCodeOrangeSignBackgroundColor:
            color = [UIColor orangeSignBackgroundColor];
            break;
        default:
            color = [UIColor whiteColor];
            break;
    }
    return color;
}

+ (id)foregroundColorWithBackgroundSignColorCode:(AWBSignColorCode)colorCode
{
    UIColor *color = nil;
    switch (colorCode) {
        case kAWBSignColorCodeBlackBackgroundColor:
            color = [UIColor whiteColor];
            break;
        case kAWBSignColorCodeWhiteBackgroundColor:
            color = [UIColor blackColor];
            break;
        case kAWBSignColorCodeDarkGreenSignBackgroundColor:
            color = [UIColor whiteColor];
            break;
        case kAWBSignColorCodeRedSignBackgroundColor:
            color = [UIColor whiteColor];
            break;
        case kAWBSignColorCodeBlueSignBackgroundColor:
            color = [UIColor whiteColor];
            break;
        case kAWBSignColorCodeYellowSignBackgroundColor:
            color = [UIColor blackColor];
            break;
        case kAWBSignColorCodeBrownSignBackgroundColor:
            color = [UIColor whiteColor];
            break;
        case kAWBSignColorCodeLightGreenSignBackgroundColor:
            color = [UIColor whiteColor];
            break;
        case kAWBSignColorCodeOrangeSignBackgroundColor:
            color = [UIColor blackColor];
            break;
        default:
            color = [UIColor whiteColor];
            break;
    }
    return color;    
}

+ (id)darkGreenSignBackgroundColor
{
    return [UIColor colorWithRed:0.0/255.0 green:112.0/255.0 blue:60.0/255.0 alpha:1.0];
}

+ (id)redSignBackgroundColor
{
    return [UIColor colorWithRed:227.0/255.0 green:24.0/255.0 blue:55.0/255.0 alpha:1.0];    
}

+ (id)blueSignBackgroundColor
{
    return [UIColor colorWithRed:0.0/255.0 green:121/255.0 blue:193/255.0 alpha:1.0];    
}

+ (id)yellowSignBackgroundColor
{
    return [UIColor colorWithRed:255.0/255.0 green:210.0/255.0 blue:0.0/255.0 alpha:1.0];        
}

+ (id)brownSignBackgroundColor
{
    return [UIColor colorWithRed:121.0/255.0 green:68.0/255.0 blue:0.0/255.0 alpha:1.0];        
}

+ (id)lightGreenSignBackgroundColor
{
    return [UIColor colorWithRed:94.0/255.0 green:151.0/255.0 blue:50.0/255.0 alpha:1.0];        
}

+ (id)orangeSignBackgroundColor
{
    return [UIColor colorWithRed:250.0/255.0 green:166.0/255.0 blue:52.0/255.0 alpha:1.0];        
}

@end
