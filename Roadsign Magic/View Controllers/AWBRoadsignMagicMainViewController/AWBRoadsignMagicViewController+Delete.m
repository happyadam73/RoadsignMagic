//
//  AWBRoadsignMagicViewController+Delete.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicViewController+Delete.h"
#import "AWBRoadsignMagicMainViewController+UI.h"
#import "AWBRoadsignMagicMainViewController+Toolbar.h"
#import "AWBTransformableSymbolImageView.h"

@implementation AWBRoadsignMagicMainViewController (Delete)

- (void)deleteSelectedViews:(id)sender
{
    BOOL wasActionSheetVisible = self.deleteConfirmationSheet.visible;
    [self dismissAllActionSheetsAndPopovers];
    [self dismissAllSlideUpPickerViews];
    
    if (wasActionSheetVisible || (totalSelectedInEditMode == 0)) {
        return;
    }
    
    NSString *deleteDescription;
    if (totalSelectedInEditMode == 1) {
        deleteDescription = @"Delete Object";
    } else {
        deleteDescription = @"Delete Selected Objects";
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                                    cancelButtonTitle:@"Cancel" 
                                               destructiveButtonTitle:deleteDescription 
                                                    otherButtonTitles:nil];
    self.deleteConfirmationSheet = actionSheet;
    [actionSheet release];
    
    [self.deleteConfirmationSheet showFromBarButtonItem:self.deleteButton animated:YES];    
}

- (void)deleteConfirmationActionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    CGFloat animationDelay = 0.0;
    
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        
        for(UIView <AWBTransformableView> *view in [self.signBackgroundView subviews]) {
            if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
                if (view.alpha == SELECTED_ALPHA) {
                    [view removeSelection];
                    if ([view isKindOfClass:[AWBTransformableAnyFontLabel class]]) {
                        self.totalLabelSubviews -= 1;
                    } else if ([view isKindOfClass:[AWBTransformableSymbolImageView class]]) {
                        self.totalSymbolSubviews -= 1;
                    }
                    animationDelay = 0.5;
                    [UIView animateWithDuration:animationDelay delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations: ^ {[view setCenter:[self deleteButtonApproxPosition]]; [view setAlpha:0.0]; view.transform = CGAffineTransformMakeScale(0.1, 0.1);} 
                                     completion: ^ (BOOL finished) {[view removeFromSuperview];}];
                }
            }            
        }
        
        if (animationDelay > 0.0) {
            animationDelay += 0.1;
        }
        
        [self performSelector:@selector(resetEditMode:) withObject:actionSheet afterDelay:animationDelay];
    }
}

@end
