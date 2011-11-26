//
//  AWBRoadsignMagicViewController+Toolbar.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController.h"

@interface AWBRoadsignMagicMainViewController (Toolbar)

- (NSArray *)normalToolbarButtons;
- (void)resetToNormalToolbar;
- (void)setToolbarForEditMode;
- (NSArray *)editModeButtons;
- (void)insertBarButtonItem:(UIBarButtonItem *)button atIndex:(NSUInteger)index; 
- (void)removeBarButtonItem:(UIBarButtonItem *)button;
- (UISegmentedControl *)tintedSegmentedControlButtonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action;
- (void)updateTintedSegmentedControlButton:(UIBarButtonItem *)button withTitle:(NSString *)title;

@end
