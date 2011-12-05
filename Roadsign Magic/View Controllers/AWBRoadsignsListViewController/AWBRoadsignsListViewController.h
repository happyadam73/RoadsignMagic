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

@class AWBRoadsignMagicMainViewController;

@interface AWBRoadsignsListViewController : UITableViewController <AWBRoadsignMagicSettingsTableViewControllerDelegate>
{
    NSInteger scrollToRow;
    AWBBusyView *busyView;
}

@property (nonatomic, retain) AWBBusyView *busyView;

- (CGFloat)borderThickness;
- (void)addNewRoadsignDescriptor:(id)sender;
- (void)loadRoadsignAtIndexPath:(NSIndexPath *)indexPath;
- (void)navigateToRoadsignController:(AWBRoadsignMagicMainViewController *)roadsignController;
- (CGPoint)centerOfVisibleRows;

@end
