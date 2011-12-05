//
//  AWBRoadsignMagicViewController+Symbol.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController.h"
#import "AWBSignSymbolPickerView.h"
#import "AWBRoadsignSymbol.h"

@interface AWBRoadsignMagicMainViewController (Symbol) <AWBSignSymbolPickerViewDelegate>

- (void)initialiseSignSymbolPickerView;
- (void)highlightSignSymbolPickerButton:(UIButton*)button;
- (void)toggleSignSymbolPickerView:(id)sender;
//- (void)addSignSymbolImageViewFromFile:(NSString *)filename;
- (void)addSignSymbolImageViewFromSymbol:(AWBRoadsignSymbol *)symbol;
@end
