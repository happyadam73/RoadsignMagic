//
//  AWBRoadsignMagicViewController+Symbol.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicViewController+Symbol.h"
#import "AWBRoadsignMagicMainViewController+UI.h"

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

- (void)awbSignSymbolPickerView:(AWBSignSymbolPickerView *)symbolPicker didSelectSignSymbol:(AWBRoadsignSymbol *)signSymbol 
{
//    self.selectedSignBackground = signBackground;
//    self.labelTextColor = [UIColor foregroundColorWithBackgroundSignColorCode:signBackground.primaryColorCode];
//    NSString *filename = signBackground.fullsizeImageFilename;        
//    [self updateSignBackgroundWithImageFromFile:filename];
}

@end
