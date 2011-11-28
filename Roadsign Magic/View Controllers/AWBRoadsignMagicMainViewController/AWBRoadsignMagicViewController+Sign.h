//
//  AWBRoadsignMagicViewController+Sign.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController.h"
#import "AWBSignBackgroundPickerView.h"

@interface AWBRoadsignMagicMainViewController (Sign) <AWBSignBackgroundPickerViewDelegate>

- (void)initialiseSlideupView;
- (void)updateSignBackgroundWithImageFromFile:(NSString *)name;

@end
