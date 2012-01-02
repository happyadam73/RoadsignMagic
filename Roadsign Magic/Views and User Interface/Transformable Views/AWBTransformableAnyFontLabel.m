//
//  AWBTransformableAnyFontLabel.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 16/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBTransformableAnyFontLabel.h"
#import "AWBTransforms.h"
#import "UIView+Animation.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"
#import "UIView+SelectionMarquee.h"
#import "CAShapeLayer+Animation.h"
#import "AWBRoadsignFont.h"

#define BORDER_HEIGHT_RATIO 24.0
#define SHADOW_OFFSET_HEIGHT_RATIO 8.0
#define QUANTISED_ROTATION (M_PI_4/2.0)
#define MAX_SCALE_PIXELS 1536
#define DEFAULT_FONT_POINT_SIZE 160.0

@implementation AWBTransformableAnyFontLabel

@synthesize rotationAngleInRadians, currentScale, pendingRotationAngleInRadians, horizontalFlip;
@synthesize roundedBorder, viewBorderColor, viewShadowColor, addShadow, addBorder;
@synthesize labelView, isZFontLabel, selectionMarquee1, selectionMarquee2;
@synthesize addTextBackground, textBackgroundColor;
@synthesize myFontUrl;

- (void)initialiseLayerRotation:(CGFloat)rotation scale:(CGFloat)scale  
{
    rotationCurrentlyQuantised = NO;
    scaleCurrentlyQuantised = NO;
    currentSnapToGridSize = 0.0;
    rotationAngleInRadians = rotation;
    pendingRotationAngleInRadians = 0.0;
    currentScale = scale;
    horizontalFlip = NO;  
    
    CGFloat minLength = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat maxLength = MAX(self.frame.size.width, self.frame.size.height);
    
    minScale = MAX((48.0/maxLength),((DEVICE_IS_IPAD ? 32.0 : 24.0)/minLength));    
    maxScale = MAX_SCALE_PIXELS/maxLength;
    
    [self setUserInteractionEnabled:YES];
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    
    self.viewBorderColor = [UIColor blackColor];
    self.viewShadowColor = [UIColor blackColor];
    self.roundedBorder = YES;
    self.textBackgroundColor = [UIColor clearColor];
    
    self.labelView.numberOfLines = 0;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSString *labelText = [aDecoder decodeObjectForKey:@"labelText"];
    NSString *labelFontName = [aDecoder decodeObjectForKey:@"labelFontName"];
    CGFloat labelFontSize = [aDecoder decodeFloatForKey:@"labelFontSize"];
    UIColor *labelColor = [aDecoder decodeObjectForKey:@"labelColor"];
    UITextAlignment alignment = [aDecoder decodeIntegerForKey:@"labelTextAlignment"];
    CGFloat labelOffsetX = [aDecoder decodeFloatForKey:@"labelOffsetX"];
    CGFloat labelOffsetY = [aDecoder decodeFloatForKey:@"labelOffsetY"];
    CGFloat labelRotation = [aDecoder decodeFloatForKey:@"labelRotation"];
    CGFloat labelScale = [aDecoder decodeFloatForKey:@"labelScale"];
    BOOL labelHFlip = [aDecoder decodeBoolForKey:@"labelHFlip"];
    BOOL labelAddBorder = [aDecoder decodeBoolForKey:@"labelAddBorder"];
    BOOL labelRoundedBorder = [aDecoder decodeBoolForKey:@"labelRoundedBorder"];
    BOOL labelAddTextBackground = [aDecoder decodeBoolForKey:@"labelAddTextBackground"];
    UIColor *labelTextBackgroundColor = [aDecoder decodeObjectForKey:@"labelTextBackgroundColor"];
    UIColor *labelTextBorderColor = [aDecoder decodeObjectForKey:@"labelTextBorderColor"];
    CGPoint offset = CGPointMake(labelOffsetX, labelOffsetY);
    
    self = [self initWithTextLines:[labelText componentsSeparatedByString:@"\r\n"] fontName:labelFontName fontSize:labelFontSize offset:offset rotation:labelRotation scale:labelScale horizontalFlip:labelHFlip color:labelColor alignment:alignment];
    
    [self setRoundedBorder:labelRoundedBorder];
    [self setViewBorderColor:labelTextBorderColor];
    [self setTextBackgroundColor:labelTextBackgroundColor];
    self.addBorder = labelAddBorder;
    self.addTextBackground = labelAddTextBackground;
    
    [self setCenter:offset];
    return  self;
}

- (id)initWithText:(NSString *)text offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale
{
    return [self initWithText:text fontName:@"Helvetica" fontSize:80.0 offset:point rotation:rotation scale:scale horizontalFlip:NO color:[UIColor blackColor] alignment:UITextAlignmentCenter];
}

- (id)initWithText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment
{
    return [self initWithTextLines:[NSArray arrayWithObject:text] fontName:fontName fontSize:fontSize offset:point rotation:rotation scale:scale horizontalFlip:flip color:color alignment:alignment];
}

- (id)initWithTextLines:(NSArray *)lines fontName:(NSString *)fontName fontSize:(CGFloat)fontSize offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment
{
    BOOL isMyFont = [AWBRoadsignFont isMyFont:fontName];
    BOOL isZFont = [AWBRoadsignFont isZFont:fontName];
    
    if (isZFont || isMyFont) {
        ZFont *zFont = nil;
        NSString *fontURL = nil;
        if (isMyFont) {
            fontURL = fontName;
            zFont = [[FontManager sharedManager] zFontWithURL:[NSURL URLWithString:fontName] pointSize:fontSize];
        } else {
            zFont = [[FontManager sharedManager] zFontWithName:fontName pointSize:fontSize];
        }
        return [self initWithTextLines:lines zFont:zFont offset:point rotation:rotation scale:scale horizontalFlip:flip color:color alignment:alignment myFontURL:fontURL];
    } else {
        UIFont *iOSFont = [UIFont fontWithName:fontName size:fontSize];
        return [self initWithTextLines:lines iOSFont:iOSFont offset:point rotation:rotation scale:scale horizontalFlip:flip color:color alignment:alignment];
    }
}

- (id)initWithTextLines:(NSArray *)lines zFont:(ZFont *)font offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment myFontURL:(NSString *)fontURL
{
    ZFont *textFont = font;
    if (!textFont) {
        textFont = [ZFont fontWithUIFont:[UIFont systemFontOfSize:DEFAULT_FONT_POINT_SIZE]];
    }
    if (!color) {
        color = [UIColor darkGrayColor];
    }
    
    [self updateTextDimensionsWithLines:lines zFont:textFont];
    
    CGFloat frameWidth = (1.2 * maxWidth) + (0.25 * maxHeight);
    CGFloat frameHeight = (1.1 * totalHeight) + 10.0;
    
    self = [super initWithFrame:CGRectMake(point.x, point.y, frameWidth, frameHeight)];
    if (self) { 
        self.myFontUrl = fontURL;
        isZFontLabel = YES;
        initialHeight = frameHeight;
        FontLabel *label = [[FontLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frameWidth, frameHeight) zFont:textFont];
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
        [self.labelView setTextColor:color];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.labelView setBackgroundColor:[UIColor clearColor]];
        [self.labelView setTextAlignment:alignment];
        [self.labelView setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [self.labelView setText:[lines componentsJoinedByString:@"\r\n"]];
        [self rotateAndScale];
    }
    return self;
}

- (id)initWithTextLines:(NSArray *)lines iOSFont:(UIFont *)font offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment
{
    UIFont *textFont = font;
    if (!textFont) {
        textFont = [UIFont systemFontOfSize:DEFAULT_FONT_POINT_SIZE];
    }
    if (!color) {
        color = [UIColor darkGrayColor];
    }
    
    [self updateTextDimensionsWithLines:lines iOSFont:textFont];
    
    CGFloat frameWidth = (1.2 * maxWidth) + (0.25 * maxHeight);
    CGFloat frameHeight = (1.1 * totalHeight) + 10.0;
    
    self = [super initWithFrame:CGRectMake(point.x, point.y, frameWidth, frameHeight)];
    if (self) { 
        self.myFontUrl = nil;
        isZFontLabel = NO;
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
        [self.labelView setTextAlignment:alignment];
        [self.labelView setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [self.labelView setText:[lines componentsJoinedByString:@"\r\n"]];
        [self rotateAndScale];
    }
    return self;
}

- (void)initialiseForSelection
{
    self.selectionMarquee1 = [UIView selectionMarqueeWithWhitePhase:YES];
    self.selectionMarquee2 = [UIView selectionMarqueeWithWhitePhase:NO];
    [[self.superview layer] addSublayer:self.selectionMarquee1];
    [[self.superview layer] addSublayer:self.selectionMarquee2];   
}

- (void)removeSelection
{
    [self.selectionMarquee1 removeFromSuperlayer];
    [self.selectionMarquee2 removeFromSuperlayer];
    self.selectionMarquee1 = nil;
    self.selectionMarquee2 = nil;
}

- (void)showSelection
{
    [self showSelectionMarquee:self.selectionMarquee1];
    [self showSelectionMarquee:self.selectionMarquee2];
}

- (void)showSelectionWithAnimation:(BOOL)animateSelection
{
    if (animateSelection) {
        [self startSelectionAnimation];
    } else {
        [self stopSelectionAnimation];
    }
    
    [self showSelection];    
}

- (void)hideSelection
{
    [self stopSelectionAnimation];
    self.selectionMarquee1.hidden = YES;
    self.selectionMarquee2.hidden = YES;   
}

- (void)startSelectionAnimation
{
    [self.selectionMarquee1 addDashAnimation];
    [self.selectionMarquee2 addDashAnimation];            
}

- (void)stopSelectionAnimation
{
    [self.selectionMarquee1 removeDashAnimation];
    [self.selectionMarquee2 removeDashAnimation];    
}

- (void)setSelectionOpacity:(CGFloat)opacity
{
    self.selectionMarquee1.opacity = opacity;
    self.selectionMarquee2.opacity = opacity;    
}

- (void)updateTextDimensionsWithLines:(NSArray *)lines zFont:(ZFont *)font
{
    CGSize textLineSize;
    maxWidth = 0;
    maxHeight = 0;
    totalHeight = 0;
    
    for (NSString *textLine in lines) {
        textLineSize = [textLine sizeWithZFont:font];  
        if (textLineSize.width > maxWidth) {
            maxWidth = textLineSize.width;
        }
        if (textLineSize.height > maxHeight) {
            maxHeight = textLineSize.height;
        }        
        totalHeight += textLineSize.height;
    }  
}

- (void)updateTextDimensionsWithLines:(NSArray *)lines iOSFont:(UIFont *)font
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

- (void)updateLabelTextLines:(NSArray *)lines withFontName:(NSString *)fontName fontSize:(CGFloat)fontSize 
{   
    BOOL isMyFont = [AWBRoadsignFont isMyFont:fontName];
    BOOL isZFont = [AWBRoadsignFont isZFont:fontName];
    
    if (isZFont || isMyFont) {
        ZFont *zFont = nil;
        NSString *fontURL = nil;
        if (isMyFont) {
            fontURL = fontName;
            zFont = [[FontManager sharedManager] zFontWithURL:[NSURL URLWithString:fontName] pointSize:fontSize];
        } else {
            zFont = [[FontManager sharedManager] zFontWithName:fontName pointSize:fontSize];
        }        
        [self updateLabelTextLines:lines withZFont:zFont myFontURL:fontURL];
    } else {
        UIFont *iOSFont = [UIFont fontWithName:fontName size:fontSize];
        [self updateLabelTextLines:lines withiOSFont:iOSFont];
    }    
}

- (void)updateLabelTextLines:(NSArray *)lines withZFont:(ZFont *)font myFontURL:(NSString *)fontURL
{    
    //OK, we're expecting a ZFont label - if it's not currently then we need to remove the iOS font label and create a new ZFont label
    if (!isZFontLabel) {
        //before removing the iOS label, we need to get the alignment and color values
        UITextAlignment alignment = self.labelView.textAlignment;
        CGColorRef colorRef = [self.labelView.textColor  CGColor];
        [self.labelView removeFromSuperview];
        FontLabel *label = [[FontLabel alloc] initWithFrame:CGRectZero];
        label.layer.masksToBounds = YES;
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor clearColor];
        label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        label.textAlignment = alignment;
        label.textColor = [UIColor colorWithCGColor:colorRef];
        self.labelView = label;
        [label release];
        [self addSubview:self.labelView];
        isZFontLabel = YES;
        self.myFontUrl = fontURL;
    }
    
    [self updateTextDimensionsWithLines:lines zFont:font];
    CGRect newBounds = CGRectMake(0.0, 0.0, (1.2 * maxWidth) + (0.25 * maxHeight), (1.1 * totalHeight) + 10.0);
    [(FontLabel *)self.labelView setZFont:font];
    [self.labelView setText:[lines componentsJoinedByString:@"\r\n"]];
    [self setBounds:newBounds];
    [self.labelView setBounds:newBounds];
    self.labelView.center = CGPointMake((newBounds.size.width/2.0), (newBounds.size.height/2.0));
    
    CGFloat minLabelLength = MIN(newBounds.size.width, newBounds.size.height);
    CGFloat maxLabelLength = MAX(newBounds.size.width, newBounds.size.height);
    initialHeight = newBounds.size.height;    
    
    minScale = MAX((48.0/maxLabelLength),((DEVICE_IS_IPAD ? 32.0 : 24.0)/minLabelLength));    
    maxScale = MAX_SCALE_PIXELS/maxLabelLength;
    
    [self setCurrentScale:currentScale];
    borderThickness = (minLabelLength/BORDER_HEIGHT_RATIO);
    if (borderThickness < 2.0) {
        borderThickness = 2.0;
    }
    
    if (addBorder) {
        [self addViewBorder];
    }
    
    [self rotateAndScaleWithSnapToGrid:scaleCurrentlyQuantised gridSize:currentSnapToGridSize snapRotation:rotationCurrentlyQuantised];
}

- (void)updateLabelTextLines:(NSArray *)lines withiOSFont:(UIFont *)font
{    
    //OK, we're expecting an iOS label - if it's not currently then we need to remove the ZFont label and create a new iOSFont label
    if (isZFontLabel) {
        //before removing the iOS label, we need to get the alignment and color values
        UITextAlignment alignment = self.labelView.textAlignment;
        CGColorRef colorRef = [self.labelView.textColor  CGColor];
        [self.labelView removeFromSuperview];
        AWBLabel *label = [[AWBLabel alloc] initWithFrame:CGRectZero];
        label.layer.masksToBounds = YES;
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor clearColor];
        label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        label.textAlignment = alignment;
        label.textColor = [UIColor colorWithCGColor:colorRef];
        self.labelView = label;
        [label release];
        [self addSubview:self.labelView];
        isZFontLabel = NO;
        self.myFontUrl = nil;
    }
    
    [self updateTextDimensionsWithLines:lines iOSFont:font];
    CGRect newBounds = CGRectMake(0.0, 0.0, (1.2 * maxWidth) + (0.25 * maxHeight), (1.1 * totalHeight) + 10.0);
    [self.labelView setFont:font];
    [self.labelView setText:[lines componentsJoinedByString:@"\r\n"]];
    [self setBounds:newBounds];
    [self.labelView setBounds:newBounds];
    self.labelView.center = CGPointMake((newBounds.size.width/2.0), (newBounds.size.height/2.0));
    
    CGFloat minLabelLength = MIN(newBounds.size.width, newBounds.size.height);
    CGFloat maxLabelLength = MAX(newBounds.size.width, newBounds.size.height);
    initialHeight = newBounds.size.height;    
    
    minScale = MAX((48.0/maxLabelLength),((DEVICE_IS_IPAD ? 32.0 : 24.0)/minLabelLength));    
    maxScale = MAX_SCALE_PIXELS/maxLabelLength;
    
    [self setCurrentScale:currentScale];
    borderThickness = (minLabelLength/BORDER_HEIGHT_RATIO);
    if (borderThickness < 2.0) {
        borderThickness = 2.0;
    }
    
    if (addBorder) {
        [self addViewBorder];
    }
    
    [self rotateAndScaleWithSnapToGrid:scaleCurrentlyQuantised gridSize:currentSnapToGridSize snapRotation:rotationCurrentlyQuantised];
}

- (void)updateLabelTextWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize 
{
    BOOL isMyFont = [AWBRoadsignFont isMyFont:fontName];
    BOOL isZFont = [AWBRoadsignFont isZFont:fontName];
    
    if (isZFont || isMyFont) {
        ZFont *zFont = nil;
        NSString *fontURL = nil;
        if (isMyFont) {
            fontURL = fontName;
            zFont = [[FontManager sharedManager] zFontWithURL:[NSURL URLWithString:fontName] pointSize:fontSize];
        } else {
            zFont = [[FontManager sharedManager] zFontWithName:fontName pointSize:fontSize];
        }
        [self updateLabelTextLines:[self.labelView.text componentsSeparatedByString:@"\r\n"] withZFont:zFont myFontURL:fontURL];
    } else {
        UIFont *iOSFont = [UIFont fontWithName:fontName size:fontSize];
        [self updateLabelTextLines:[self.labelView.text componentsSeparatedByString:@"\r\n"] withiOSFont:iOSFont];
    }    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self applyPendingRotationToCapturedView];
    [aCoder encodeObject:self.labelView.text forKey:@"labelText"];
    if (self.isZFontLabel) {
        if (self.myFontUrl) {
            [aCoder encodeObject:self.myFontUrl forKey:@"labelFontName"];
        } else {
            [aCoder encodeObject:((FontLabel *)self.labelView).zFont.familyName forKey:@"labelFontName"];
        }
        [aCoder encodeFloat:((FontLabel *)self.labelView).zFont.pointSize forKey:@"labelFontSize"];        
    } else {
        [aCoder encodeObject:self.labelView.font.fontName forKey:@"labelFontName"];
        [aCoder encodeFloat:self.labelView.font.pointSize forKey:@"labelFontSize"];        
    }
    [aCoder encodeObject:self.labelView.textColor forKey:@"labelColor"];
    [aCoder encodeInteger:self.labelView.textAlignment forKey:@"labelTextAlignment"];
    [aCoder encodeFloat:self.center.x forKey:@"labelOffsetX"];
    [aCoder encodeFloat:self.center.y forKey:@"labelOffsetY"];
    [aCoder encodeFloat:self.quantisedRotation forKey:@"labelRotation"];
    [aCoder encodeFloat:self.quantisedScale forKey:@"labelScale"];
    [aCoder encodeBool:self.horizontalFlip forKey:@"labelHFlip"];
    [aCoder encodeBool:self.addBorder forKey:@"labelAddBorder"];
    [aCoder encodeBool:self.roundedBorder forKey:@"labelRoundedBorder"];
    [aCoder encodeBool:self.addTextBackground forKey:@"labelAddTextBackground"];
    [aCoder encodeObject:self.textBackgroundColor forKey:@"labelTextBackgroundColor"];
    [aCoder encodeObject:self.viewBorderColor forKey:@"labelTextBorderColor"];
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
    [self rotateAndScaleWithSnapToGrid:NO gridSize:0.0 snapRotation:NO];
}

- (void)rotateAndScaleWithSnapToGrid:(BOOL)snapToGrid gridSize:(CGFloat)gridSize snapRotation:(BOOL)snapRotation
{
    CGFloat rotation = rotationAngleInRadians+pendingRotationAngleInRadians;
    CGFloat scale = currentScale;
    
    if (snapToGrid && (gridSize > 0.0) && (initialHeight > 0.0)) {
        CGFloat scaledHeight = (scale * initialHeight);
        if ((scaledHeight < 225.0) && (gridSize > 32.0)) {
            gridSize = 32.0;
        } else if ((scaledHeight < 450.0) && (gridSize > 64.0)) {
            gridSize = 64.0;
        }
        CGFloat quantisedHeight = AWBQuantizeFloat(scaledHeight, gridSize, YES);
        scale = quantisedHeight / initialHeight;
        scaleCurrentlyQuantised = YES;
        currentSnapToGridSize = gridSize;
        currentQuantisedScale = scale;
    } else {
        scaleCurrentlyQuantised = NO;
        currentSnapToGridSize = 0.0;
    }
    
    if (snapRotation) {
        rotation = AWBQuantizeFloat(rotation, QUANTISED_ROTATION, NO);
        rotationCurrentlyQuantised = YES;
        currentQuantisedRotation = rotation;
    } else {
        rotationCurrentlyQuantised = NO;
    }
    
    self.transform = AWBCGAffineTransformMakeRotationAndScale(rotation, scale, horizontalFlip);
}

- (CGFloat)quantisedRotation
{
    if (rotationCurrentlyQuantised) {
        return currentQuantisedRotation;
    } else {
        return rotationAngleInRadians+pendingRotationAngleInRadians;
    }
}

- (CGFloat)quantisedScale
{
    if (scaleCurrentlyQuantised) {
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

- (void)setAddTextBackground:(BOOL)addTextBackgroundValue
{
    addTextBackground = addTextBackgroundValue;
    if (addTextBackground) {
        [self addViewTextBackground];
    } else {
        [self removeViewTextBackground];
    }
}

- (void)addViewTextBackground
{
    if (self.textBackgroundColor) {
        self.labelView.backgroundColor = self.textBackgroundColor;
    }
}

- (void)removeViewTextBackground
{
    self.labelView.backgroundColor = [UIColor clearColor];
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

- (void)dealloc
{
    [selectionMarquee1 release];
    [selectionMarquee2 release];
    [labelView release];
    [viewBorderColor release];
    [viewShadowColor release];
    [textBackgroundColor release];
    [myFontUrl release];
    [super dealloc];
}

@end

