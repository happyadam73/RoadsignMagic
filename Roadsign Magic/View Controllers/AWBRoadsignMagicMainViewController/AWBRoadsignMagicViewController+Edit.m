//
//  AWBRoadsignMagicViewController+Edit.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicViewController+Edit.h"
#import "AWBRoadsignMagicMainViewController+Gestures.h"
#import "AWBRoadsignMagicMainViewController+UI.h"
#import "FileHelpers.h"
#import "UIColor+SignColors.h"
#import "AWBRoadsignMagicMainViewController+Toolbar.h"
#import "AWBTransformableAnyFontLabel.h"
#import "AWBTransformableLabel.h"

@implementation AWBRoadsignMagicMainViewController (Edit)


- (void)objectTappedInEditMode:(UIView <AWBTransformableView> *)view
{
    if (view.alpha == SELECTED_ALPHA) {
        view.alpha = UNSELECTED_ALPHA;
        [view setSelectionOpacity:UNSELECTED_ALPHA];
        [view showSelectionWithAnimation:NO];
        //deselecting
        totalSelectedInEditMode -= 1;
        if ([view isKindOfClass:[AWBTransformableAnyFontLabel class]]) {
            totalSelectedLabelsInEditMode -= 1;
        }
    } else {
        view.alpha = SELECTED_ALPHA;
        [view setSelectionOpacity:SELECTED_ALPHA];
        [view showSelectionWithAnimation:YES];
        totalSelectedInEditMode += 1;
        if ([view isKindOfClass:[AWBTransformableAnyFontLabel class]]) {
            totalSelectedLabelsInEditMode += 1;
        }
    }    
    [self updateUserInterfaceWithTotalSelectedInEditMode];
}

- (void)enableEditMode:(id)sender
{
    if (!self.isSignInEditMode) {
        self.isSignInEditMode = YES;
        [self dismissAllActionSheetsAndPopovers];
        [self dismissAllSlideUpPickerViews];
        [self.navigationItem setHidesBackButton:YES animated:YES];
        self.navigationItem.titleView = nil;
        self.navigationItem.title = @"Select Objects";
        [self.navigationItem setRightBarButtonItem:self.cancelButton animated:YES];        
        [self setToolbarForEditMode];
        
        self.selectNoneOrAllButton.title = @"Select All";
        
        for(UIView <AWBTransformableView> *view in [[self.signBackgroundView subviews] reverseObjectEnumerator]) {
            if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
                view.alpha = UNSELECTED_ALPHA;
                [view setSelectionOpacity:UNSELECTED_ALPHA];
                [view showSelectionWithAnimation:NO];
            }            
        }
        totalSelectedInEditMode = 0;
        totalSelectedLabelsInEditMode = 0;
        [self updateUserInterfaceWithTotalSelectedInEditMode];
    }
}

- (void)selectAllOrNoneInEditMode:(id)sender
{
    BOOL buttonSelectsAll = [[(UIBarButtonItem *)sender title] isEqualToString:@"Select All"];
    NSString *newTitle = (buttonSelectsAll ? @"Select None" : @"Select All");
    [(UIBarButtonItem *)sender setTitle:newTitle];
    
    totalSelectedInEditMode = 0;
    totalSelectedLabelsInEditMode = 0;
    for(UIView <AWBTransformableView> *view in [[self.signBackgroundView subviews] reverseObjectEnumerator]) {
        if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
            if (buttonSelectsAll) {
                view.alpha = SELECTED_ALPHA;
                [view setSelectionOpacity:SELECTED_ALPHA];
                [view showSelectionWithAnimation:YES];
                totalSelectedInEditMode += 1;
                if ([view isKindOfClass:[AWBTransformableAnyFontLabel class]]) {
                    totalSelectedLabelsInEditMode += 1;
                }
            } else {
                view.alpha = UNSELECTED_ALPHA;
                [view setSelectionOpacity:UNSELECTED_ALPHA];
                [view showSelectionWithAnimation:NO];
            }
        }            
    } 
    
    [self updateUserInterfaceWithTotalSelectedInEditMode];    
}

- (void)resetEditMode:(id)sender
{
    if (self.isSignInEditMode) {
        self.isSignInEditMode = NO;
        totalSelectedInEditMode = 0;
        totalSelectedLabelsInEditMode = 0;
        for(UIView <AWBTransformableView> *view in [[self.signBackgroundView subviews] reverseObjectEnumerator]) {
            if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
                view.alpha = NORMAL_ALPHA;
                [view setSelectionOpacity:NORMAL_ALPHA];
                [view hideSelection];
            }            
        }  
        [self updateUserInterfaceWithTotalSelectedInEditMode];
        self.navigationItem.title = nil;
        [self.navigationItem setHidesBackButton:NO animated:YES];
        self.navigationItem.titleView = lockedView;
        
        if (self.totalSubviews > 0) {
            [self.navigationItem setRightBarButtonItem:self.editButton animated:YES];
        } else {
            [self.navigationItem setRightBarButtonItem:nil animated:YES];
        }
        
        [self resetToNormalToolbar];
        [self saveChanges:NO];
    }
}

- (void)updateUserInterfaceWithTotalSelectedInEditMode
{
    //maybe a possible race condition - and menu/toolbar might be hidden at this point which is not good
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    if (self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController setToolbarHidden:NO animated:NO];    
        
    }
    
    if (totalSelectedInEditMode == 0) {
        self.navigationItem.title = @"Select Objects";
        [self updateTintedSegmentedControlButton:self.deleteButton withTitle:@"Delete"];
        self.deleteButton.enabled = NO;
        self.deleteButton.customView.alpha = 0.5;
    } else {
        NSString *objectString;
        if (totalSelectedInEditMode == 1) {
            objectString = @"Object";
        } else {
            objectString = @"Objects";
        }
        self.navigationItem.title = [NSString stringWithFormat:@"%d %@ Selected", totalSelectedInEditMode, objectString];
        [self updateTintedSegmentedControlButton:self.deleteButton withTitle:[NSString stringWithFormat:@"Delete (%d)", totalSelectedInEditMode]];        
        self.deleteButton.enabled = YES;
        self.deleteButton.customView.alpha = 1.0;
    }
    
    if (totalSelectedLabelsInEditMode == 0) {
        [self updateTintedSegmentedControlButton:self.editTextButton withTitle:@"Edit Text"];
        self.editTextButton.enabled = NO;
        self.editTextButton.customView.alpha = 0.5;
    } else {
        [self updateTintedSegmentedControlButton:self.editTextButton withTitle:[NSString stringWithFormat:@"Edit Text (%d)", totalSelectedLabelsInEditMode]];        
        self.editTextButton.enabled = YES;
        self.editTextButton.customView.alpha = 1.0;
    }
}

@end
