//
//  AWBRoadsignMagicMainController+UI.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController+UI.h"
#import "AWBRoadsignMagicMainViewController+Text.h"
#import "AWBRoadsignMagicViewController+Delete.h"
#import "AWBRoadsignMagicViewController+Edit.h"
#import "AWBRoadsignMagicViewController+Sign.h"
#import "AWBRoadsignMagicViewController+Symbol.h"
#import "AWBRoadsignMagicViewController+Action.h"

@implementation AWBRoadsignMagicMainViewController (UI)

- (void)dismissAllSlideUpPickerViews
{
    if (signBackgroundPickerViewShowing) {
        [self toggleSignBackgroundPickerView:self.signBackgroundPickerButton.customView];
    }
    if (signSymbolPickerViewShowing) {
        [self toggleSignSymbolPickerView:self.signSymbolPickerButton.customView];            
    }     
}

- (void)dismissSignBackgroundPickerView
{
    if (signBackgroundPickerViewShowing) {
        [self toggleSignBackgroundPickerView:self.signBackgroundPickerButton.customView];
    }    
}

- (void)dismissSignSymbolPickerView
{
    if (signSymbolPickerViewShowing) {
        [self toggleSignSymbolPickerView:self.signSymbolPickerButton.customView];            
    }     
}

- (void)dismissAllActionSheetsAndPopovers
{
    if (DEVICE_IS_IPAD) {
        [self dismissActionSheetIfVisible:self.deleteConfirmationSheet];
        [self dismissActionSheetIfVisible:self.chooseActionTypeSheet];
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
    [self resetEditMode:sender];
    [self dismissAllActionSheetsAndPopovers];
    [self dismissAllSlideUpPickerViews];
        
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
    if (actionSheet == self.deleteConfirmationSheet) {
        [self deleteConfirmationActionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
    } else if (actionSheet == self.chooseActionTypeSheet) {
        [self chooseActionTypeActionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)setExportQualityFromSettingsInfo:(NSDictionary *)info
{
    [self setExportQuality:[[info objectForKey:kAWBInfoKeyExportQualityValue] floatValue]];
}

- (void)setCollageDrawingAidsFromSettingsInfo:(NSDictionary *)info
{
    self.lockedView.objectsLocked = [[info objectForKey:kAWBInfoKeyLockCanvas] boolValue];
    self.lockedView.canvasAnchored = [[info objectForKey:kAWBInfoKeyScrollLocked] boolValue];
    self.snapToGrid = [[info objectForKey:kAWBInfoKeySnapToGrid] boolValue];
    self.snapToGridSize = [[info objectForKey:kAWBInfoKeySnapToGridSize] floatValue];
}

- (NSMutableDictionary *)settingsInfo
{
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithFloat:self.exportQuality], kAWBInfoKeyExportQualityValue, 
                                 [NSNumber numberWithBool:self.lockedView.objectsLocked], kAWBInfoKeyLockCanvas, 
                                 [NSNumber numberWithBool:self.lockedView.canvasAnchored], kAWBInfoKeyScrollLocked, 
                                 [NSNumber numberWithBool:self.snapToGrid], kAWBInfoKeySnapToGrid, 
                                 [NSNumber numberWithFloat:self.snapToGridSize], kAWBInfoKeySnapToGridSize, 
                                 [NSNumber numberWithInteger:self.labelTextAlignment], kAWBInfoKeyTextAlignment,
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
            [self saveChanges:NO];            
            break;
        case AWBSettingsControllerTypeAddTextSettings:
            self.labelTextLine1 = [info objectForKey:kAWBInfoKeyLabelTextLine1];
            self.labelTextLine2 = [info objectForKey:kAWBInfoKeyLabelTextLine2];
            self.labelTextLine3 = [info objectForKey:kAWBInfoKeyLabelTextLine3];
            self.labelTextColor = [info objectForKey:kAWBInfoKeyTextColor];
            self.labelTextFont = [info objectForKey:kAWBInfoKeyTextFontName];
            self.labelTextAlignment = [[info objectForKey:kAWBInfoKeyTextAlignment] integerValue];
            
            if (self.labelTextLine1 || self.labelTextLine2 || self.labelTextLine3) {
                NSMutableArray *lines = [self textLabelLines];
                if ([lines count] > 0) {
                    AWBTransformableZFontLabel *label = [[AWBTransformableZFontLabel alloc] initWithTextLines:lines font:self.roadsignFont offset:CGPointZero rotation:0.0 scale:1.0 horizontalFlip:NO color:self.labelTextColor alignment:self.labelTextAlignment];                    
                    [self applySettingsToLabel:label];
                    label.center = [self.signBackgroundView convertPoint:self.signBackgroundView.center fromView:self.signBackgroundView.superview];
                    [self.signBackgroundView addSubview:label];
                    [label initialiseForSelection];
                    totalLabelSubviews += 1;
                    [label release];                        
                }
            }
            
            [self saveChanges:NO];
            break;
        case AWBSettingsControllerTypeEditTextSettings:
            self.labelTextColor = [info objectForKey:kAWBInfoKeyTextColor];
            self.labelTextFont = [info objectForKey:kAWBInfoKeyTextFontName];
            self.labelTextAlignment = [[info objectForKey:kAWBInfoKeyTextAlignment] integerValue];
            
            for(UIView <AWBTransformableView> *view in [[self.signBackgroundView subviews] reverseObjectEnumerator]) {
                if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
                    if ((view.alpha == SELECTED_ALPHA) && [view isKindOfClass:[AWBTransformableZFontLabel class]]) {
                        AWBTransformableZFontLabel *label = (AWBTransformableZFontLabel *)view;
                        
                        label.labelView.textAlignment = self.labelTextAlignment;
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
            [self resetEditMode:settingsController];
            [self saveChanges:NO];
            break;
        default:
            break;
    }
}

//- (void)awbRoadsignMagicSettingsTableViewControllerDidDissmiss:(AWBRoadsignMagicSettingsTableViewController *)settingsController
//{
//
//}

- (void)applySettingsToLabel:(AWBTransformableZFontLabel *)label
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
    
    if (hideMenus) {
        [self dismissAllActionSheetsAndPopovers];
        [self dismissAllSlideUpPickerViews];       
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:hideMenus withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setToolbarHidden:hideMenus animated:YES];
    [self.navigationController setNavigationBarHidden:hideMenus animated:YES];    
}


#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIView *view = nil;
    if (scrollView == mainScrollView) {
        view = signBackgroundView;
    }
    return view;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    snapToGridSize = SNAP_TO_GRID_SIZE/mainScrollView.zoomScale;

    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)? 
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)? 
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;    
    signBackgroundView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, 
                                            scrollView.contentSize.height * 0.5 + offsetY);
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{    
    CGRect zoomRect;
        
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [mainScrollView frame].size.height / scale;
    zoomRect.size.width  = [mainScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


@end
