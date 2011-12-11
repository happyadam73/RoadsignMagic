//
//  AWBRoadsignMagicMainController+UI.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController.h"
#import "AWBRoadsignMagicSettingsTableViewController.h"
#import "AWBTransformableZFontLabel.h"

#define NORMAL_ALPHA 1.0
#define UNSELECTED_ALPHA 0.4
#define SELECTED_ALPHA 1.0

@interface AWBRoadsignMagicMainViewController (UI) <UIScrollViewDelegate, UIActionSheetDelegate>

- (void)dismissAllSlideUpPickerViews;
- (void)dismissSignBackgroundPickerView;
- (void)dismissSignSymbolPickerView;
- (void)dismissPopoverIfVisible:(UIPopoverController *)popover;
- (void)dismissToolbarAndPopover:(UIPopoverController *)popover;
- (void)dismissActionSheetIfVisible:(UIActionSheet *)actionSheet;
- (void)settingsButtonAction:(id)sender;
- (void)dismissAllActionSheetsAndPopovers;
- (void)setExportSizeFromSettingsInfo:(NSDictionary *)info;
- (void)setCollageDrawingAidsFromSettingsInfo:(NSDictionary *)info;
- (NSMutableDictionary *)settingsInfo;
- (void)applySettingsToLabel:(AWBTransformableZFontLabel *)label;
- (void)toggleFullscreen;
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end
