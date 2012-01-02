//
//  AWBRoadsignsListViewController.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/12/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBMyFontsListViewController.h"
#import "FileHelpers.h"
#import "AWBMyFontStore.h"
#import "AWBSettingsGroup.h"

@implementation AWBMyFontsListViewController

@synthesize theTableView, pendingMyFontInstall, pendingMyFontInstallURL, installMyFontAlertView;

- (void)initialise
{
    self.navigationItem.title = @"My Fonts";
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];    
}

- (id)init
{    
    self = [super init];
    if (self) {
        // Custom initialization
        [self initialise];
    }
    return self;
}

- (void)loadView {
	
	// create a new table using the full application frame
	// we'll ask the datasource which type of table to use (plain or grouped)
	UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
														  style:UITableViewStyleGrouped];
	
	// set the autoresizing mask so that the table will always fill the view
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    tableView.allowsSelection = NO;
    tableView.allowsSelectionDuringEditing = NO;
    
	// set the tableview delegate to this object and the datasource to the datasource which has already been set
	tableView.delegate = self;
	tableView.dataSource = self;
	
	// set the tableview as the controller view
    self.theTableView = tableView;
	self.view = tableView;
	[tableView release];    
}

- (void)dealloc 
{
	theTableView.delegate = nil;
	theTableView.dataSource = nil;
	[theTableView release];
    [pendingMyFontInstallURL release];
    [installMyFontAlertView release];
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if (DEVICE_IS_IPAD) {
//        [self tableView].rowHeight = 212;
//    } else {
        self.theTableView.rowHeight = 70;    
//    } 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
//    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:kAWBInfoKeyMyRoadsignStoreRoadsignIndex];
    [self.theTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (pendingMyFontInstall) {
        pendingMyFontInstall = NO;
        [self attemptMyFontInstall];
    }
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[AWBMyFontStore defaultStore] saveAllMyFonts];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[AWBMyFontStore defaultStore] allMyFonts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyFontCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AWBMyFont *myFont = [[[AWBMyFontStore defaultStore] allMyFonts] objectAtIndex:[indexPath row]];
    cell.textLabel.text = myFont.fontName;
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Family: %@\r\nInstalled: %@", myFont.familyName, AWBDateStringForCurrentLocale(myFont.createdDate)];        
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        AWBMyFontStore *fs = [AWBMyFontStore defaultStore];
        NSUInteger myFontCountBeforeDelete = [[fs allMyFonts] count];
        NSArray *myFonts = [fs allMyFonts];
        AWBMyFont *myFont = [myFonts objectAtIndex:[indexPath row]];
        [fs removeMyFont:myFont];
        [fs saveAllMyFonts];
        NSUInteger myFontCountAfterDelete = [[fs allMyFonts] count];
        
        // We also remove that row from the table view with an animation
        if ((myFontCountBeforeDelete - myFontCountAfterDelete) == 1) {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:YES];
        }
        
        if (myFontCountAfterDelete == 0) {
            [self.theTableView reloadData];
        }        
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
    [[AWBMyFontStore defaultStore] moveMyFontAtIndex:[fromIndexPath row] toIndex:[toIndexPath row]];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    NSUInteger totalMyFontCount = [[[AWBMyFontStore defaultStore] allMyFonts] count];
    if (totalMyFontCount > 0) {
        self.navigationItem.rightBarButtonItem = [self editButtonItem];
        return nil;
    } else {
        [self setEditing:NO];
        self.navigationItem.rightBarButtonItem = nil;
        return @"There are no MyFonts installed.  You can install TrueType and OpenType fonts by opening them from apps such as Mail and Safari.";
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath  
{
    [self setEditing:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [self setEditing:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath    
{
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
}

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

- (void)attemptMyFontInstall
{
    //need a URL
    if (self.pendingMyFontInstallURL) {
        pendingMyFont = [[AWBMyFont alloc] initWithUrl:pendingMyFontInstallURL];
        if (pendingMyFont) {
            [self confirmMyFontInstall:pendingMyFont.fontName];
//            NSLog(@"Font: %@ %@ %@ %@ %@ %@ %d", myFont.familyName, myFont.fontName, myFont.postScriptName, myFont.filename, myFont.fileUrl, myFont.createdDate, myFont.fileSizeBytes);
//            BOOL success = [[AWBMyFontStore defaultStore] installMyFont:myFont];
//            if (success) {
//                NSLog(@"Installed Font: %@ %@ %@ %@ %@ %@ %d", myFont.familyName, myFont.fontName, myFont.postScriptName, myFont.filename, myFont.fileUrl, myFont.createdDate, myFont.fileSizeBytes);
//            }
        } else {
            NSLog(@"No Font loaded!");
            NSString *path = [pendingMyFontInstallURL path];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            [self showFontInstallError:path.lastPathComponent];
        }
    }
}

- (void)showFontInstallError:(NSString *)filename
{
    NSString *message = [NSString stringWithFormat:@"%@ was invalid and could not be installed", filename];
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Install Failed" 
                              message:message 
                              delegate:self 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [alertView release];       
}

- (void)confirmMyFontInstall:(NSString *)fontName
{
    NSString *message = [NSString stringWithFormat:@"Do you want to install the font, %@ ?", fontName];
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Install Font?" 
                              message:message 
                              delegate:self 
                              cancelButtonTitle:@"No" 
                              otherButtonTitles:@"Yes", 
                              nil];
    self.installMyFontAlertView = alertView;
    [self.installMyFontAlertView show];
    [alertView release];   
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == self.installMyFontAlertView) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            NSLog(@"Install the font!");
            [[AWBMyFontStore defaultStore] installMyFont:pendingMyFont];
            [self.theTableView reloadData];
        } else {
            NSLog(@"Installation of font cancelled");
            [pendingMyFont removeFromFileSystem];
        }
    }
    self.installMyFontAlertView = nil;
    self.pendingMyFontInstallURL = nil;
    [pendingMyFont release];
}

@end

