//
//  AWBRoadsignMagicViewController+Symbol.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicViewController+Symbol.h"
#import "AWBRoadsignMagicMainViewController+UI.h"
#import "AWBTransformableSymbolImageView.h"
#import "UIImage+NonCached.h"
#import "AWBTransformableSymbolImageView.h"
#import "AWBRoadsignMagicMainViewController+Toolbar.h"
#import "UIImage+Scale.h"

#define MAX_SIGN_SYMBOL_PIXELS 250000

@implementation AWBRoadsignMagicMainViewController (Symbol)

- (void)initialiseSignSymbolPickerView
{
    CGRect backgroundFrame = CGRectMake(0.0, self.view.bounds.size.height, self.view.bounds.size.width, 180);
    AWBSignSymbolPickerView *symbolPicker = [[AWBSignSymbolPickerView alloc] initWithFrame:backgroundFrame];
    symbolPicker.delegate = self;
    self.signSymbolPickerView = symbolPicker;
	[self.view addSubview:symbolPicker];
    [symbolPicker release];
    signSymbolPickerViewShowing = NO;
}

- (void)toggleSignSymbolPickerView:(id)sender 
{
    [self dismissSignBackgroundPickerView];
    UIButton *button = (UIButton *)sender;
    [self performSelector:@selector(highlightSignSymbolPickerButton:) withObject:button afterDelay:0];
    
    if (!signSymbolPickerView) {
        [self initialiseSignSymbolPickerView];
    }
    
    CGRect frame = signSymbolPickerView.frame;
    if (!signSymbolPickerViewShowing) {
        frame.origin.y = (self.view.bounds.size.height - self.navigationController.toolbar.bounds.size.height - frame.size.height);            
    } else {
        frame.origin.y = (self.view.bounds.size.height);                        
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [signSymbolPickerView setFrame:frame];
    [UIView commitAnimations];
    
    signSymbolPickerViewShowing = !signSymbolPickerViewShowing;
}

- (void)highlightSignSymbolPickerButton:(UIButton*)button 
{
    [button setSelected:signSymbolPickerViewShowing];
}

- (void)addSignSymbolImageViewFromFile:(NSString *)filename
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    UIImage *image = [UIImage imageFromFile:filename];
    CGFloat scale = [image scaleRequiredForMaxResolution:MAX_SIGN_SYMBOL_PIXELS];
    NSLog(@"Scaling for Symbol: %f", scale);
    UIImage *scaledImage = [image imageScaledToMaxResolution:MAX_SIGN_SYMBOL_PIXELS withTransparentBorderThickness:0.0];
    //UIImage *image = [UIImage imageFromFile:filename];
    AWBTransformableSymbolImageView *imageView = [[AWBTransformableSymbolImageView alloc] initWithImage:scaledImage rotation:0.0 scale:scale horizontalFlip:NO];
    CGPoint centerPoint = [self.signBackgroundView convertPoint:self.signBackgroundView.center fromView:self.signBackgroundView.superview];
    imageView.center = [self deleteButtonApproxPosition];
    imageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    imageView.alpha = 0.0;
    [self.signBackgroundView addSubview:imageView];
    [imageView initialiseForSelection];   
    [UIView animateWithDuration:0.5 
                          delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations: ^ {
                         [imageView setAlpha:1.0]; 
                         imageView.transform = CGAffineTransformMakeScale(scale, scale);
                         imageView.center = centerPoint;
                     } 
                     completion: ^ (BOOL finished) {[imageView release];}];  
    
    [pool drain];
}

- (void)awbSignSymbolPickerView:(AWBSignSymbolPickerView *)symbolPicker didSelectSignSymbol:(AWBRoadsignSymbol *)signSymbol 
{
    [self dismissSignSymbolPickerView];
    self.selectedSignSymbol = signSymbol;
    NSString *filename = signSymbol.fullsizeImageFilename;        
    [self addSignSymbolImageViewFromFile:filename];
}

@end
