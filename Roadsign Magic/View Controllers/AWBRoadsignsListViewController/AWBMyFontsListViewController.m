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
#import "AWBRoadsignMagicStoreViewController.h"

@implementation AWBMyFontsListViewController

@synthesize theTableView, pendingMyFontInstall, pendingMyFontInstallURL, installMyFontAlertView, helpButton, toolbarSpacing;

- (void)initialise
{
    self.navigationItem.title = @"My Fonts";
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];    
}

- (id)init
{    
    self = [super init];
    if (self) {
        if (!IS_MYFONTS_PURCHASED) {
            showPurchaseWarning = YES;
        }
        // Custom initialization
        //[self initialise];
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
    [helpButton release];
    [toolbarSpacing release];
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
    NSLog(@"viewWillAppear");
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.toolbarItems = [self myFontsToolbarButtons];
    [self.navigationController setToolbarHidden:NO animated:YES];
    self.navigationItem.title = @"My Fonts";
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];    

    if (!IS_MYFONTS_PURCHASED && showPurchaseWarning) {
        showPurchaseWarning = NO;
        [self showMyFontsNotPurchased];
    }
    
//    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:kAWBInfoKeyMyRoadsignStoreRoadsignIndex];
    [self.theTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");

    [super viewDidAppear:animated];
    
    if (pendingMyFontInstall && IS_MYFONTS_PURCHASED) {
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
    
    NSString *familyName;
    if (myFont.familyName) {
        familyName = myFont.familyName;
    } else {
        familyName = @"N/A";
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Family: %@\r\nInstalled: %@ (%@)", familyName, AWBDateStringForCurrentLocale(myFont.createdDate), AWBFileSizeIntToString(myFont.fileSizeBytes)];        
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
    if (!IS_MYFONTS_PURCHASED) {
        return @"MyFonts is not currently installed.  MyFonts is an in-app purchase available through the In-App Store.  If you have purchased it already, you can also restore your purchase in the In-App Store.";
    } else {
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
    AWBMyFont *myFont = [[[AWBMyFontStore defaultStore] allMyFonts] objectAtIndex:[indexPath row]];
    //[[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] forKey:kAWBInfoKeyScrollToRoadsignStoreMyRoadsignIndex]; 
    
    NSMutableDictionary *settingsInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:myFont.fontName, kAWBInfoKeyMyFontFontName, myFont.fileUrl, kAWBInfoKeyMyFontFileUrl, myFont.filename, kAWBInfoKeyMyFontFilename, myFont.createdDate, kAWBInfoKeyMyFontCreatedDate, [NSNumber numberWithInteger:myFont.fileSizeBytes], kAWBInfoKeyMyFontFileSizeBytes, [NSNumber numberWithInt:[indexPath row]], kAWBInfoKeyMyFontStoreMyFontIndex, nil];
    
    if (myFont.familyName) {
        [settingsInfo setObject:myFont.familyName forKey:kAWBInfoKeyMyFontFamilyName];
    }

    if (myFont.postScriptName) {
        [settingsInfo setObject:myFont.postScriptName forKey:kAWBInfoKeyMyFontPostscriptName];
    }
        
    AWBRoadsignMagicSettingsTableViewController *settingsController = [[AWBRoadsignMagicSettingsTableViewController alloc] initWithSettings:[AWBSettings myFontDescriptionSettingsWithInfo:settingsInfo header:nil] settingsInfo:settingsInfo rootController:nil]; 
    settingsController.delegate = self;
    settingsController.controllerType = AWBSettingsControllerTypeMyFontInfoSettings;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;  
    [self presentModalViewController:navController animated:YES];
    [settingsController release];   
    [navController release];
}


- (void)awbRoadsignMagicSettingsTableViewController:(AWBRoadsignMagicSettingsTableViewController *)settingsController didFinishSettingsWithInfo:(NSDictionary *)info
{
    if (settingsController.controllerType == AWBSettingsControllerTypeMyFontInfoSettings) {
        NSUInteger myFontStoreIndex = [[info objectForKey:kAWBInfoKeyMyFontStoreMyFontIndex] intValue];
        if (myFontStoreIndex < [[[AWBMyFontStore defaultStore] allMyFonts] count]) {
            AWBMyFont *myFont = [[[AWBMyFontStore defaultStore] allMyFonts] objectAtIndex:myFontStoreIndex]; 
            myFont.fontName = [info objectForKey:kAWBInfoKeyMyFontFontName];
            [[AWBMyFontStore defaultStore] saveAllMyFonts];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:myFontStoreIndex inSection:0];
            [self.theTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone]; 
        }
    }
}

- (void)attemptMyFontInstall
{
    //need a URL
    if (self.pendingMyFontInstallURL) {
        pendingMyFont = [[AWBMyFont alloc] initWithUrl:pendingMyFontInstallURL];
        if (pendingMyFont) {
            [self confirmMyFontInstall:pendingMyFont.fontName];
        } else {
            NSString *path = [pendingMyFontInstallURL path];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            [self showFontInstallError:path.lastPathComponent];
        }
    }
}

- (void)showMyFontsNotPurchased
{
    if (pendingMyFontInstall) {
        pendingMyFontInstall = NO;
        NSString *path = [pendingMyFontInstallURL path];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
        
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"MyFonts not installed" 
                              message:@"MyFonts is an in-app purchase available through the In-App Store.  If you have purchased it already, you can also restore your purchase in the In-App Store." 
                              delegate:self 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [alertView release];       
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
    if (!IS_MYFONTS_PURCHASED) {
        NSUInteger viewControllerCount = self.navigationController.viewControllers.count;
        if ((viewControllerCount > 1) && ([[self.navigationController.viewControllers objectAtIndex:(viewControllerCount - 2)] isKindOfClass:[AWBRoadsignMagicStoreViewController class]])) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            AWBRoadsignMagicStoreViewController *storeController = [[AWBRoadsignMagicStoreViewController alloc] init];
            [self.navigationController pushViewController:storeController animated:YES];
            [storeController release];     
        }
    } else {
        if (alertView == self.installMyFontAlertView) {
            if (buttonIndex == alertView.firstOtherButtonIndex) {
                [[AWBMyFontStore defaultStore] installMyFont:pendingMyFont];
                [self.theTableView reloadData];
            } else {
                [pendingMyFont removeFromInbox];
            }
        }
        self.installMyFontAlertView = nil;
        self.pendingMyFontInstallURL = nil;
        [pendingMyFont release];        
    }
}

- (UIBarButtonItem *)helpButton
{
    if (!helpButton) {
        helpButton = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self action:@selector(showHelp)];
    }
    return helpButton;    
}

- (UIBarButtonItem *)toolbarSpacing
{
    if (!toolbarSpacing) {
        toolbarSpacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return toolbarSpacing;    
}

- (void)showHelp
{
    AWBRoadsignMagicSettingsTableViewController *settingsController = [[AWBRoadsignMagicSettingsTableViewController alloc] initWithSettings:[AWBSettings helpSettingsWithFilename:@"MyFonts.rtfd.zip" title:@"MyFonts Help"] settingsInfo:nil rootController:nil]; 
    settingsController.delegate = nil;
    settingsController.controllerType = AWBSettingsControllerTypeMainSettings;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;  
    [self presentModalViewController:navController animated:YES];
    [settingsController release];   
    [navController release];                
}

- (NSArray *)myFontsToolbarButtons
{
    return [NSArray arrayWithObjects:self.toolbarSpacing, self.helpButton, nil];    
}

@end

