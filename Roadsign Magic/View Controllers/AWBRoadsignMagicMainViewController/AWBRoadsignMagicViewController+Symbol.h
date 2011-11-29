//
//  AWBRoadsignMagicViewController+Symbol.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController.h"
#import "AWBSignSymbolPickerView.h"

@interface AWBRoadsignMagicMainViewController (Symbol) <AWBSignSymbolPickerViewDelegate>

- (void)initialiseSignSymbolPickerView;
- (void)highlightSignSymbolPickerButton:(UIButton*)button;
- (void)toggleSignSymbolPickerView:(id)sender;
- (void)addSignSymbolImageViewFromFile:(NSString *)filename;

@end
