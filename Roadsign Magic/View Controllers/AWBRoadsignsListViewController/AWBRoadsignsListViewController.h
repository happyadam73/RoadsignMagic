//
//  AWBRoadsignsListViewController.h
//  Roadsign Magic
//
//  Created by Buckley Adam on 23/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBBusyView.h"
#import "AWBRoadsignMagicSettingsTableViewController.h"
#import "AWBRoadsignDataSource.h"

@class AWBRoadsignMagicMainViewController;

@interface AWBRoadsignsListViewController : UIViewController <UITableViewDelegate> {
	UITableView *theTableView;
    NSArray *dataSources;
    NSUInteger selectedDataSource;
    NSInteger scrollToRow;
    AWBBusyView *busyView;
    BOOL animateTransition;
    UIBarButtonItem *myFontsButton;
    UIBarButtonItem *inAppStoreButton;
    UIBarButtonItem *helpButton;
    UIBarButtonItem *toolbarSpacing;
    BOOL changingSegmentIndex;
}

@property (nonatomic,retain) UITableView *theTableView;
@property (nonatomic, retain) NSArray *dataSources;
@property (nonatomic, retain) AWBBusyView *busyView;
@property (nonatomic, assign) NSUInteger selectedDataSource;
@property (nonatomic, retain) UIBarButtonItem *myFontsButton;
@property (nonatomic, retain) UIBarButtonItem *inAppStoreButton;
@property (nonatomic, retain) UIBarButtonItem *helpButton;
@property (nonatomic, retain) UIBarButtonItem *toolbarSpacing;

- (id)initWithDataSources:(NSArray *)theDataSources;
- (void)addNewRoadsignDescriptor:(id)sender;
- (void)loadRoadsignAtIndexPath:(NSIndexPath *)indexPath withSettingsInfo:(NSDictionary *)info;
- (void)navigateToRoadsignController:(AWBRoadsignMagicMainViewController *)roadsignController;
- (CGPoint)centerOfVisibleRows;
- (void)addTitleView;
- (void)switchDatasource:(id)sender;
- (void)switchDatasourceWithSelectedIndex:(NSUInteger)selectedIndex;
- (void)showMyFonts;
- (void)showInAppStore;
- (NSArray *)mySignsToolbarButtons;

@end
