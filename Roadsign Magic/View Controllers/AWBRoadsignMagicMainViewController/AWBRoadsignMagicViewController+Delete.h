//
//  AWBRoadsignMagicViewController+Delete.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController.h"

@interface AWBRoadsignMagicMainViewController (Delete)

- (void)deleteSelectedViews:(id)sender;
- (void)deleteConfirmationActionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end
