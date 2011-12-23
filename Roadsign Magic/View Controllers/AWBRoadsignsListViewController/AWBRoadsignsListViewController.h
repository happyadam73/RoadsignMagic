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
	id <UITableViewDataSource, AWBRoadsignDataSource> dataSource;

    NSInteger scrollToRow;
    AWBBusyView *busyView;
    BOOL animateTransition;
}

@property (nonatomic,retain) UITableView *theTableView;
@property (nonatomic,retain) id <UITableViewDataSource, AWBRoadsignDataSource> dataSource;
@property (nonatomic, retain) AWBBusyView *busyView;

- (id)initWithDataSource:(id <UITableViewDataSource, AWBRoadsignDataSource>)theDataSource;
- (void)addNewRoadsignDescriptor:(id)sender;
- (void)loadRoadsignAtIndexPath:(NSIndexPath *)indexPath withSettingsInfo:(NSDictionary *)info;
- (void)navigateToRoadsignController:(AWBRoadsignMagicMainViewController *)roadsignController;
- (CGPoint)centerOfVisibleRows;
- (void)addToolbar;

@end
