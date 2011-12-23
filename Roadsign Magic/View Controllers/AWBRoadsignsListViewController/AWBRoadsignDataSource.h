//
//  AWBRoadsignDataSource.h
//  Roadsign Magic
//
//  Created by Buckley Adam on 23/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AWBRoadsignDataSource <NSObject>

@required

@property (nonatomic, assign) UIViewController *parentViewController;

@end
