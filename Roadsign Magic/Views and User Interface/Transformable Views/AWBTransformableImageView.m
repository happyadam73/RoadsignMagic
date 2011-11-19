//
//  AWBTransformableImageView.m
//  CollageMaker
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBTransformableImageView.h"
#import "FileHelpers.h"
#import "UIImage+Scale.h"
#import "UIView+Animation.h"

#define BORDER_HEIGHT_RATIO 24.0
#define SHADOW_OFFSET_HEIGHT_RATIO 8.0
#define QUANTISED_ROTATION (M_PI_4/2.0)

@implementation AWBTransformableImageView

@synthesize rotationAngleInRadians, currentScale, pendingRotationAngleInRadians, horizontalFlip;
@synthesize roundedBorder, viewBorderColor, viewShadowColor, addShadow, addBorder;
@synthesize imageKey, imageView;

- (void)initialiseLayerRotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip imageKey:(NSString *)key imageDocsSubDir:(NSString *)subDir 
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
    maxScale = 2000.0/maxLength;
    
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
    
    if (!key) {
        [self initialiseImageKeyWithDocsSubdirPath:subDir]; 
    } else {
        [self setImageKey:key];
    }
    
    self.viewBorderColor = [UIColor blackColor];
    self.viewShadowColor = [UIColor blackColor];
    self.roundedBorder = YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSString *key = [aDecoder decodeObjectForKey:@"imageKey"];
    UIImage *image = AWBLoadImageWithKey(key);
    
    if (!image) {
        return nil;
    } else {
        CGFloat imageOffsetX = [aDecoder decodeFloatForKey:@"imageOffsetX"];
        CGFloat imageOffsetY = [aDecoder decodeFloatForKey:@"imageOffsetY"];
        CGFloat imageRotation = [aDecoder decodeFloatForKey:@"imageRotation"];
        CGFloat imageScale = [aDecoder decodeFloatForKey:@"imageScale"];
        BOOL imageHFlip = [aDecoder decodeBoolForKey:@"imageHFlip"];
        
        CGPoint offset = CGPointMake(imageOffsetX, imageOffsetY);        
        self = [self initWithImage:image rotation:imageRotation scale:imageScale horizontalFlip:imageHFlip imageKey:key imageDocsSubDir:nil];
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
    [aCoder encodeObject:self.imageKey forKey:@"imageKey"];
}


- (id)initWithImage:(UIImage *)image
{
    return nil;
}

- (id)initWithImage:(UIImage *)image rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip imageKey:(NSString *)key imageDocsSubDir:(NSString *)subDir
{
    if (!image || (!key && !subDir)) {
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
        [self initialiseLayerRotation:rotation scale:scale horizontalFlip:flip imageKey:key imageDocsSubDir:subDir];
        AWBSaveImageWithKey(image, imageKey);
        [self rotateAndScale];
    }
    [pool drain];
    
    return self;
}

- (id)initRandomWithImage:(UIImage *)image imageDocsSubDir:(NSString *)subDir
{
    //first calculate random scale range based on device screen size (in points) - go for 10-20% range
    //longest width should be height, but check just in case
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;    
    CGFloat screenLength = (screenSize.height > screenSize.width ? screenSize.height : screenSize.width);
    
    return [self initWithImage:image rotation:AWBRandomRotationFromMinMaxRadians(-M_PI_4, M_PI_4) 
                         scale:AWBCGSizeRandomScaleFromMinMaxLength(image.size, 25+(0.2*screenLength), 25+(0.2*screenLength))
                horizontalFlip:NO imageKey:nil imageDocsSubDir:subDir];
}

- (id)initRandomWithImage:(UIImage *)image imageDocsSubDir:(NSString *)subDir minLengthPercentage:(CGFloat)minPerc maxLengthPercentage:(CGFloat)maxPerc minAngle:(CGFloat)minAngle maxAngle:(CGFloat)maxAngle
{
    //first calculate random scale range based on device screen size (in points) - go for 10-20% range
    //longest width should be height, but check just in case
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;    
    CGFloat screenLength = (screenSize.height > screenSize.width ? screenSize.height : screenSize.width);
    
    return [self initWithImage:image rotation:AWBRandomRotationFromMinMaxRadians(minAngle, maxAngle) 
                         scale:AWBCGSizeRandomScaleFromMinMaxLength(image.size, (minPerc * screenLength), (maxPerc * screenLength))
                horizontalFlip:NO imageKey:nil imageDocsSubDir:subDir];
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

- (void)initialiseImageKeyWithDocsSubdirPath:(NSString *)dirPath
{
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    NSString *fullImageKey = AWBGetImageKeyFromDocumentSubdirectory(dirPath, (NSString *)newUniqueIDString);
    [self setImageKey:fullImageKey];
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
}

- (void)removeImageFromFilesystem
{
    if (self.imageKey) {
        AWBRemoveImageWithKey(self.imageKey);
    }
}

- (void)dealloc
{
    [imageKey release];
    [imageView release];
    [viewBorderColor release];
    [viewShadowColor release];
    [super dealloc];
}

@end
