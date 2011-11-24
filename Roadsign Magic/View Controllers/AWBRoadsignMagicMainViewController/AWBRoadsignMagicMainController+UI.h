//
//  AWBRoadsignMagicMainController+UI.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController.h"
#import "AWBRoadsignMagicSettingsTableViewController.h"
#import "AWBTransformableLabel.h"

#define NORMAL_ALPHA 1.0
#define UNSELECTED_ALPHA 0.3
#define SELECTED_ALPHA 1.0

@interface AWBRoadsignMagicMainViewController (UI)

- (void)dismissPopoverIfVisible:(UIPopoverController *)popover;
- (void)dismissToolbarAndPopover:(UIPopoverController *)popover;
- (void)dismissActionSheetIfVisible:(UIActionSheet *)actionSheet;
- (void)settingsButtonAction:(id)sender;
- (void)dismissAllActionSheetsAndPopovers;
- (void)setExportQualityFromSettingsInfo:(NSDictionary *)info;
- (void)setCollageDrawingAidsFromSettingsInfo:(NSDictionary *)info;
- (NSMutableDictionary *)settingsInfo;
- (void)applySettingsToLabel:(AWBTransformableLabel *)label;
- (void)toggleFullscreen;

@end
