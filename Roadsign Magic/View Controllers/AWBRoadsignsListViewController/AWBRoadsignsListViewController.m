//
//  AWBRoadsignsListViewController.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 23/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignsListViewController.h"
#import "FileHelpers.h"
#import "AWBRoadsignMagicMainViewController.h"
#import "AWBRoadsignDescriptor.h"
#import "AWBRoadsignStore.h"
#import "AWBSettingsGroup.h"
#import "AWBSizeableImageTableCell.h"

@implementation AWBRoadsignsListViewController

@synthesize theTableView;
@synthesize dataSources;
@synthesize busyView;
@synthesize selectedDataSource;

// this is the custom initialization method for the ElementsTableViewController
// it expects an object that conforms to both the UITableViewDataSource protocol
// which provides data to the tableview, and the ElementDataSource protocol which
// provides information about the elements data that is displayed,
//- (id)initWithDataSource:(id <UITableViewDataSource, UITableViewDelegate, AWBRoadsignDataSource>)theDataSource 
//{
//	if ([self init]) {
//		theTableView = nil;
//		
//		// retain the data source
//		self.dataSource = theDataSource;
//        self.dataSource.parentViewController = self;
//        
//        // Custom initialization
//        scrollToRow = -1;
//        //self.navigationItem.title = @"My Signs";
//        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRoadsignDescriptor:)];
//        [[self navigationItem] setRightBarButtonItem:addButton];
//        [addButton release];
//        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
//	}
//	return self;
//}

- (id)initWithDataSources:(NSArray *)theDataSources 
{
	if ([self init]) {
		theTableView = nil;
		
		// retain the data source
		self.dataSources = theDataSources;
        for (id <UITableViewDataSource, UITableViewDelegate, AWBRoadsignDataSource> dataSource in self.dataSources) {
            dataSource.parentViewController = self;
        }
        selectedDataSource = 0;
        
        // Custom initialization
        scrollToRow = -1;
        self.navigationItem.title = @"My Signs";
//        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRoadsignDescriptor:)];
//        [[self navigationItem] setRightBarButtonItem:addButton];
//        [addButton release];
//        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
	}
	return self;
}

- (void)dealloc {
	theTableView.delegate = nil;
	theTableView.dataSource = nil;
	[theTableView release];
	[dataSources release];
    [busyView release];
	[super dealloc];
}

- (void)loadView {
	
	// create a new table using the full application frame
	// we'll ask the datasource which type of table to use (plain or grouped)
	UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
														  style:UITableViewStyleGrouped];
	
	// set the autoresizing mask so that the table will always fill the view
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
		
	// set the tableview delegate to this object and the datasource to the datasource which has already been set
	tableView.delegate = [dataSources objectAtIndex:selectedDataSource];
	tableView.dataSource = [dataSources objectAtIndex:selectedDataSource];
	
	// set the tableview as the controller view
    self.theTableView = tableView;
	self.view = tableView;
	[tableView release];
    
    [self addTitleView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (DEVICE_IS_IPAD) {
        theTableView.rowHeight = 212;
    } else {
        theTableView.rowHeight = 100;    
    } 
}

- (void)viewDidUnload
{
    self.busyView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    //    [self addToolbar];
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:kAWBInfoKeyMyRoadsignStoreRoadsignIndex];
    UISegmentedControl *datasourceControl = (UISegmentedControl *)self.navigationItem.titleView;
    if (datasourceControl.selectedSegmentIndex == 0) {
        [theTableView reloadData];
    } else {
        datasourceControl.selectedSegmentIndex = 0;        
    }    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    
    scrollToRow = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyScrollToRoadsignStoreMyRoadsignIndex];
    if (scrollToRow >= 0) {
        @try {
            [theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollToRow inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        @catch (NSException *e) {
            NSLog(@"%@", [e reason]);
        }
        @finally {
            scrollToRow = -1;
        }
    } 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[AWBRoadsignStore defaultStore] saveMyRoadsigns];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated    
{
    [super setEditing:editing animated:animated];
    [theTableView setEditing:editing animated:animated];
}

- (void)addNewRoadsignDescriptor:(id)sender
{
    [self setEditing:NO animated:YES];
    NSString *nextDefaultRoadsignName = [[AWBRoadsignStore defaultStore] nextDefaultRoadsignName];
    NSMutableDictionary *settingsInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:nextDefaultRoadsignName, kAWBInfoKeyRoadsignName, [NSNumber numberWithBool:YES], kAWBInfoKeyRoadsignUseBackgroundTexture, @"Metal", kAWBInfoKeyRoadsignBackgroundTexture, [UIColor yellowSignBackgroundColor], kAWBInfoKeyRoadsignBackgroundColor, nil];
    AWBRoadsignMagicSettingsTableViewController *settingsController = [[AWBRoadsignMagicSettingsTableViewController alloc] initWithSettings:[AWBSettings createRoadsignSettingsWithInfo:settingsInfo] settingsInfo:settingsInfo rootController:nil]; 
    settingsController.delegate = self;
    settingsController.controllerType = AWBSettingsControllerTypeNewRoadsignSettings;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;  
    [self presentModalViewController:navController animated:YES];
    [settingsController release];   
    [navController release];
}

- (void)loadRoadsignAtIndexPath:(NSIndexPath *)indexPath withSettingsInfo:(NSDictionary *)info
{
    AWBRoadsignDescriptor *roadsign = [[[AWBRoadsignStore defaultStore] myRoadsigns] objectAtIndex:[indexPath row]];
    AWBRoadsignMagicMainViewController *roadsignController = [[[AWBRoadsignMagicMainViewController alloc] initWithRoadsignDescriptor:roadsign] autorelease];  
    
    if (info) {
        roadsignController.useBackgroundTexture = [[info objectForKey:kAWBInfoKeyRoadsignUseBackgroundTexture] boolValue];
        roadsignController.roadsignBackgroundTexture = [info objectForKey:kAWBInfoKeyRoadsignBackgroundTexture];
        roadsignController.roadsignBackgroundColor = [info objectForKey:kAWBInfoKeyRoadsignBackgroundColor];
    }
    
    //first transition animation - if there's more than 15 objects then don't animate the transition
    animateTransition = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] forKey:kAWBInfoKeyScrollToRoadsignStoreMyRoadsignIndex]; 
    if (roadsign.totalObjects > 15) {
        animateTransition = NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] forKey:kAWBInfoKeyMyRoadsignStoreRoadsignIndex]; 
    }
    
    //secondly - load progress busy indicator.  Only enable if there are some symbols or text to load   
    if (roadsign.totalObjects > 0) {
        NSString *objectString;
        if (roadsign.totalObjects == 1) {
            objectString = @"object";
        } else {
            objectString = @"objects";
        }
        NSString *busyTextDetail = [NSString stringWithFormat:@"(with %d %@)", roadsign.totalObjects, objectString];
        AWBBusyView *busyIndicatorView = [[AWBBusyView alloc] initWithText:@"Preparing Roadsign" detailText:busyTextDetail parentView:self.view centerAtPoint:[self centerOfVisibleRows]];
        [self performSelector:@selector(navigateToRoadsignController:) withObject:roadsignController afterDelay:0];
        self.busyView = busyIndicatorView;
        [busyIndicatorView release];
    } else {
        [self.navigationController pushViewController:roadsignController animated:animateTransition];
    }
}

- (CGPoint)centerOfVisibleRows
{
    CGPoint center = CGPointZero;
    NSArray *rowPaths = [theTableView indexPathsForVisibleRows];
    if (rowPaths && ([rowPaths count] > 0)) {
        CGRect topRect = [theTableView rectForRowAtIndexPath:[rowPaths objectAtIndex:0]];
        CGRect bottomRect = [theTableView rectForRowAtIndexPath:[rowPaths objectAtIndex:([rowPaths count]-1)]];
        CGPoint topLeft = topRect.origin;
        CGPoint bottomRight = CGPointMake(bottomRect.origin.x + bottomRect.size.width, bottomRect.origin.y + bottomRect.size.height);
        CGFloat totalWidth = bottomRight.x - topLeft.x;
        CGFloat totalHeight = bottomRight.y - topLeft.y;
        center = CGPointMake(topLeft.x + (totalWidth/2.0), topLeft.y + (totalHeight/2.0));
    } else {
        NSLog(@"No Visible Rows!");
    }
    return center;
}

- (void)navigateToRoadsignController:(AWBRoadsignMagicMainViewController *)roadsignController
{
    [self.navigationController pushViewController:roadsignController animated:animateTransition];
    [self.busyView removeFromParentView];
    self.busyView = nil;
}

- (void)awbRoadsignMagicSettingsTableViewController:(AWBRoadsignMagicSettingsTableViewController *)settingsController didFinishSettingsWithInfo:(NSDictionary *)info
{
    if ((settingsController.controllerType == AWBSettingsControllerTypeNewRoadsignSettings) || !settingsController) {
        AWBRoadsignDescriptor *roadsign = [[AWBRoadsignStore defaultStore] createMyRoadsign]; 
        roadsign.roadsignName = [info objectForKey:kAWBInfoKeyRoadsignName];
        NSUInteger totalRoadsignCount = [[[AWBRoadsignStore defaultStore] myRoadsigns] count];
        if (totalRoadsignCount > 0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(totalRoadsignCount - 1) inSection:0];
            [self loadRoadsignAtIndexPath:scrollIndexPath withSettingsInfo:info];            
        }
    } else if (settingsController.controllerType == AWBSettingsControllerTypeRoadsignInfoSettings) {
        NSUInteger roadsignStoreIndex = [[info objectForKey:kAWBInfoKeyMyRoadsignStoreRoadsignIndex] intValue];
        if (roadsignStoreIndex < [[[AWBRoadsignStore defaultStore] myRoadsigns] count]) {
            AWBRoadsignDescriptor *roadsign = [[[AWBRoadsignStore defaultStore] myRoadsigns] objectAtIndex:roadsignStoreIndex]; 
            roadsign.roadsignName = [info objectForKey:kAWBInfoKeyRoadsignName];
            [[AWBRoadsignStore defaultStore] saveMyRoadsigns];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:roadsignStoreIndex inSection:0];
            [theTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone]; 
        }
    }
}

- (void)addTitleView
{
    NSArray *segItemsArray = [NSArray arrayWithObjects: @"My Signs", @"Templates", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segItemsArray];
    segmentedControl.frame = CGRectMake(0, 0, 170, self.navigationController.navigationBar.bounds.size.height - 14);
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = selectedDataSource;
    [segmentedControl addTarget:self action:@selector(switchDatasource:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl release];
}

- (void)switchDatasource:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSLog(@"Selected Index: %d", segmentedControl.selectedSegmentIndex);
    [self switchDatasourceWithSelectedIndex:segmentedControl.selectedSegmentIndex];
}

- (void)switchDatasourceWithSelectedIndex:(NSUInteger)selectedIndex
{
    selectedDataSource = selectedIndex;
    if (selectedDataSource == 0) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRoadsignDescriptor:)];
        [[self navigationItem] setRightBarButtonItem:addButton];
        [addButton release];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];        
    } else {
        [[self navigationItem] setRightBarButtonItem:nil];
        [[self navigationItem] setLeftBarButtonItem:nil];                
    }
    theTableView.delegate = [dataSources objectAtIndex:selectedDataSource];
    theTableView.dataSource = [dataSources objectAtIndex:selectedDataSource];
    [theTableView reloadData];        
}

@end

