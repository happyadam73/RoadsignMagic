//
//  AWBRoadsignsListViewController.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/12/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBRoadsignMagicSettingsTableViewController.h"
#import "AWBBusyView.h"
#import "AWBMyFont.h"

@class AWBRoadsignMagicMainViewController;

@interface AWBMyFontsListViewController : UIViewController <UITableViewDataSource, 
                                                            UITableViewDelegate, 
                                                            UIAlertViewDelegate, 
                                                            AWBRoadsignMagicSettingsTableViewControllerDelegate>
{
	UITableView *theTableView;
    BOOL pendingMyFontInstall;
    AWBMyFont *pendingMyFont;
    NSURL *pendingMyFontInstallURL;
    UIAlertView *installMyFontAlertView;
    UIBarButtonItem *helpButton;
    UIBarButtonItem *toolbarSpacing;
    BOOL showPurchaseWarning;
}

@property (nonatomic, retain) UITableView *theTableView;
@property (nonatomic, assign) BOOL pendingMyFontInstall;
@property (nonatomic, retain) NSURL *pendingMyFontInstallURL;
@property (nonatomic, retain) UIAlertView *installMyFontAlertView;
@property (nonatomic, retain) UIBarButtonItem *helpButton;
@property (nonatomic, retain) UIBarButtonItem *toolbarSpacing;

- (void)initialise;
- (void)attemptMyFontInstall;
- (void)confirmMyFontInstall:(NSString *)fontName;
- (void)showFontInstallError:(NSString *)filename;
- (void)showMyFontsNotPurchased;
- (UIBarButtonItem *)helpButton;
- (void)showHelp;
- (NSArray *)myFontsToolbarButtons;

@end
