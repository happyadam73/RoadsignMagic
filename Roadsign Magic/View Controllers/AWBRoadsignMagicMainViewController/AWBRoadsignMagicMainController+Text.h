//
//  AWBRoadsignMagicMainController+Text.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController.h"
#import "AWBTransformableLabel.h"
#import "AWBRoadsignMagicSettingsTableViewController.h"

@interface AWBRoadsignMagicMainViewController (Text)

- (void)addTextView:(id)sender;
- (void)editSelectedTextViews:(id)sender;
- (NSMutableArray *)textLabelLines;

@end
