//
//  AWBRoadsignMagicSettingsTableViewController.m
//  RoadsignMagic
//
//  Created by Adam Buckley on 05/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicSettingsTableViewController.h"
#import "AWBSettingTableCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AWBRoadsignMagicStoreViewController.h"

@implementation AWBRoadsignMagicSettingsTableViewController

@synthesize delegate, settings, isRootController, controllerType;
@synthesize settingsInfo, parentSettingsController, forceReload, dismissAndGoToAppStore;

- (id)initWithSettings:(AWBSettings *)aSettings settingsInfo:(NSMutableDictionary *)aSettingsInfo rootController:(AWBRoadsignMagicSettingsTableViewController *)rootController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self setSettings:aSettings];
        self.settings.delegate = self;
        [self setSettingsInfo:aSettingsInfo];
        parentSettingsController = rootController;
        forceReload = NO;
        if (!parentSettingsController) {
            isRootController = YES;
        } else {
            isRootController = NO;
        }
    }
    return self;       
}

- (id)init
{
    return [self initWithSettings:[AWBSettings mainSettingsWithInfo:nil] settingsInfo:nil rootController:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self initWithSettings:[AWBSettings mainSettingsWithInfo:nil] settingsInfo:nil rootController:nil];
}

- (void)dealloc
{
    [settings setDelegate:nil]; 
    [settings release];
    [settingsInfo release];
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

    if (DEVICE_IS_IPAD) {
        [self setContentSizeForViewInPopover:CGSizeMake(480, 550)];        
    }

    if (isRootController) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishSettingsWithInfo:)];
        self.navigationItem.rightBarButtonItem = doneButton; 
        [doneButton release];
        
        if (self.controllerType != AWBSettingsControllerTypeHelpSettings) {
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissSettings:)];
            self.navigationItem.leftBarButtonItem = cancelButton;
            [cancelButton release];
        }
    }
    
    if (settings.headerView) {
        self.tableView.autoresizesSubviews = YES;
        self.tableView.tableHeaderView = settings.headerView;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    self.navigationController.toolbar.translucent = YES;

    if (self.dismissAndGoToAppStore) {
        [self finishSettingsWithInfo:self]; 
    } else if (forceReload) {
        forceReload = NO;
        [self.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationItem.title = settings.settingsTitle;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([currentlyEditingCellTextField isFirstResponder]) {
        [currentlyEditingCellTextField resignFirstResponder];
    }
    
    //OK if this a non-root controller, then merge the current settings info and then merge with the parent
    if (parentSettingsController) {
        [[self settingsInfo] addEntriesFromDictionary:[self.settings infoFromSettings]];
        [[parentSettingsController settingsInfo] addEntriesFromDictionary:[self settingsInfo]];
        parentSettingsController.forceReload = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{  
    return [settings.visibleSettingsGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AWBSettingsGroup *settingsGroup = [settings.visibleSettingsGroups objectAtIndex:section];
    return [settingsGroup.visibleSettings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AWBSettingsGroup *settingsGroup = [settings.visibleSettingsGroups objectAtIndex:[indexPath section]];
    AWBSetting *setting = [settingsGroup.visibleSettings objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = nil;
    if (setting) {
        cell = [tableView dequeueReusableCellWithIdentifier:setting.cellReuseIdentifier];
        if (cell == nil) {
            cell = [setting settingTableCell];
        }
        [cell updateCellWithSetting:setting];
        
        if ([cell cellControl]) {
            [[cell cellControl] addTarget:self action:@selector(cellSelectedOrCellControlValueChanged:) forControlEvents:UIControlEventValueChanged];        
        }
        
        if ([cell cellTextField]) {
            [[cell cellTextField] setDelegate:self];
        }
        
        if (settingsGroup.isMutuallyExclusive) {
            if ([indexPath row]==settingsGroup.selectedIndex) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;        
            }  
        }        
    }
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MissingSettingCell"] autorelease];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AWBSettingsGroup *settingsGroup = [settings.visibleSettingsGroups objectAtIndex:[indexPath section]];    
    
    if (settingsGroup.isMutuallyExclusive) {
        [aTableView deselectRowAtIndexPath:indexPath animated:YES];
        settingsGroup.selectedIndex = [indexPath row];
        [aTableView reloadData];  
    } else {
        AWBSetting *setting = [settingsGroup.visibleSettings objectAtIndex:[indexPath row]];
        if (setting.controlType == AWBSettingControlTypeDrilldown) {
            AWBRoadsignMagicSettingsTableViewController *settingsController = [[AWBRoadsignMagicSettingsTableViewController alloc] initWithSettings:setting.childSettings settingsInfo:[self settingsInfo] rootController:self]; 
            settingsController.delegate = nil;  
            [[self navigationController] pushViewController:settingsController animated:YES];
            [settingsController release];
        } else if (setting.controlType == AWBSettingControlTypeGoToInAppStore) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            parentSettingsController.dismissAndGoToAppStore = YES;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self cellSelectedOrCellControlValueChanged:nil];            
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    AWBSettingsGroup *settingsGroup = [settings.visibleSettingsGroups objectAtIndex:section];
    return settingsGroup.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    AWBSettingsGroup *settingsGroup = [settings.visibleSettingsGroups objectAtIndex:section];
    return settingsGroup.footer;
}

//root controller only
- (void)finishSettingsWithInfo:(id)sender
{
    //first merge root controller's settings with the settings info object and then return this in the delegate
    [[self settingsInfo] addEntriesFromDictionary:[self.settings infoFromSettings]];
    
    if (self.dismissAndGoToAppStore) {
        [self.settingsInfo setObject:[NSNumber numberWithBool:YES] forKey:kAWBInfoKeyGoToInAppStore];
    }
    
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
    if([delegate respondsToSelector:@selector(awbRoadsignMagicSettingsTableViewController:didFinishSettingsWithInfo:)]) {
		[delegate performSelector:@selector(awbRoadsignMagicSettingsTableViewController:didFinishSettingsWithInfo:) withObject:self withObject:self.settingsInfo];
	}    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    CGFloat rowHeight = self.tableView.rowHeight;
    AWBSettingsGroup *settingsGroup = [settings.visibleSettingsGroups objectAtIndex:[indexPath section]];    
    if (DEVICE_IS_IPAD) {
        if (settingsGroup.iPadRowHeight > 10.0) {
            rowHeight = settingsGroup.iPadRowHeight;
        }
    } else {
        if (settingsGroup.iPhoneRowHeight > 10.0) {
            rowHeight = settingsGroup.iPhoneRowHeight;
        }    
    }
    
    CGFloat maxHeight = (tableView.bounds.size.height - 30.0);
    
    if ((maxHeight > 10.0) && (rowHeight > maxHeight)) {
        rowHeight = maxHeight;
    }
        
    return rowHeight;
}

- (void)dismissSettings:(id)sender 
{
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
    if([delegate respondsToSelector:@selector(awbRoadsignMagicSettingsTableViewControllerDidDissmiss:)]) {
		[delegate performSelector:@selector(awbRoadsignMagicSettingsTableViewControllerDidDissmiss:) withObject:self withObject:nil];
	}   
}

- (void)cellSelectedOrCellControlValueChanged:(id)sender
{
    [currentlyEditingCellTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)aTextField   
{
    currentlyEditingCellTextField = aTextField;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)masterSwitchSettingHasChangedValue:(AWBSetting *)setting forSettingsGroup:(AWBSettingsGroup *)settingsGroup
{
    [settingsGroup notifySlaveSettingsOfMasterSwitchSettingValue:setting.isSwitchedOn];
    [self.tableView reloadData];
}

@end
