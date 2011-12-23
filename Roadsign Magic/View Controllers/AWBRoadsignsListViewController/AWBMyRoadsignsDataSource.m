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
        return @"Click the + button to create a new roadsign.";
    } else {
        [parentViewController setEditing:NO];
        parentViewController.navigationItem.leftBarButtonItem = nil;
        return @"There are no saved roadsigns.  Click the + button to create a new roadsign.";
    }
}

@end
