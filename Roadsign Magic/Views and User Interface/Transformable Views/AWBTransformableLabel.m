//
//  AWBTransformableLabel.m
//  CollageMaker
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBTransformableLabel.h"
#import "AWBTransforms.h"
#import "UIView+Animation.h"

#define BORDER_HEIGHT_RATIO 24.0
#define SHADOW_OFFSET_HEIGHT_RATIO 8.0
#define QUANTISED_ROTATION (M_PI_4/2.0)

@implementation AWBTransformableLabel

@synthesize rotationAngleInRadians, currentScale, pendingRotationAngleInRadians, horizontalFlip;
@synthesize roundedBorder, viewBorderColor, viewShadowColor, addShadow, addBorder;
@synthesize labelView;

- (void)initialiseLayerRotation:(CGFloat)rotation scale:(CGFloat)scale  
{
    CATiledLayer *layerForView = (CATiledLayer *)self.layer;
    layerForView.levelsOfDetailBias = 4;
    //layerForView.levelsOfDetail = 4;
    
    rotationAndScaleCurrentlyQuantised = NO;
    rotationAngleInRadians = rotation;
    pendingRotationAngleInRadians = 0.0;
    currentScale = scale;
    horizontalFlip = NO;  
    
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;    
    CGFloat minLength = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat maxLength = MAX(self.frame.size.width, self.frame.size.height);
    
    minScale = MAX((48.0/maxLength),((DEVICE_IS_IPAD ? 32.0 : 24.0)/minLength));    
    maxScale = (MAX(screenSize.width, screenSize.height))/maxLength;
    
    [self setUserInteractionEnabled:YES];
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    
    self.viewBorderColor = [UIColor blackColor];
    self.viewShadowColor = [UIColor blackColor];
    self.roundedBorder = YES;
    
    self.labelView.numberOfLines = 0;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSString *labelText = [aDecoder decodeObjectForKey:@"labelText"];
    NSString *labelFontName = [aDecoder decodeObjectForKey:@"labelFontName"];
    CGFloat labelFontSize = [aDecoder decodeFloatForKey:@"labelFontSize"];
    UIColor *labelColor = [aDecoder decodeObjectForKey:@"labelColor"];
    CGFloat labelOffsetX = [aDecoder decodeFloatForKey:@"labelOffsetX"];
    CGFloat labelOffsetY = [aDecoder decodeFloatForKey:@"labelOffsetY"];
    CGFloat labelRotation = [aDecoder decodeFloatForKey:@"labelRotation"];
    CGFloat labelScale = [aDecoder decodeFloatForKey:@"labelScale"];
    BOOL labelHFlip = [aDecoder decodeBoolForKey:@"labelHFlip"];
        
    UIFont *labelFont = [UIFont fontWithName:labelFontName size:labelFontSize];
    CGPoint offset = CGPointMake(labelOffsetX, labelOffsetY);
    
    self = [self initWithTextLines:[labelText componentsSeparatedByString:@"\r\n"] font:labelFont offset:offset rotation:labelRotation scale:labelScale horizontalFlip:labelHFlip color:labelColor];
    
    [self setCenter:offset];
    return  self;
}

- (id)initWithText:(NSString *)text offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale
{
    return [self initWithText:text font:[UIFont systemFontOfSize:28.0] offset:point rotation:rotation scale:scale horizontalFlip:NO color:[UIColor blackColor]];
}

- (id)initWithText:(NSString *)text font:(UIFont *)font offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color
{
    return [self initWithTextLines:[NSArray arrayWithObject:text] font:font offset:point rotation:rotation scale:scale horizontalFlip:flip color:color];
}

- (id)initWithTextLines:(NSArray *)lines font:(UIFont *)font offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color
{
    UIFont *textFont = font;
    if (!textFont) {
        textFont = [UIFont systemFontOfSize:28.0];
    }
    if (!color) {
        color = [UIColor darkGrayColor];
    }
        
    [self updateTextDimensionsWithLines:lines font:textFont];
    
    CGFloat frameWidth = (1.2 * maxWidth) + (0.25 * maxHeight);
    CGFloat frameHeight = (1.1 * totalHeight) + 10.0;
    
    self = [super initWithFrame:CGRectMake(point.x, point.y, frameWidth, frameHeight)];
    if (self) { 
        
        initialHeight = frameHeight;
        
        AWBLabel *label = [[AWBLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frameWidth, frameHeight)];
        label.layer.masksToBounds = YES;
        self.labelView = label;
        [label release];
        [self addSubview:self.labelView];
        
        CGFloat minLabelLength = MIN(frameWidth, frameHeight);
        borderThickness = (minLabelLength/BORDER_HEIGHT_RATIO);
        if (borderThickness < 2.0) {
            borderThickness = 2.0;
        }        
        [self initialiseLayerRotation:rotation scale:scale];
        [self setHorizontalFlip:flip];
        [self.labelView setFont:textFont];
        [self.labelView setTextColor:color];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.labelView setBackgroundColor:[UIColor clearColor]];
        [self.labelView setTextAlignment:UITextAlignmentCenter];
        [self.labelView setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [self.labelView setText:[lines componentsJoinedByString:@"\r\n"]];
        [self rotateAndScale];
    }
    return self;
}


- (void)updateTextDimensionsWithLines:(NSArray *)lines font:(UIFont *)font
{
    CGSize textLineSize;
    maxWidth = 0;
    maxHeight = 0;
    totalHeight = 0;
    
    for (NSString *textLine in lines) {
        textLineSize = [textLine sizeWithFont:font];  
        if (textLineSize.width > maxWidth) {
            maxWidth = textLineSize.width;
        }
        if (textLineSize.height > maxHeight) {
            maxHeight = textLineSize.height;
        }        
        totalHeight += textLineSize.height;
    }  
}

- (void)updateLabelTextLines:(NSArray *)lines withFont:(UIFont *)font
{    
    [self updateTextDimensionsWithLines:lines font:font];
    CGRect newBounds = CGRectMake(0.0, 0.0, (1.2 * maxWidth) + (0.25 * maxHeight), (1.1 * totalHeight) + 10.0);
    [self.labelView setFont:font];
    [self.labelView setText:[lines componentsJoinedByString:@"\r\n"]];
    [self setBounds:newBounds];
    [self.labelView setBounds:newBounds];
    self.labelView.center = CGPointMake((newBounds.size.width/2.0), (newBounds.size.height/2.0));
    
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;    
    CGFloat minLabelLength = MIN(newBounds.size.width, newBounds.size.height);
    CGFloat maxLabelLength = MAX(newBounds.size.width, newBounds.size.height);
    initialHeight = newBounds.size.height;    

    minScale = MAX((48.0/maxLabelLength),((DEVICE_IS_IPAD ? 32.0 : 24.0)/minLabelLength));    
    maxScale = (MAX(screenSize.width, screenSize.height))/maxLabelLength;

    [self setCurrentScale:currentScale];
    borderThickness = (minLabelLength/BORDER_HEIGHT_RATIO);
    if (borderThickness < 2.0) {
        borderThickness = 2.0;
    }
    
    if (addBorder) {
        [self addViewBorder];
    }
    
    [self rotateAndScale];
}

- (void)updateLabelTextWithFont:(UIFont *)font
{
    if (font) {
        [self updateLabelTextLines:[self.labelView.text componentsSeparatedByString:@"\r\n"] withFont:font];        
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self applyPendingRotationToCapturedView];
    [aCoder encodeObject:self.labelView.text forKey:@"labelText"];
    [aCoder encodeObject:self.labelView.font.fontName forKey:@"labelFontName"];
    [aCoder encodeFloat:self.labelView.font.pointSize forKey:@"labelFontSize"];
    [aCoder encodeObject:self.labelView.textColor forKey:@"labelColor"];
    [aCoder encodeFloat:self.center.x forKey:@"labelOffsetX"];
    [aCoder encodeFloat:self.center.y forKey:@"labelOffsetY"];
    [aCoder encodeFloat:self.quantisedRotation forKey:@"labelRotation"];
    [aCoder encodeFloat:self.quantisedScale forKey:@"labelScale"];
    [aCoder encodeBool:self.horizontalFlip forKey:@"labelHFlip"];
}

-(void)setCurrentScale:(CGFloat)scale
{
    if (scale < minScale) {
        currentScale = minScale;
    } else if (scale > maxScale) {
        currentScale = maxScale;
    } else {
        currentScale = scale;
    }
}

- (id)initWithText:(NSString *)text offset:(CGPoint) point;
{
    return [self initWithText:text offset:point rotation:0.0 scale:1.0];    
}

-(void)rotateAndScale
{    
    [self rotateAndScaleWithSnapToGrid:NO gridSize:0.0];
}

- (void)rotateAndScaleWithSnapToGrid:(BOOL)snapToGrid gridSize:(CGFloat)gridSize
{
    CGFloat rotation = rotationAngleInRadians+pendingRotationAngleInRadians;
    CGFloat scale = currentScale;
    
    if (snapToGrid && (gridSize > 0.0) && (initialHeight > 0.0)) {
        CGFloat quantisedHeight = AWBQuantizeFloat((scale * initialHeight), gridSize, YES);
        scale = quantisedHeight / initialHeight;
        rotation = AWBQuantizeFloat(rotation, QUANTISED_ROTATION, NO);
        rotationAndScaleCurrentlyQuantised = YES;
        currentQuantisedRotation = rotation;
        currentQuantisedScale = scale;
    } else {
        rotationAndScaleCurrentlyQuantised = NO;
    }
    
    self.transform = AWBCGAffineTransformMakeRotationAndScale(rotation, scale, horizontalFlip);
}

- (CGFloat)quantisedRotation
{
    if (rotationAndScaleCurrentlyQuantised) {
        return currentQuantisedRotation;
    } else {
        return rotationAngleInRadians+pendingRotationAngleInRadians;
    }
}

- (CGFloat)quantisedScale
{
    if (rotationAndScaleCurrentlyQuantised) {
        return currentQuantisedScale;
    } else {
        return currentScale;
    }
}

- (void)applyPendingRotationToCapturedView
{
    self.rotationAngleInRadians += self.pendingRotationAngleInRadians;
    self.pendingRotationAngleInRadians = 0.0;
}

- (void)setAddBorder:(BOOL)addBorderValue
{
    addBorder = addBorderValue;
    if (addBorder) {
        [self addViewBorder];
    } else {
        [self removeViewBorder];
    }
}

- (void)setAddShadow:(BOOL)addShadowValue
{
    addShadow = addShadowValue;
    if (addShadow) {
        [self addViewShadow];
    } else {
        [self removeViewShadow];
    }    
}

- (void)setRoundedBorder:(BOOL)roundedBorderValue
{
    roundedBorder = roundedBorderValue;
}

- (void)setTextBackgroundColor:(UIColor *)backgroundColor
{
    if (backgroundColor) {
        [self.labelView setBackgroundColor:backgroundColor];        
    }
}

- (void)addViewShadow
{
    self.layer.shadowOffset = CGSizeMake(10, 10);
    self.layer.shadowOpacity = 0.3; 
    self.layer.shadowColor = [self.viewShadowColor CGColor];
}

- (void)removeViewShadow
{
    self.layer.shadowOffset = CGSizeMake(0.0, -3.0);
    self.layer.shadowOpacity = 0.0;    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
}

- (void)addViewBorder
{
    self.labelView.layer.borderWidth = borderThickness;
    self.labelView.layer.cornerRadius = (self.roundedBorder ? (3.0 * borderThickness) : 0.0); 
    self.labelView.layer.borderColor = [self.viewBorderColor CGColor];
}

- (void)removeViewBorder
{
    self.labelView.layer.borderWidth = 0.0;
    self.labelView.layer.cornerRadius = 0.0;
    self.labelView.layer.borderColor = [[UIColor blackColor] CGColor];
}

+ (Class)layerClass {
    return [CATiledLayer class]; 
}

- (void)dealloc
{
    [labelView release];
    [viewBorderColor release];
    [viewShadowColor release];
    [super dealloc];
}

@end
