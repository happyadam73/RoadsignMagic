//
//  AWBRoadsignMagicMainController+Text.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController+Text.h"
#import "AWBRoadsignMagicMainViewController+UI.h"
#import "AWBRoadsignMagicViewController+Edit.h"

@implementation AWBRoadsignMagicMainViewController (Text)


- (void)addTextView:(id)sender
{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
    [self resetEditMode:sender];
    [self dismissAllActionSheetsAndPopovers];
    [self dismissAllSlideUpPickerViews];
    
    AWBRoadsignMagicSettingsTableViewController *settingsController = [[AWBRoadsignMagicSettingsTableViewController alloc] initWithSettings:[AWBSettings textSettingsWithInfo:[self settingsInfo]] settingsInfo:[self settingsInfo] rootController:nil]; 
    settingsController.delegate = self;
    settingsController.controllerType = AWBSettingsControllerTypeAddTextSettings;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;  
    [self presentModalViewController:navController animated:YES];
    [settingsController release];   
    [navController release];
    
    [pool drain];
}

- (void)editSelectedTextViews:(id)sender
{
    [self dismissAllActionSheetsAndPopovers];
    [self dismissAllSlideUpPickerViews];
    if (totalSelectedLabelsInEditMode == 0) {
        return;
    }
    
    AWBRoadsignMagicSettingsTableViewController *settingsController = nil;
    
    UILabel *selectedLabelView = nil;
    AWBTransformableAnyFontLabel *selectedLabel = nil;
    BOOL isZFontLabel = NO;
    NSString *fontURL = nil;
    
    for(UIView <AWBTransformableView> *view in [[self.signBackgroundView subviews] reverseObjectEnumerator]) {
        if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
            if ((view.alpha == SELECTED_ALPHA) && [view isKindOfClass:[AWBTransformableAnyFontLabel class]]) {
                selectedLabel = (AWBTransformableAnyFontLabel *)view;
                selectedLabelView = [(AWBTransformableAnyFontLabel *)view labelView];
                isZFontLabel = [(AWBTransformableAnyFontLabel *)view isZFontLabel];
                fontURL = [(AWBTransformableAnyFontLabel *)view myFontUrl];
                break;
            }
        }            
    }    
    
    if (isZFontLabel) {
        if (fontURL) {
            self.useMyFonts = YES;
            self.labelMyFont = fontURL;
        } else {
            self.useMyFonts = NO;
            self.labelTextFont = ((FontLabel *)selectedLabelView).zFont.familyName;            
        }
    } else {
        self.useMyFonts = NO;
        self.labelTextFont = selectedLabelView.font.fontName;
    }
    
    self.labelTextColor = selectedLabelView.textColor;
    self.labelTextAlignment = selectedLabelView.textAlignment;
    self.addTextBorders = selectedLabel.addBorder;
    self.addTextBackground = selectedLabel.addTextBackground;
    self.textRoundedBorders = selectedLabel.roundedBorder;
    self.textBorderColor = selectedLabel.viewBorderColor;
    self.textBackgroundColor = selectedLabel.textBackgroundColor;
    
    if (totalSelectedLabelsInEditMode == 1) {
        //set info for selected label
        if (selectedLabelView) {
            NSArray *lines = [[selectedLabelView text] componentsSeparatedByString:@"\r\n"];
            NSUInteger lineCount = [lines count];
            if (lineCount > 0) {
                self.labelTextLine1 = [lines objectAtIndex:0];
            } else {
                self.labelTextLine1 = nil;
            }
            if (lineCount > 1) {
                self.labelTextLine2 = [lines objectAtIndex:1];
            } else {
                self.labelTextLine2 = nil;
            }
            if (lineCount > 2) {
                self.labelTextLine3 = [lines objectAtIndex:2];
            } else {
                self.labelTextLine3 = nil;
            }
        }
        settingsController = [[AWBRoadsignMagicSettingsTableViewController alloc] initWithSettings:[AWBSettings editSingleTextSettingsWithInfo:[self settingsInfo]] settingsInfo:[self settingsInfo] rootController:nil];        
    } else {
        settingsController = [[AWBRoadsignMagicSettingsTableViewController alloc] initWithSettings:[AWBSettings editTextSettingsWithInfo:[self settingsInfo]] settingsInfo:[self settingsInfo] rootController:nil];        
    }
    
    settingsController.delegate = self;
    settingsController.controllerType = AWBSettingsControllerTypeEditTextSettings;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;  
    [self presentModalViewController:navController animated:YES];
    [settingsController release];   
    [navController release];
}

- (NSMutableArray *)textLabelLines
{
    NSMutableArray *lines = [[NSMutableArray alloc] initWithCapacity:3];
    if ([self.labelTextLine1 length] > 0) {
        [lines addObject:self.labelTextLine1];
    }
    if ([self.labelTextLine2 length] > 0) {
        [lines addObject:self.labelTextLine2];
    }  
    if ([self.labelTextLine3 length] > 0) {
        [lines addObject:self.labelTextLine3];
    }
    return [lines autorelease];
}

@end
