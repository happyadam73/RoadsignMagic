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
#import "UIColor+Texture.h"

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

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.deleteConfirmationSheet) {
        [self deleteConfirmationActionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
    } else if (actionSheet == self.chooseActionTypeSheet) {
        [self chooseActionTypeActionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
    }
}

- (void)setExportSettingsFromSettingsInfo:(NSDictionary *)info
{
    self.exportSize = [[info objectForKey:kAWBInfoKeyExportSizeValue] floatValue];
    self.exportFormatSelectedIndex = [[info objectForKey:kAWBInfoKeyExportFormatSelectedIndex] integerValue];
    self.pngExportTransparentBackground = [[info objectForKey:kAWBInfoKeyPNGExportTransparentBackground] boolValue];
    self.jpgExportQualityValue = [[info objectForKey:kAWBInfoKeyJPGExportQualityValue] floatValue];
}

- (void)setBackgroundSettingsFromSettingsInfo:(NSDictionary *)info
{
    self.useBackgroundTexture = [[info objectForKey:kAWBInfoKeyRoadsignUseBackgroundTexture] boolValue];
    self.roadsignBackgroundTexture = [info objectForKey:kAWBInfoKeyRoadsignBackgroundTexture];
    self.roadsignBackgroundColor = [info objectForKey:kAWBInfoKeyRoadsignBackgroundColor];
    
    if (self.useBackgroundTexture && self.roadsignBackgroundTexture) {
        self.view.backgroundColor = [UIColor textureColorWithDescription:self.roadsignBackgroundTexture];
    } else {
        if (self.roadsignBackgroundColor) {
            self.view.backgroundColor = self.roadsignBackgroundColor;
        }            
    }
}

- (void)setCollageDrawingAidsFromSettingsInfo:(NSDictionary *)info
{
    self.lockedView.objectsLocked = [[info objectForKey:kAWBInfoKeyLockCanvas] boolValue];
    self.lockedView.canvasAnchored = [[info objectForKey:kAWBInfoKeyScrollLocked] boolValue];
    self.snapToGrid = [[info objectForKey:kAWBInfoKeySnapToGrid] boolValue];
    self.snapRotation = [[info objectForKey:kAWBInfoKeySnapRotation] boolValue];
    self.snapToGridSize = [[info objectForKey:kAWBInfoKeySnapToGridSize] floatValue];
}

- (NSMutableDictionary *)settingsInfo
{
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithFloat:self.exportSize], kAWBInfoKeyExportSizeValue, 
                                 [NSNumber numberWithBool:self.lockedView.objectsLocked], kAWBInfoKeyLockCanvas, 
                                 [NSNumber numberWithBool:self.lockedView.canvasAnchored], kAWBInfoKeyScrollLocked, 
                                 [NSNumber numberWithBool:self.snapToGrid], kAWBInfoKeySnapToGrid, 
                                 [NSNumber numberWithBool:self.snapRotation], kAWBInfoKeySnapRotation, 
                                 [NSNumber numberWithFloat:self.snapToGridSize], kAWBInfoKeySnapToGridSize, 
                                 [NSNumber numberWithInteger:self.labelTextAlignment], kAWBInfoKeyTextAlignment,
                                 [NSNumber numberWithInteger:self.exportFormatSelectedIndex], kAWBInfoKeyExportFormatSelectedIndex,
                                 [NSNumber numberWithBool:self.pngExportTransparentBackground], kAWBInfoKeyPNGExportTransparentBackground,
                                 [NSNumber numberWithFloat:self.jpgExportQualityValue], kAWBInfoKeyJPGExportQualityValue,
                                 [NSNumber numberWithBool:self.useBackgroundTexture], kAWBInfoKeyRoadsignUseBackgroundTexture,
                                 [NSNumber numberWithBool:self.addTextBorders], kAWBInfoKeyTextBorders,
                                 [NSNumber numberWithBool:self.textRoundedBorders], kAWBInfoKeyTextRoundedBorders,
                                 [NSNumber numberWithBool:self.addTextBackground], kAWBInfoKeyTextBackground,
                                 [NSNumber numberWithBool:self.useMyFonts], kAWBInfoKeyUseMyFonts,
                                 nil];
             
    if (self.roadsignBackgroundColor) {
        [info setObject:self.roadsignBackgroundColor forKey:kAWBInfoKeyRoadsignBackgroundColor];        
    } 
    if (self.roadsignBackgroundTexture) {
        [info setObject:self.roadsignBackgroundTexture forKey:kAWBInfoKeyRoadsignBackgroundTexture];        
    } 
    if (self.labelTextColor) {
        [info setObject:self.labelTextColor forKey:kAWBInfoKeyTextColor];        
    }    
    if (self.labelTextFont) {
        [info setObject:self.labelTextFont forKey:kAWBInfoKeyTextFontName];        
    }     
    if (self.labelMyFont) {
        [info setObject:self.labelMyFont forKey:kAWBInfoKeyMyFontName];        
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
    if (self.textBorderColor) {
        [info setObject:self.textBorderColor forKey:kAWBInfoKeyTextBorderColor];
    }
    if (self.textBackgroundColor) {
        [info setObject:self.textBackgroundColor forKey:kAWBInfoKeyTextBackgroundColor];
    }
    
    return info;
}

- (void)awbRoadsignMagicSettingsTableViewController:(AWBRoadsignMagicSettingsTableViewController *)settingsController didFinishSettingsWithInfo:(NSDictionary *)info;
{
    facebook.sessionDelegate = self;
    switch (settingsController.controllerType) {
        case AWBSettingsControllerTypeMainSettings:
            [self setExportSettingsFromSettingsInfo:info];
            [self setBackgroundSettingsFromSettingsInfo:info];
            [self setCollageDrawingAidsFromSettingsInfo:info];
            [self saveChanges:NO];            
            break;
        case AWBSettingsControllerTypeAddTextSettings:
            self.labelTextLine1 = [info objectForKey:kAWBInfoKeyLabelTextLine1];
            self.labelTextLine2 = [info objectForKey:kAWBInfoKeyLabelTextLine2];
            self.labelTextLine3 = [info objectForKey:kAWBInfoKeyLabelTextLine3];
            self.labelTextColor = [info objectForKey:kAWBInfoKeyTextColor];
            self.labelTextFont = [info objectForKey:kAWBInfoKeyTextFontName];
            self.labelMyFont = [info objectForKey:kAWBInfoKeyMyFontName];
            self.useMyFonts = [[info objectForKey:kAWBInfoKeyUseMyFonts] boolValue];
            self.labelTextAlignment = [[info objectForKey:kAWBInfoKeyTextAlignment] integerValue];
            self.addTextBorders = [[info objectForKey:kAWBInfoKeyTextBorders] boolValue];
            self.addTextBackground = [[info objectForKey:kAWBInfoKeyTextBackground] boolValue];
            self.textRoundedBorders = [[info objectForKey:kAWBInfoKeyTextRoundedBorders] boolValue];
            self.textBorderColor = [info objectForKey:kAWBInfoKeyTextBorderColor];
            self.textBackgroundColor = [info objectForKey:kAWBInfoKeyTextBackgroundColor];
            
            if (self.labelTextLine1 || self.labelTextLine2 || self.labelTextLine3) {
                NSMutableArray *lines = [self textLabelLines];
                if ([lines count] > 0) {
                    NSString *fontName = nil;
                    if (self.useMyFonts) {
                        fontName = self.labelMyFont;
                    } else {
                        fontName = self.labelTextFont;
                    }
                    AWBTransformableAnyFontLabel *label = [[AWBTransformableAnyFontLabel alloc] initWithTextLines:lines fontName:fontName fontSize:DEFAULT_FONT_POINT_SIZE offset:CGPointZero rotation:0.0 scale:1.0 horizontalFlip:NO color:self.labelTextColor alignment:self.labelTextAlignment];                    
                    [self applySettingsToLabel:label];
                    label.center = [self.signBackgroundView convertPoint:self.signBackgroundView.center fromView:self.signBackgroundView.superview];
                    [self.signBackgroundView addSubview:label];
                    [label initialiseForSelection];
                    self.totalLabelSubviews += 1;
                    [label release];                        
                }
            }
            [self saveChanges:NO];
            break;
        case AWBSettingsControllerTypeEditTextSettings:
            self.labelTextColor = [info objectForKey:kAWBInfoKeyTextColor];
            self.labelTextFont = [info objectForKey:kAWBInfoKeyTextFontName];
            self.labelMyFont = [info objectForKey:kAWBInfoKeyMyFontName];
            self.useMyFonts = [[info objectForKey:kAWBInfoKeyUseMyFonts] boolValue];
            self.labelTextAlignment = [[info objectForKey:kAWBInfoKeyTextAlignment] integerValue];
            self.addTextBorders = [[info objectForKey:kAWBInfoKeyTextBorders] boolValue];
            self.addTextBackground = [[info objectForKey:kAWBInfoKeyTextBackground] boolValue];
            self.textRoundedBorders = [[info objectForKey:kAWBInfoKeyTextRoundedBorders] boolValue];
            self.textBorderColor = [info objectForKey:kAWBInfoKeyTextBorderColor];
            self.textBackgroundColor = [info objectForKey:kAWBInfoKeyTextBackgroundColor];          
            NSString *fontName = nil;
            if (self.useMyFonts) {
                fontName = self.labelMyFont;
            } else {
                fontName = self.labelTextFont;
            }
            for(UIView <AWBTransformableView> *view in [[self.signBackgroundView subviews] reverseObjectEnumerator]) {
                if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
                    if ((view.alpha == SELECTED_ALPHA) && [view isKindOfClass:[AWBTransformableAnyFontLabel class]]) {
                        AWBTransformableAnyFontLabel *label = (AWBTransformableAnyFontLabel *)view;
                        
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
                                [label updateLabelTextLines:lines withFontName:fontName fontSize:DEFAULT_FONT_POINT_SIZE];
                            } else {
                                [label updateLabelTextWithFontName:fontName fontSize:DEFAULT_FONT_POINT_SIZE];
                            }
                        } else {
                            // more than one label - update the font so frame is adjusted
                            [label updateLabelTextWithFontName:fontName fontSize:DEFAULT_FONT_POINT_SIZE];
                        }
                        
                        [self applySettingsToLabel:label];
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

- (void)awbRoadsignMagicSettingsTableViewControllerDidDissmiss:(AWBRoadsignMagicSettingsTableViewController *)settingsController
{
    facebook.sessionDelegate = self;
}

- (void)applySettingsToLabel:(AWBTransformableAnyFontLabel *)label
{
    [label setRoundedBorder:self.textRoundedBorders];
    [label setViewBorderColor:self.textBorderColor];
    [label setTextBackgroundColor:self.textBackgroundColor];
    label.addBorder = self.addTextBorders;
    label.addTextBackground = self.addTextBackground;
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
    if (snapToGridSize > 100.0) {
        snapToGridSize = 100.0;
    }
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
