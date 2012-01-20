//
//  AWBMyRoadsignsDataSource.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 23/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBMyRoadsignsDataSource.h"
#import "FileHelpers.h"
#import "AWBRoadsignMagicMainViewController.h"
#import "AWBRoadsignDescriptor.h"
#import "AWBRoadsignStore.h"
#import "AWBSettingsGroup.h"
#import "AWBSizeableImageTableCell.h"
#import "AWBRoadsignsListViewController.h"

@implementation AWBMyRoadsignsDataSource

@synthesize parentViewController;

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[AWBRoadsignStore defaultStore] myRoadsigns] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RoadsignDescriptorCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[AWBSizeableImageTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AWBRoadsignDescriptor *roadsign = [[[AWBRoadsignStore defaultStore] myRoadsigns] objectAtIndex:[indexPath row]];
    NSString *subDir = roadsign.roadsignSaveDocumentsSubdirectory;
    
    if (roadsign.roadsignName && ([roadsign.roadsignName length] > 0)) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", roadsign.roadsignName];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", subDir];
    }
    
    UIImage *thumbnail = [UIImage imageWithContentsOfFile:AWBPathInDocumentSubdirectory(subDir, @"thumbnail.png")];
    
    cell.imageView.image = thumbnail;
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Created %@\r\nUpdated %@", AWBDateStringForCurrentLocale(roadsign.createdDate), AWBDocumentSubdirectoryModifiedDate(subDir)];        
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        AWBRoadsignStore *rs = [AWBRoadsignStore defaultStore];
        NSUInteger roadsignCountBeforeDelete = [[rs myRoadsigns] count];
        NSArray *roadsigns = [rs myRoadsigns];
        AWBRoadsignDescriptor *roadsign = [roadsigns objectAtIndex:[indexPath row]];
        [rs removeMyRoadsign:roadsign];
        [[AWBRoadsignStore defaultStore] saveMyRoadsigns];
        NSUInteger roadsignCountAfterDelete = [[[AWBRoadsignStore defaultStore] myRoadsigns] count];
        
        // We also remove that row from the table view with an animation
        if ((roadsignCountBeforeDelete - roadsignCountAfterDelete) == 1) {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:YES];
        }
        
        if (roadsignCountAfterDelete == 0) {
            [tableView reloadData];
        }        
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
    [[AWBRoadsignStore defaultStore] moveMyRoadsignAtIndex:[fromIndexPath row] toIndex:[toIndexPath row]];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    NSUInteger totalRoadsignCount = [[[AWBRoadsignStore defaultStore] myRoadsigns] count];
    if (totalRoadsignCount > 0) {
        parentViewController.navigationItem.leftBarButtonItem = [parentViewController editButtonItem];
        return @"Tap the + button or choose a Template to create a new roadsign.";
    } else {
        [parentViewController setEditing:NO];
        parentViewController.navigationItem.leftBarButtonItem = nil;
        return @"There are no saved roadsigns.  Tap the + button or choose a Template to create a new roadsign.";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [parentViewController loadRoadsignAtIndexPath:indexPath withSettingsInfo:nil];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath    
{
    AWBRoadsignDescriptor *roadsign = [[[AWBRoadsignStore defaultStore] myRoadsigns] objectAtIndex:[indexPath row]];
    NSUInteger totalDiskBytes = AWBDocumentSubdirectoryFolderSize(roadsign.roadsignSaveDocumentsSubdirectory);
    [[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] forKey:kAWBInfoKeyScrollToRoadsignStoreMyRoadsignIndex]; 
    
    NSMutableDictionary *settingsInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:roadsign.roadsignName, kAWBInfoKeyRoadsignName, [NSNumber numberWithInt:roadsign.totalSymbolObjects], kAWBInfoKeyRoadsignTotalImageObjects, [NSNumber numberWithInt:roadsign.totalLabelObjects], kAWBInfoKeyRoadsignTotalLabelObjects, [NSNumber numberWithInt:[indexPath row]], kAWBInfoKeyMyRoadsignStoreRoadsignIndex, [NSNumber numberWithInt:roadsign.totalImageMemoryBytes], kAWBInfoKeyRoadsignTotalImageMemoryBytes, [NSNumber numberWithInt:totalDiskBytes], kAWBInfoKeyRoadsignTotalDiskBytes, nil];
    AWBRoadsignMagicSettingsTableViewController *settingsController = [[AWBRoadsignMagicSettingsTableViewController alloc] initWithSettings:[AWBSettings roadsignDescriptionSettingsWithInfo:settingsInfo header:[roadsign roadsignInfoHeaderView]] settingsInfo:settingsInfo rootController:nil]; 
    settingsController.delegate = parentViewController;
    settingsController.controllerType = AWBSettingsControllerTypeRoadsignInfoSettings;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;  
    [parentViewController presentModalViewController:navController animated:YES];
    [settingsController release];   
    [navController release];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath  
{
    [parentViewController setEditing:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [parentViewController setEditing:NO animated:YES];
}

@end
