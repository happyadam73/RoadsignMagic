//
//  AWBRoadsignMagicMainController+UI.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicMainController+UI.h"
#import "AWBRoadsignMagicMainController+Text.h"

@implementation AWBRoadsignMagicMainViewController (UI)

- (void)dismissAllActionSheetsAndPopovers
{
    if (DEVICE_IS_IPAD) {
//        [self dismissPopoverIfVisible:self.imagePickerPopover];
//        [self dismissPopoverIfVisible:self.addressBookPopover];
//        [self dismissPopoverIfVisible:self.addSymbolPopover];
//        [self dismissPopoverIfVisible:self.luckyDipPopover];
//        [self dismissPopoverIfVisible:self.memoryWarningPopover];        
//        [self dismissActionSheetIfVisible:self.deleteConfirmationSheet];
//        [self dismissActionSheetIfVisible:self.choosePhotoSourceSheet];
//        [self dismissActionSheetIfVisible:self.chooseActionTypeSheet];
    }    
}

- (void)dismissActionSheetIfVisible:(UIActionSheet *)actionSheet
{
    if (actionSheet.visible) {
        [actionSheet dismissWithClickedButtonIndex:[actionSheet cancelButtonIndex] animated:YES];
    }
}

- (void)dismissPopoverIfVisible:(UIPopoverController *)popover
{
    if ([popover isPopoverVisible]) {
        [popover dismissPopoverAnimated:YES];
        [popover.delegate popoverControllerDidDismissPopover:popover];
    }        
}

- (void)dismissToolbarAndPopover:(UIPopoverController *)popover
{
    if (DEVICE_IS_IPHONE) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self dismissPopoverIfVisible:popover];        
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
//    self.imagePickerPopover = nil;
//    self.addressBookPopover = nil;
//    self.addSymbolPopover = nil;
//    self.luckyDipPopover = nil;
//    self.memoryWarningPopover = nil;
//    if (!self.isImporting && dismissAssetsLibrary) {
//        self.selectedAssetsGroup = nil;
//        self.assetsLibrary = nil;        
//    }
}

- (void)settingsButtonAction:(id)sender
{  
//        [self resetEditMode:sender];
//        [self dismissAllActionSheetsAndPopovers];
        
    AWBRoadsignMagicSettingsTableViewController *settingsController = [[AWBRoadsignMagicSettingsTableViewController alloc] initWithSettings:[AWBSettings mainSettingsWithInfo:[self settingsInfo]] settingsInfo:[self settingsInfo] rootController:nil]; 
    settingsController.delegate = self;
    settingsController.controllerType = AWBSettingsControllerTypeMainSettings;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;  
    [self presentModalViewController:navController animated:YES];
    [settingsController release];   
    [navController release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    if (actionSheet == self.choosePhotoSourceSheet) {
//        [self choosePhotoSourceActionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
//    } else if (actionSheet == self.deleteConfirmationSheet) {
//        [self deleteConfirmationActionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
//    } else if (actionSheet == self.chooseActionTypeSheet) {
//        [self chooseActionTypeActionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
//    }
}

- (void)setExportQualityFromSettingsInfo:(NSDictionary *)info
{
    [self setExportQuality:[[info objectForKey:kAWBInfoKeyExportQualityValue] floatValue]];
}

- (void)setCollageDrawingAidsFromSettingsInfo:(NSDictionary *)info
{
    self.lockCanvas = [[info objectForKey:kAWBInfoKeyLockCanvas] boolValue];
    self.scrollLocked = [[info objectForKey:kAWBInfoKeyScrollLocked] boolValue];
    self.snapToGrid = [[info objectForKey:kAWBInfoKeySnapToGrid] boolValue];
    self.snapToGridSize = [[info objectForKey:kAWBInfoKeySnapToGridSize] floatValue];
}

- (NSMutableDictionary *)settingsInfo
{
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithFloat:self.exportQuality], kAWBInfoKeyExportQualityValue, 
                                 [NSNumber numberWithBool:self.lockCanvas], kAWBInfoKeyLockCanvas, 
                                 [NSNumber numberWithBool:self.scrollLocked], kAWBInfoKeyScrollLocked, 
                                 [NSNumber numberWithBool:self.snapToGrid], kAWBInfoKeySnapToGrid, 
                                 [NSNumber numberWithFloat:self.snapToGridSize], kAWBInfoKeySnapToGridSize, 
                                 nil];
          
    if (self.labelTextColor) {
        [info setObject:self.labelTextColor forKey:kAWBInfoKeyTextColor];        
    }    
    if (self.labelTextFont) {
        [info setObject:self.labelTextFont forKey:kAWBInfoKeyTextFontName];        
    }     
    if (self.labelTextLine1) {
        [info setObject:self.labelTextLine1 forKey:kAWBInfoKeyLabelTextLine1];
    }
    if (self.labelTextLine2) {
        [info setObject:self.labelTextLine2 forKey:kAWBInfoKeyLabelTextLine2];
    }
    if (self.labelTextLine3) {
        [info setObject:self.labelTextLine3 forKey:kAWBInfoKeyLabelTextLine3];
    }
    
    return info;
}

- (void)awbRoadsignMagicSettingsTableViewController:(AWBRoadsignMagicSettingsTableViewController *)settingsController didFinishSettingsWithInfo:(NSDictionary *)info;
{
    switch (settingsController.controllerType) {
        case AWBSettingsControllerTypeMainSettings:
            [self setExportQualityFromSettingsInfo:info];
            [self setCollageDrawingAidsFromSettingsInfo:info];
//            [self saveChanges:NO];            
            break;
        case AWBSettingsControllerTypeAddTextSettings:
            self.labelTextLine1 = [info objectForKey:kAWBInfoKeyLabelTextLine1];
            self.labelTextLine2 = [info objectForKey:kAWBInfoKeyLabelTextLine2];
            self.labelTextLine3 = [info objectForKey:kAWBInfoKeyLabelTextLine3];
            self.labelTextColor = [info objectForKey:kAWBInfoKeyTextColor];
            self.labelTextFont = [info objectForKey:kAWBInfoKeyTextFontName];
            
            if (self.labelTextLine1 || self.labelTextLine2 || self.labelTextLine3) {
                NSMutableArray *lines = [self textLabelLines];
                if ([lines count] > 0) {
                    AWBTransformableLabel *label = [[AWBTransformableLabel alloc] initWithTextLines:lines font:self.roadsignFont offset:CGPointZero rotation:0.0 scale:1.0 horizontalFlip:NO color:self.labelTextColor];
                    
                    [label setCenter:self.signBackgroundView.center];                    
                    [self applySettingsToLabel:label];
                    [self.signBackgroundView addSubview:label];
                    totalLabelSubviews += 1;
                    [label release];                        
                }
            }
            
            //[self saveChanges:NO];
            break;
        case AWBSettingsControllerTypeEditTextSettings:
            self.labelTextColor = [info objectForKey:kAWBInfoKeyTextColor];
            self.labelTextFont = [info objectForKey:kAWBInfoKeyTextFontName];
            
            for(UIView <AWBTransformableView> *view in [[[self view] subviews] reverseObjectEnumerator]) {
                if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
                    if ((view.alpha == SELECTED_ALPHA) && [view isKindOfClass:[AWBTransformableLabel class]]) {
                        AWBTransformableLabel *label = (AWBTransformableLabel *)view;
                        
                        if (self.labelTextColor) {
                            [label.labelView setTextColor:self.labelTextColor];   
                        }
                        
                        if (totalSelectedLabelsInEditMode == 1) {
                            //single object edit - set text
                            self.labelTextLine1 = [info objectForKey:kAWBInfoKeyLabelTextLine1];
                            self.labelTextLine2 = [info objectForKey:kAWBInfoKeyLabelTextLine2];
                            self.labelTextLine3 = [info objectForKey:kAWBInfoKeyLabelTextLine3];
                            NSMutableArray *lines = [self textLabelLines];
                            if ([lines count] > 0) {
                                [label updateLabelTextLines:lines withFont:self.roadsignFont];
                            } else {
                                [label updateLabelTextWithFont:self.roadsignFont];                                    
                            }
                            // break because there's just one label
                            break;
                        } else {
                            // more than one label - update the font so frame is adjusted
                            [label updateLabelTextWithFont:self.roadsignFont];                                    
                        }
                    }
                }            
            } 
//            [self resetEditMode:settingsController];
//            [self saveChanges:NO];
            break;
        default:
            break;
    }
}

//- (void)awbRoadsignMagicSettingsTableViewControllerDidDissmiss:(AWBRoadsignMagicSettingsTableViewController *)settingsController
//{
//
//}

- (void)applySettingsToLabel:(AWBTransformableLabel *)label
{
//    [label setRoundedBorder:self.textRoundedBorders];
//    [label setViewBorderColor:self.textBorderColor];
//    [label setViewShadowColor:self.textShadowColor];
//    label.addBorder = self.addTextBorders;
//    label.addShadow = self.addTextShadows;
//    
//    if (self.addTextBackground) {
//        [label setTextBackgroundColor:self.textBackgroundColor];
//    }
}

- (void)toggleFullscreen
{
    BOOL hideMenus = !self.navigationController.toolbarHidden;
    
    if (hideMenus && thumbViewShowing) {
        [self toggleThumbView];
    }
    
    //    if (!hideMenus) {
    //        lockedView.alpha = 1.0;
    //    } else {
    //        lockedView.alpha = 0.5;
    //    }
    
    [self.navigationController setToolbarHidden:hideMenus animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:hideMenus withAnimation:UIStatusBarAnimationSlide];
}


@end
