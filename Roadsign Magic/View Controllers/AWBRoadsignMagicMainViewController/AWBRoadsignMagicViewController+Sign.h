//
//  AWBRoadsignMagicViewController+Sign.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController.h"
#import "AWBSignBackgroundPickerView.h"

@interface AWBRoadsignMagicMainViewController (Sign) <AWBSignBackgroundPickerViewDelegate>

- (void)initialiseSignBackgroundPickerView;
- (void)highlightSignBackgroundPickerButton:(UIButton*)button;
- (void)toggleSignBackgroundPickerView:(id)sender;
- (void)updateSignBackgroundWithImageFromFile:(NSString *)name;

@end
