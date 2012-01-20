//
//  AWBRoadsignMagicStoreViewController.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 12/01/2012.
//  Copyright (c) 2012 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicStoreViewController.h"
#import "InAppStore.h"
#import "MAConfirmButton.h"


@implementation AWBRoadsignMagicStoreViewController

@synthesize hud, reach;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.reach = [Reachability reachabilityForInternetConnection];
        [self.reach startNotifier];
        currentlyConnected = ([self.reach currentReachabilityStatus] != NotReachable);
    }
    return self;    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.reach stopNotifier];
    [hud release];
    [reach release];
    hud = nil;
    [super dealloc];
}

- (void)dismissHUD:(id)arg 
{    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.hud = nil;
}

- (void)productsLoaded:(NSNotification *)notification 
{    
    [self productLoadCompleteHandler];
}

- (void)productsRestored:(NSNotification *)notification
{
    [self productLoadCompleteHandler];
}

- (void)timeout:(id)arg 
{    
    [self dismissHUD:nil]; 
    [self.tableView reloadData];
}

- (void)updateInterfaceWithReachability:(NSNotification *)notification 
{
    currentlyConnected = ([self.reach currentReachabilityStatus] != NotReachable);
    [self productLoadRequestHandler];
}

- (void)productLoadRequestHandler
{
    if (currentlyConnected) {
        if ([InAppStore defaultStore].products == nil) 
        {
            [[InAppStore defaultStore] requestProducts];
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            self.hud.labelText = @"Loading Products ...";
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
        } else {
            [self productsLoaded:nil];
        }
    } else {
        //not currently connected - reload table to get footer message
        [self dismissHUD:nil];  
        [self.tableView reloadData];
    }
}

- (void)productLoadCompleteHandler
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self dismissHUD:nil];    
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.reach stopNotifier];
    self.hud = nil;
    self.reach = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inappstore"]];
    self.navigationItem.titleView = titleView;
    [titleView release];

    [[self navigationItem] setRightBarButtonItem:nil]; 

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productsRestored:) name:kProductsRestoredNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(restorePurchasesFailed:) name:kProductsRestoredFailedNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(updateInterfaceWithReachability:) name:kReachabilityChangedNotification object: nil];
    
    currentlyConnected = ([self.reach currentReachabilityStatus] != NotReachable);
    [self productLoadRequestHandler];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];  
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    if ([indexPath section] == 0) {
        return 100.0;
    } else {
        return self.tableView.rowHeight;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSUInteger productCount = [[InAppStore defaultStore].products count];
    
    if (section == 0) {
        return productCount;        
    } else {
        if (productCount > 0) {
            NSUInteger purchaseCount = [[InAppStore defaultStore].purchasedProducts count];
            if (purchaseCount < productCount) {
                return 1;
            } else {
                return 0;
            }
        } else {
            return 0;
        }        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        static NSString *CellIdentifier = @"InAppStoreCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
        
        // Configure the cell.
        SKProduct *product = [[InAppStore defaultStore].products objectAtIndex:indexPath.row];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *formattedString = [numberFormatter stringFromNumber:product.price];
        [numberFormatter release];
        
        cell.textLabel.text = product.localizedTitle;
        cell.detailTextLabel.numberOfLines = 4;
        cell.detailTextLabel.text = product.localizedDescription;
        cell.imageView.image = [InAppStore productImageWithIdentifier:product.productIdentifier];
        
        MAConfirmButton *buyButton;
        if ([[InAppStore defaultStore].purchasedProducts containsObject:product.productIdentifier]) {
            buyButton = [MAConfirmButton buttonWithDisabledTitle:@"Purchased"];
        } else {
            buyButton = [MAConfirmButton buttonWithTitle:formattedString confirm:@"BUY NOW"];
            [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];        
        }
        [buyButton setAnchor:CGPointMake(80, 0)];
        buyButton.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = buyButton;     
        return cell;        
    } else {
        static NSString *CellIdentifier = @"RestoreCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }

        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = TABLE_CELL_BLUE_TEXT_COLOR;
        cell.textLabel.text = @"Restore Purchases";
        
        return cell;
    }    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath section] == 1) {
        //restore transactions
        if (!currentlyConnected) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"No Internet Connection" 
                                                             message:@"Sorry, no connection is available.  An Internet Connection is required to restore purchases."  
                                                            delegate:nil 
                                                   cancelButtonTitle:nil 
                                                   otherButtonTitles:@"OK", nil] autorelease];
            [alert show];
            [self.tableView reloadData];
        } else {
            if ([[InAppStore defaultStore] canMakePurchases]) {                
                NSLog(@"Restoring Purchases");
                [[InAppStore defaultStore] restoreCompletedTransactions];
                self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                self.hud.labelText = @"Restoring Purchases";
                [self performSelector:@selector(timeout:) withObject:nil afterDelay:60];            
            } else {
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Unauthorised Restore" 
                                                                 message:@"This device is currently blocked from restoring In-App purchases.  The owner can change this in Settings (General - Restrictions)"  
                                                                delegate:nil 
                                                       cancelButtonTitle:nil 
                                                       otherButtonTitles:@"OK", nil] autorelease];
                [alert show];
                [self.tableView reloadData];
            }
        }
    }
}

- (IBAction)buyButtonTapped:(id)sender {
    if (!currentlyConnected) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"No Internet Connection" 
                                                         message:@"Sorry, no connection is available.  An Internet Connection is required to make a purchase."  
                                                        delegate:nil 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"OK", nil] autorelease];
        [alert show];
        [self.tableView reloadData];
    } else {
        if ([[InAppStore defaultStore] canMakePurchases]) {
            MAConfirmButton *buyButton = (MAConfirmButton *)sender;    
            SKProduct *product = [[InAppStore defaultStore].products objectAtIndex:buyButton.tag];            
            [[InAppStore defaultStore] buyProduct:product];
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            self.hud.labelText = [NSString stringWithFormat:@"Buying %@ ...", product.localizedTitle];
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:60];            
        } else {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Unauthorised Purchase" 
                                                             message:@"This device is currently blocked from making In-App purchases.  The owner can change this in Settings (General - Restrictions)"  
                                                            delegate:nil 
                                                   cancelButtonTitle:nil 
                                                   otherButtonTitles:@"OK", nil] autorelease];
            [alert show];
            [self.tableView reloadData];
        }
    }
}

- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];    
    [self.tableView reloadData];    
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;    
    if (transaction.error.code != SKErrorPaymentCancelled) {    
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!" 
                                                         message:transaction.error.localizedDescription 
                                                        delegate:nil 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
    } 
}

- (void)restorePurchasesFailed:(NSNotification *)notification 
{    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    NSError *error = (NSError *) notification.object;    
    if (error.code != SKErrorPaymentCancelled) {    
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Restore Failed" 
                                                         message:error.localizedDescription
                                                        delegate:nil 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
    } 
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    if (section == 0) {
        if (currentlyConnected) {
            return nil;
        } else {
            if ([InAppStore defaultStore].products == nil) {
                return @"No Internet Connection available.  No Product information can be retrieved until a connection is available.";
            } else {
                NSUInteger productCount = [[InAppStore defaultStore].products count];
                NSUInteger purchaseCount = [[InAppStore defaultStore].purchasedProducts count];
                if (purchaseCount < productCount) {
                    return @"No Internet Connection available.  You will not be able to make any in-app purchases until a connection is available";                                
                } else {
                    return nil;
                }
            }
        }         
    } else {
        return nil;
    }
}

@end
