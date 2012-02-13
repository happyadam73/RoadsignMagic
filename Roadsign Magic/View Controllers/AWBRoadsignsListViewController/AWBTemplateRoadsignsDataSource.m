//
//  AWBSampleRoadsignsDataSource.m
//  Roadsign Magic
//
//  Created by Buckley Adam on 23/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBTemplateRoadsignsDataSource.h"
#import "FileHelpers.h"
#import "AWBRoadsignMagicMainViewController.h"
#import "AWBRoadsignDescriptor.h"
#import "AWBRoadsignStore.h"
#import "AWBSettingsGroup.h"
#import "AWBSizeableImageTableCell.h"
#import "AWBRoadsignsListViewController.h"

@implementation AWBTemplateRoadsignsDataSource

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
    return [[[AWBRoadsignStore defaultStore] templateRoadsigns] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TemplateRoadsignDescriptorCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[AWBSizeableImageTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AWBRoadsignDescriptor *roadsign = [[[AWBRoadsignStore defaultStore] templateRoadsigns] objectAtIndex:[indexPath row]];
    NSString *subDir = roadsign.roadsignSaveDocumentsSubdirectory;

    if (roadsign.roadsignName && ([roadsign.roadsignName length] > 0)) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", roadsign.roadsignName];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", subDir];
    }
    
    UIImage *thumbnail = [UIImage imageWithContentsOfFile:AWBPathInMainBundleTemplateSubdirectory(subDir, @"thumbnail.png")];
    cell.imageView.image = thumbnail;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.detailTextLabel.numberOfLines = 2;

    if (!roadsign.isTemplateAvailable) {
        UIImageView *signPackView = [[UIImageView alloc] initWithImage:roadsign.templatePurchasePackImage];
        cell.accessoryView = signPackView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [signPackView release];        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Requires purchase of\r\n%@", roadsign.templatePurchasePackDescription];        
    } else {
        cell.accessoryView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.detailTextLabel.text = nil;        
    }
        
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return @"Select a template to make an editable copy in My Signs.";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AWBRoadsignDescriptor *templateRoadsign = [[[AWBRoadsignStore defaultStore] templateRoadsigns] objectAtIndex:[indexPath row]];
    
    if ([templateRoadsign isTemplateAvailable]) {
        AWBRoadsignDescriptor *newRoadsign =  [[AWBRoadsignStore defaultStore] createMyRoadsignFromTemplateRoadsign:templateRoadsign];
        
        if (newRoadsign) {
            [[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] forKey:kAWBInfoKeyScrollToTemplateStoreMyTemplateIndex]; 
            NSIndexPath *myRoadsignIndexPath = [NSIndexPath indexPathForRow:([[[AWBRoadsignStore defaultStore] myRoadsigns] count] - 1) inSection:0];
            [parentViewController loadRoadsignAtIndexPath:myRoadsignIndexPath withSettingsInfo:nil];
        }        
    }
}

@end
