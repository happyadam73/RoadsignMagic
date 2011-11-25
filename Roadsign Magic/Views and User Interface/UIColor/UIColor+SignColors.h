//
//  UIColor+SignColors.h
//  TestRoadFont
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    kAWBSignColorCodeBlackBackgroundColor,
    kAWBSignColorCodeWhiteBackgroundColor,
    kAWBSignColorCodeDarkGreenSignBackgroundColor,
    kAWBSignColorCodeRedSignBackgroundColor,
    kAWBSignColorCodeBlueSignBackgroundColor,
    kAWBSignColorCodeYellowSignBackgroundColor,
    kAWBSignColorCodeBrownSignBackgroundColor,
    kAWBSignColorCodeLightGreenSignBackgroundColor,
    kAWBSignColorCodeOrangeSignBackgroundColor
} AWBSignColorCode;

@interface UIColor (SignColors) 

+ (id)colorWithSignColorCode:(AWBSignColorCode)colorCode;
+ (id)foregroundColorWithBackgroundSignColorCode:(AWBSignColorCode)colorCode;
+ (id)darkGreenSignBackgroundColor;
+ (id)redSignBackgroundColor;
+ (id)blueSignBackgroundColor;
+ (id)yellowSignBackgroundColor;
+ (id)brownSignBackgroundColor;
+ (id)lightGreenSignBackgroundColor;
+ (id)orangeSignBackgroundColor;

@end
