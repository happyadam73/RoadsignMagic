//
//  AWBRoadsignMagicViewController+Edit.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignMagicMainViewController.h"

@interface AWBRoadsignMagicMainViewController (Edit)

- (void)objectTappedInEditMode:(UIView <AWBTransformableView> *)view;
- (void)enableEditMode:(id)sender;
- (void)resetEditMode:(id)sender;
- (void)selectAllOrNoneInEditMode:(id)sender;
- (void)updateUserInterfaceWithTotalSelectedInEditMode;

@end
