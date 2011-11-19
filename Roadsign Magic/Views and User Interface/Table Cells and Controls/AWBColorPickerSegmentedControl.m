//
//  AWBColorPickerSegmentedControl.m
//  Collage Maker
//
//  Created by Adam Buckley on 03/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBColorPickerSegmentedControl.h"
#import "UIColor+SignColors.h"

@implementation AWBColorPickerSegmentedControl

@synthesize selectedColor;

- (void)initialiseSegments
{
    pickerColors = [[NSArray arrayWithObjects:[UIColor blackColor], [UIColor darkGrayColor], [UIColor lightGrayColor], [UIColor whiteColor], [UIColor redSignBackgroundColor],[UIColor darkGreenSignBackgroundColor],[UIColor lightGreenSignBackgroundColor],[UIColor blueSignBackgroundColor],[UIColor yellowSignBackgroundColor],[UIColor orangeSignBackgroundColor],[UIColor brownSignBackgroundColor],nil] retain]; 

    [self removeAllSegments];
    for (NSUInteger segmentIndex = 0; segmentIndex < [[self pickerSegmentImages] count]; segmentIndex++) {
        [self insertSegmentWithImage:[[self pickerSegmentImages] objectAtIndex:segmentIndex]  atIndex:segmentIndex animated:NO];
    }
    CGRect newFrame = [self frame];
    [self setFrame:newFrame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialiseSegments];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {      
        [self initialiseSegments];
    }
    
    return self;
}

- (NSArray *)pickerSegmentImages
{
    return [NSArray arrayWithObjects:[UIImage imageNamed:@"blackbutton"], [UIImage imageNamed:@"darkgraybutton"], [UIImage imageNamed:@"lightgraybutton"], [UIImage imageNamed:@"whitebutton"], [UIImage imageNamed:@"signredbutton"], [UIImage imageNamed:@"signgreenbutton"], [UIImage imageNamed:@"signlightgreenbutton"], [UIImage imageNamed:@"signbluebutton"], [UIImage imageNamed:@"signyellowbutton"], [UIImage imageNamed:@"signorangebutton"], [UIImage imageNamed:@"signbrownbutton"], nil];
}


- (UIColor *)selectedColor
{
    return [pickerColors objectAtIndex:[self selectedSegmentIndex]];
}

- (void)setSelectedColor:(UIColor *)aSelectedColor
{
    if (aSelectedColor) {
        [self setSelectedSegmentIndex:[pickerColors indexOfObject:aSelectedColor]];
    } else {
        [self setSelectedSegmentIndex:0];        
    }
}

- (void)dealloc
{
    [pickerColors release];
    [super dealloc];
}

@end
