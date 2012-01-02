////
////  AWBRoadsignsListViewController.m
////  Roadsign Magic
////
////  Created by Adam Buckley on 05/12/2011.
////  Copyright (c) 2011 happyadam development. All rights reserved.
////
//
//#import "AWBMyRoadsignsListViewController.h"
//#import "FileHelpers.h"
//#import "AWBRoadsignMagicMainViewController.h"
//#import "AWBRoadsignDescriptor.h"
//#import "AWBRoadsignStore.h"
//#import "AWBSettingsGroup.h"
//#import "AWBSizeableImageTableCell.h"
//
//@implementation AWBMyRoadsignsListViewController
//
//@synthesize busyView;
//
//- (id)init
//{    
//    self = [super initWithStyle:UITableViewStyleGrouped];
//    if (self) {
//        // Custom initialization
//        scrollToRow = -1;
//        self.navigationItem.title = @"My Signs";
//        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRoadsignDescriptor:)];
//        [[self navigationItem] setRightBarButtonItem:addButton];
//        [addButton release];
//        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
//    }
//    return self;
//}
//
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    return [self init];
//}
//
//- (void)dealloc
//{
//    [busyView release];
//    [super dealloc];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//}
//
//#pragma mark - View lifecycle
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    if (DEVICE_IS_IPAD) {
//        [self tableView].rowHeight = 212;
//    } else {
//        [self tableView].rowHeight = 100;    
//    } 
//}
//
//- (void)viewDidUnload
//{
//    self.busyView = nil;
//    [super viewDidUnload];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setToolbarHidden:YES animated:YES];
////    [self addToolbar];
//    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:kAWBInfoKeyMyRoadsignStoreRoadsignIndex];
//    [[self tableView] reloadData];
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self becomeFirstResponder];
//    
//    scrollToRow = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyScrollToRoadsignStoreMyRoadsignIndex];
//    if (scrollToRow >= 0) {
//        @try {
//            [[self tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollToRow inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        }
//        @catch (NSException *e) {
//            NSLog(@"%@", [e reason]);
//        }
//        @finally {
//            scrollToRow = -1;
//        }
//    } 
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [[AWBRoadsignStore defaultStore] saveMyRoadsigns];
//    [super viewWillDisappear:animated];
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return YES;
//}
//
//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return [[[AWBRoadsignStore defaultStore] myRoadsigns] count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"RoadsignDescriptorCell";
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[AWBSizeableImageTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
//    }
//    
//    AWBRoadsignDescriptor *roadsign = [[[AWBRoadsignStore defaultStore] myRoadsigns] objectAtIndex:[indexPath row]];
//    NSString *subDir = roadsign.roadsignSaveDocumentsSubdirectory;
//    
//    if (roadsign.roadsignName && ([roadsign.roadsignName length] > 0)) {
//        cell.textLabel.text = [NSString stringWithFormat:@"%@", roadsign.roadsignName];
//    } else {
//        cell.textLabel.text = [NSString stringWithFormat:@"%@", subDir];
//    }
//    
//    UIImage *thumbnail = [UIImage imageWithContentsOfFile:AWBPathInDocumentSubdirectory(subDir, @"thumbnail.png")];
//    
//    cell.imageView.image = thumbnail;
//    cell.detailTextLabel.numberOfLines = 2;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Created %@\r\nUpdated %@", AWBDateStringForCurrentLocale(roadsign.createdDate), AWBDocumentSubdirectoryModifiedDate(subDir)];        
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
//{
//    // If the table view is asking to commit a delete command...
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        AWBRoadsignStore *rs = [AWBRoadsignStore defaultStore];
//        NSUInteger roadsignCountBeforeDelete = [[rs myRoadsigns] count];
//        NSArray *roadsigns = [rs myRoadsigns];
//        AWBRoadsignDescriptor *roadsign = [roadsigns objectAtIndex:[indexPath row]];
//        [rs removeMyRoadsign:roadsign];
//        [[AWBRoadsignStore defaultStore] saveMyRoadsigns];
//        NSUInteger roadsignCountAfterDelete = [[[AWBRoadsignStore defaultStore] myRoadsigns] count];
//        
//        // We also remove that row from the table view with an animation
//        if ((roadsignCountBeforeDelete - roadsignCountAfterDelete) == 1) {
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                             withRowAnimation:YES];
//        }
//        
//        if (roadsignCountAfterDelete == 0) {
//            [self.tableView reloadData];
//        }        
//    }
//}
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
//{
//    [[AWBRoadsignStore defaultStore] moveMyRoadsignAtIndex:[fromIndexPath row] toIndex:[toIndexPath row]];
//}
//
//- (CGFloat)borderThickness
//{
//    if (DEVICE_IS_IPAD) {
//        return 6.0;
//    } else {
//        return 3.0;    
//    }    
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
//{
//    NSUInteger totalRoadsignCount = [[[AWBRoadsignStore defaultStore] myRoadsigns] count];
//    if (totalRoadsignCount > 0) {
//        self.navigationItem.leftBarButtonItem = [self editButtonItem];
//        return @"Click the + button to create a new roadsign.";
//    } else {
//        [self setEditing:NO];
//        self.navigationItem.leftBarButtonItem = nil;
//        return @"There are no saved roadsigns.  Click the + button to create a new roadsign.";
//    }
//}
//
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self loadRoadsignAtIndexPath:indexPath withSettingsInfo:nil];
//}
//
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath    
//{
//    AWBRoadsignDescriptor *roadsign = [[[AWBRoadsignStore defaultStore] myRoadsigns] objectAtIndex:[indexPath row]];
//    NSUInteger totalDiskBytes = AWBDocumentSubdirectoryFolderSize(roadsign.roadsignSaveDocumentsSubdirectory);
//    [[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] forKey:kAWBInfoKeyScrollToRoadsignStoreMyRoadsignIndex]; 
//    
//    NSMutableDictionary *settingsInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:roadsign.roadsignName, kAWBInfoKeyRoadsignName, [NSNumber numberWithInt:roadsign.totalSymbolObjects], kAWBInfoKeyRoadsignTotalImageObjects, [NSNumber numberWithInt:roadsign.totalLabelObjects], kAWBInfoKeyRoadsignTotalLabelObjects, [NSNumber numberWithInt:[indexPath row]], kAWBInfoKeyMyRoadsignStoreRoadsignIndex, [NSNumber numberWithInt:roadsign.totalImageMemoryBytes], kAWBInfoKeyRoadsignTotalImageMemoryBytes, [NSNumber numberWithInt:totalDiskBytes], kAWBInfoKeyRoadsignTotalDiskBytes, nil];
//    AWBRoadsignMagicSettingsTableViewController *settingsController = [[AWBRoadsignMagicSettingsTableViewController alloc] initWithSettings:[AWBSettings roadsignDescriptionSettingsWithInfo:settingsInfo header:[roadsign roadsignInfoHeaderView]] settingsInfo:settingsInfo rootController:nil]; 
//    settingsController.delegate = self;
//    settingsController.controllerType = AWBSettingsControllerTypeRoadsignInfoSettings;
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
//    navController.modalPresentationStyle = UIModalPresentationPageSheet;
//    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;  
//    [self presentModalViewController:navController animated:YES];
//    [settingsController release];   
//    [navController release];
//}
//
//- (void)loadRoadsignAtIndexPath:(NSIndexPath *)indexPath withSettingsInfo:(NSDictionary *)info
//{
//    AWBRoadsignDescriptor *roadsign = [[[AWBRoadsignStore defaultStore] myRoadsigns] objectAtIndex:[indexPath row]];
//    AWBRoadsignMagicMainViewController *roadsignController = [[[AWBRoadsignMagicMainViewController alloc] initWithRoadsignDescriptor:roadsign] autorelease];  
//    
//    if (info) {
//        roadsignController.useBackgroundTexture = [[info objectForKey:kAWBInfoKeyRoadsignUseBackgroundTexture] boolValue];
//        roadsignController.roadsignBackgroundTexture = [info objectForKey:kAWBInfoKeyRoadsignBackgroundTexture];
//        roadsignController.roadsignBackgroundColor = [info objectForKey:kAWBInfoKeyRoadsignBackgroundColor];
//    }
//    
//    //first transition animation - if there's more than 15 objects then don't animate the transition
//    animateTransition = YES;
//    [[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] forKey:kAWBInfoKeyScrollToRoadsignStoreMyRoadsignIndex]; 
//    if (roadsign.totalObjects > 15) {
//        animateTransition = NO;
//    } else {
//        [[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] forKey:kAWBInfoKeyMyRoadsignStoreRoadsignIndex]; 
//    }
//    
//    //secondly - load progress busy indicator.  Only enable if there are some symbols or text to load   
//    if (roadsign.totalObjects > 0) {
//        NSString *objectString;
//        if (roadsign.totalObjects == 1) {
//            objectString = @"object";
//        } else {
//            objectString = @"objects";
//        }
//        NSString *busyTextDetail = [NSString stringWithFormat:@"(with %d %@)", roadsign.totalObjects, objectString];
//        AWBBusyView *busyIndicatorView = [[AWBBusyView alloc] initWithText:@"Preparing Roadsign" detailText:busyTextDetail parentView:self.view centerAtPoint:[self centerOfVisibleRows]];
//        [self performSelector:@selector(navigateToRoadsignController:) withObject:roadsignController afterDelay:0];
//        self.busyView = busyIndicatorView;
//        [busyIndicatorView release];
//    } else {
//        [self.navigationController pushViewController:roadsignController animated:animateTransition];
//    }
//}
//
//- (CGPoint)centerOfVisibleRows
//{
//    CGPoint center = CGPointZero;
//    NSArray *rowPaths = [self.tableView indexPathsForVisibleRows];
//    if (rowPaths && ([rowPaths count] > 0)) {
//        CGRect topRect = [self.tableView rectForRowAtIndexPath:[rowPaths objectAtIndex:0]];
//        CGRect bottomRect = [self.tableView rectForRowAtIndexPath:[rowPaths objectAtIndex:([rowPaths count]-1)]];
//        CGPoint topLeft = topRect.origin;
//        CGPoint bottomRight = CGPointMake(bottomRect.origin.x + bottomRect.size.width, bottomRect.origin.y + bottomRect.size.height);
//        CGFloat totalWidth = bottomRight.x - topLeft.x;
//        CGFloat totalHeight = bottomRight.y - topLeft.y;
//        center = CGPointMake(topLeft.x + (totalWidth/2.0), topLeft.y + (totalHeight/2.0));
//    } else {
//        NSLog(@"No Visible Rows!");
//    }
//    return center;
//}
//
//- (void)navigateToRoadsignController:(AWBRoadsignMagicMainViewController *)roadsignController
//{
//    [self.navigationController pushViewController:roadsignController animated:animateTransition];
//    [self.busyView removeFromParentView];
//    self.busyView = nil;
//}
//
//- (void)addNewRoadsignDescriptor:(id)sender
//{
//    [self setEditing:NO animated:YES];
//    NSString *nextDefaultRoadsignName = [[AWBRoadsignStore defaultStore] nextDefaultRoadsignName];
//    NSMutableDictionary *settingsInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:nextDefaultRoadsignName, kAWBInfoKeyRoadsignName, [NSNumber numberWithBool:YES], kAWBInfoKeyRoadsignUseBackgroundTexture, @"Metal", kAWBInfoKeyRoadsignBackgroundTexture, [UIColor yellowSignBackgroundColor], kAWBInfoKeyRoadsignBackgroundColor, nil];
//    AWBRoadsignMagicSettingsTableViewController *settingsController = [[AWBRoadsignMagicSettingsTableViewController alloc] initWithSettings:[AWBSettings createRoadsignSettingsWithInfo:settingsInfo] settingsInfo:settingsInfo rootController:nil]; 
//    settingsController.delegate = self;
//    settingsController.controllerType = AWBSettingsControllerTypeNewRoadsignSettings;
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
//    navController.modalPresentationStyle = UIModalPresentationPageSheet;
//    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;  
//    [self presentModalViewController:navController animated:YES];
//    [settingsController release];   
//    [navController release];
//}
//
//- (void)awbRoadsignMagicSettingsTableViewController:(AWBRoadsignMagicSettingsTableViewController *)settingsController didFinishSettingsWithInfo:(NSDictionary *)info
//{
//    if ((settingsController.controllerType == AWBSettingsControllerTypeNewRoadsignSettings) || !settingsController) {
//        AWBRoadsignDescriptor *roadsign = [[AWBRoadsignStore defaultStore] createMyRoadsign]; 
//        roadsign.roadsignName = [info objectForKey:kAWBInfoKeyRoadsignName];
//        NSUInteger totalRoadsignCount = [[[AWBRoadsignStore defaultStore] myRoadsigns] count];
//        if (totalRoadsignCount > 0) {
//            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(totalRoadsignCount - 1) inSection:0];
//            [self loadRoadsignAtIndexPath:scrollIndexPath withSettingsInfo:info];            
//        }
//    } else if (settingsController.controllerType == AWBSettingsControllerTypeRoadsignInfoSettings) {
//        NSUInteger roadsignStoreIndex = [[info objectForKey:kAWBInfoKeyMyRoadsignStoreRoadsignIndex] intValue];
//        if (roadsignStoreIndex < [[[AWBRoadsignStore defaultStore] myRoadsigns] count]) {
//            AWBRoadsignDescriptor *roadsign = [[[AWBRoadsignStore defaultStore] myRoadsigns] objectAtIndex:roadsignStoreIndex]; 
//            roadsign.roadsignName = [info objectForKey:kAWBInfoKeyRoadsignName];
//            [[AWBRoadsignStore defaultStore] saveMyRoadsigns];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:roadsignStoreIndex inSection:0];
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone]; 
//        }
//    }
//}
//
//- (void)addToolbar
//{
//    NSArray *segItemsArray = [NSArray arrayWithObjects: @"My Signs", @"Examples", @"Store", nil];
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segItemsArray];
//    segmentedControl.frame = CGRectMake(0, 0, 300, (self.navigationController.toolbar.bounds.size.height - 10));
//    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//    segmentedControl.selectedSegmentIndex = 0;
//    UIBarButtonItem *segmentedControlButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)segmentedControl];
//    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    NSArray *barArray = [NSArray arrayWithObjects: flexibleSpace, segmentedControlButtonItem, flexibleSpace, nil];
//    [self setToolbarItems:barArray];
//    [segmentedControlButtonItem release];
//    [flexibleSpace release];
//    [segmentedControl release];
//    self.navigationController.toolbarHidden = NO;
//}
//
//@end
//
