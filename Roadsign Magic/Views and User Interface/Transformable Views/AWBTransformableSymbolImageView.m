//
//  AWBTransformableImageView.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBTransformableSymbolImageView.h"
#import "FileHelpers.h"
#import "UIImage+Scale.h"
#import "UIView+Animation.h"
#import "UIView+SelectionMarquee.h"
#import "CAShapeLayer+Animation.h"
#import "UIImage+NonCached.h"
#import "UIImage+Scale.h"

#define BORDER_HEIGHT_RATIO 24.0
#define SHADOW_OFFSET_HEIGHT_RATIO 8.0
#define QUANTISED_ROTATION (M_PI_4/2.0)
#define MAX_SIGN_SYMBOL_PIXELS 250000

@implementation AWBTransformableSymbolImageView

@synthesize rotationAngleInRadians, currentScale, pendingRotationAngleInRadians, horizontalFlip;
@synthesize roundedBorder, viewBorderColor, viewShadowColor, addShadow, addBorder;
@synthesize imageView, selectionMarquee1, selectionMarquee2;
@synthesize roadsignSymbol;

- (void)initialiseLayerRotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip 
{      
    rotationAndScaleCurrentlyQuantised = NO;
    rotationAngleInRadians = rotation;
    pendingRotationAngleInRadians = 0.0;
    currentScale = scale;
    horizontalFlip = flip;    
    
    [self setUserInteractionEnabled:YES];
    
    CGFloat minLength = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat maxLength = MAX(self.frame.size.width, self.frame.size.height);
    minScale = MAX((48.0/maxLength),(24.0/minLength));    
    maxScale = 2048.0/maxLength;
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
    self.viewBorderColor = [UIColor blackColor];
    self.viewShadowColor = [UIColor blackColor];
    self.roundedBorder = YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSUInteger symbolId = [aDecoder decodeIntegerForKey:@"signSymbolId"];
    AWBRoadsignSymbol *symbol = [AWBRoadsignSymbol signSymbolWithIdentifier:symbolId];    
    
    if (!symbol) {
        return nil;
    } else {
        CGFloat imageOffsetX = [aDecoder decodeFloatForKey:@"imageOffsetX"];
        CGFloat imageOffsetY = [aDecoder decodeFloatForKey:@"imageOffsetY"];
        CGFloat imageRotation = [aDecoder decodeFloatForKey:@"imageRotation"];
        CGFloat imageScale = [aDecoder decodeFloatForKey:@"imageScale"];
        BOOL imageHFlip = [aDecoder decodeBoolForKey:@"imageHFlip"];
        CGPoint offset = CGPointMake(imageOffsetX, imageOffsetY);        
        self = [self initWithSymbol:symbol rotation:imageRotation scale:imageScale horizontalFlip:imageHFlip];
        [self setCenter:offset];
        
        return self;
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self applyPendingRotationToCapturedView];
    
    [aCoder encodeFloat:self.center.x forKey:@"imageOffsetX"];
    [aCoder encodeFloat:self.center.y forKey:@"imageOffsetY"];
    [aCoder encodeFloat:self.quantisedRotation forKey:@"imageRotation"];
    [aCoder encodeFloat:self.quantisedScale forKey:@"imageScale"];
    [aCoder encodeBool:self.horizontalFlip forKey:@"imageHFlip"];
    [aCoder encodeInteger:self.roadsignSymbol.signSymbolId forKey:@"signSymbolId"];
}

- (id)initWithSymbol:(AWBRoadsignSymbol *)symbol
{   
    if (!symbol) {
        return nil;
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage *image = [UIImage imageFromFile:symbol.fullsizeImageFilename];
    CGFloat scale = [image scaleRequiredForMaxResolution:MAX_SIGN_SYMBOL_PIXELS];
    NSLog(@"Scaling for Symbol: %f", scale);
    UIImage *scaledImage = [image imageScaledToMaxResolution:MAX_SIGN_SYMBOL_PIXELS withTransparentBorderThickness:0.0];  
    self = [self initWithImage:scaledImage rotation:0.0 scale:scale horizontalFlip:NO];
    self.roadsignSymbol = symbol;
    [pool drain];
    
    return self;
}

- (id)initWithSymbol:(AWBRoadsignSymbol *)symbol rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip
{   
    if (!symbol) {
        return nil;
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage *image = [UIImage imageFromFile:symbol.fullsizeImageFilename];
    self = [self initWithImage:image rotation:rotation scale:scale horizontalFlip:flip];
    self.roadsignSymbol = symbol;
    [pool drain];
    
    return self;
}

- (id)initWithImage:(UIImage *)image rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip
{
    if (!image) {
        return nil;
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CGFloat minImageLength = MIN(image.size.width, image.size.height);
    CGFloat tempBorderThickness = floorf(minImageLength/BORDER_HEIGHT_RATIO);
    
    self = [super initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    if (self) {
        initialHeight = image.size.height;
        [self setBackgroundColor:[UIColor clearColor]];
        UIImageView *subView = [[UIImageView alloc] initWithImage:image];
        subView.layer.masksToBounds = YES;
        self.imageView = subView;
        [subView release];
        [self addSubview:self.imageView];
        borderThickness = tempBorderThickness;
        shadowOffset = floorf(minImageLength/SHADOW_OFFSET_HEIGHT_RATIO);
        [self initialiseLayerRotation:rotation scale:scale horizontalFlip:flip];
        [self rotateAndScale];
    }
    [pool drain];
    
    return self;
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

- (void)addViewShadow
{
    self.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.layer.shadowRadius = (shadowOffset/3.0);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowColor = [self.viewShadowColor CGColor];
}

- (void)removeViewShadow
{
    self.layer.shadowOffset = CGSizeMake(0.0, -3.0);
    self.layer.shadowRadius = 3.0;    
    self.layer.shadowOpacity = 0.0;    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
}

- (void)addViewBorder
{
    self.imageView.layer.borderWidth = borderThickness;
    self.imageView.layer.cornerRadius = (self.roundedBorder ? (2.0 * borderThickness) : 0.0); 
    self.imageView.layer.borderColor = [self.viewBorderColor CGColor];
}

- (void)removeViewBorder
{
    self.imageView.layer.borderWidth = 0.0;
    self.imageView.layer.cornerRadius = 0.0;
    self.imageView.layer.borderColor = [[UIColor blackColor] CGColor];
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

- (void)dealloc
{
    [roadsignSymbol release];
    [selectionMarquee1 release];
    [selectionMarquee2 release];
    [imageView release];
    [viewBorderColor release];
    [viewShadowColor release];
    [super dealloc];
}

@end
