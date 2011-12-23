//
//  AWBRoadsignDataSource.h
//  Roadsign Magic
//
//  Created by Buckley Adam on 23/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AWBRoadsignsListViewController;

@protocol AWBRoadsignDataSource <NSObject>

@required

@property (nonatomic, assign) AWBRoadsignsListViewController *parentViewController;

@end
