//
//  AWBRoadsignMagicStoreViewController.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 12/01/2012.
//  Copyright (c) 2012 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface AWBRoadsignMagicStoreViewController : UITableViewController {
    MBProgressHUD *hud; 
    Reachability *reach;
    BOOL currentlyConnected;
    
}

@property (retain) MBProgressHUD *hud;
@property (nonatomic, retain) Reachability *reach;

- (void)productsLoaded:(NSNotification *)notification;
- (void)productsRestored:(NSNotification *)notification;
- (void)productLoadRequestHandler;
- (void)productLoadCompleteHandler;
- (void)restorePurchasesFailed:(NSNotification *)notification;

@end
