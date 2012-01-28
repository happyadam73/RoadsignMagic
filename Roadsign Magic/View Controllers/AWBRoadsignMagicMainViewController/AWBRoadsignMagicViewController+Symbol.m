//
//  AWBRoadsignMagicViewController+Symbol.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicViewController+Symbol.h"
#import "AWBRoadsignMagicMainViewController+UI.h"
#import "AWBTransformableSymbolImageView.h"
#import "AWBRoadsignMagicMainViewController+Toolbar.h"
#import "AWBRoadsignMagicStoreViewController.h"

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
    [self dismissAllActionSheetsAndPopovers];
    [self dismissSignBackgroundPickerView];
    UIButton *button = (UIButton *)sender;
    [self performSelector:@selector(highlightSignSymbolPickerButton:) withObject:button afterDelay:0];
    
    if (!signSymbolPickerView) {
        [self initialiseSignSymbolPickerView];
    } else {
        if ((!signPack1Purchased && IS_SIGNPACK1_PURCHASED) || (!signPack2Purchased && IS_SIGNPACK2_PURCHASED)) {
            [signSymbolPickerView reload];
            if (signBackgroundPickerView) {
                [signBackgroundPickerView reload];
            }
        }
    }
    signPack1Purchased = IS_SIGNPACK1_PURCHASED;
    signPack2Purchased = IS_SIGNPACK2_PURCHASED;
        
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

- (void)addSignSymbolImageViewFromSymbol:(AWBRoadsignSymbol *)symbol
{    
    AWBTransformableSymbolImageView *imageView = [[AWBTransformableSymbolImageView alloc] initWithSymbol:symbol];    
    CGPoint centerPoint = [self.signBackgroundView convertPoint:self.signBackgroundView.center fromView:self.signBackgroundView.superview];
    imageView.center = [self deleteButtonApproxPosition];
    imageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    imageView.alpha = 0.0;
    [self.signBackgroundView addSubview:imageView];
    self.totalSymbolSubviews += 1;
    [imageView initialiseForSelection];   
    [UIView animateWithDuration:0.5 
                          delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations: ^ {
                         [imageView setAlpha:1.0]; 
                         imageView.transform = CGAffineTransformMakeScale(imageView.currentScale, imageView.currentScale);
                         imageView.center = centerPoint;
                     } 
                     completion: ^ (BOOL finished) {[imageView release];
                                                    [self saveChanges:YES];}];  
}

- (void)awbSignSymbolPickerView:(AWBSignSymbolPickerView *)symbolPicker didSelectSignSymbol:(AWBRoadsignSymbol *)signSymbol 
{
    [self dismissSignSymbolPickerView];
    self.selectedSignSymbol = signSymbol;
    [self addSignSymbolImageViewFromSymbol:signSymbol];
}

- (void)awbSignSymbolPickerView:(AWBSignSymbolPickerView *)symbolPicker didSelectNonPurchasedSignSymbolCategory:(AWBRoadsignSymbolGroup *)signSymbolCategory 
{
    [self dismissSignSymbolPickerView];
    
    NSString *symbolPackDescription = nil;
    if (signSymbolCategory && signSymbolCategory.purchasePackDescription) {
        symbolPackDescription = signSymbolCategory.purchasePackDescription;
    } else {
        symbolPackDescription = @"Signs & Symbols Pack";
    }
    
    NSString *title = [NSString stringWithFormat:@"\"%@\" not installed", symbolPackDescription];
    NSString *message = [NSString stringWithFormat:@"This symbol requires the \"%@\" in-app purchase available through the In-App Store.  If you have purchased it already, you can also restore your purchase in the In-App Store.", symbolPackDescription]; 
    
    //message - then push onto the store
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:title 
                              message:message 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [alertView release];
    
    AWBRoadsignMagicStoreViewController *controller = [[AWBRoadsignMagicStoreViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];      
}

@end
