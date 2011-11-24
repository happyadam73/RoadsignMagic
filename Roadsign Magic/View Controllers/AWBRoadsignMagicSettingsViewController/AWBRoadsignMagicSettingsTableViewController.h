//
//  AWBRoadsignMagicSettingsTableViewController.h
//  RoadsignMagic
//
//  Created by Adam Buckley on 05/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBSettings.h"

typedef enum {
    AWBSettingsControllerTypeMainSettings,
    AWBSettingsControllerTypeAddTextSettings,
    AWBSettingsControllerTypeEditTextSettings,
    AWBSettingsControllerTypeChooseThemeSettings,
    AWBSettingsControllerTypeCollageInfoSettings,
    AWBSettingsControllerTypeLuckyDipSettings
} AWBSettingsControllerType;

@class AWBRoadsignMagicSettingsTableViewController;

@protocol AWBRoadsignMagicSettingsTableViewControllerDelegate

@optional

- (void)awbRoadsignMagicSettingsTableViewController:(AWBRoadsignMagicSettingsTableViewController *)settingsController didFinishSettingsWithInfo:(NSDictionary *)info;
- (void)awbRoadsignMagicSettingsTableViewControllerDidDissmiss:(AWBRoadsignMagicSettingsTableViewController *)settingsController;
@end

@interface AWBRoadsignMagicSettingsTableViewController : UITableViewController <UITextFieldDelegate, AWBSettingsDelegate> {
    id delegate;        
    AWBSettings *settings;
    BOOL isRootController;
    AWBSettingsControllerType controllerType;
    
    NSMutableDictionary *settingsInfo;
    AWBRoadsignMagicSettingsTableViewController *parentSettingsController;
    BOOL forceReload;
    
    BOOL assetGroupsLoaded;
    UITextField *currentlyEditingCellTextField;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) AWBSettings *settings;
@property (nonatomic, readonly) BOOL isRootController;
@property (nonatomic, assign) AWBSettingsControllerType controllerType; 
@property (nonatomic, readonly) AWBRoadsignMagicSettingsTableViewController *parentSettingsController;
@property (nonatomic, assign) BOOL forceReload;
@property (nonatomic, retain) NSMutableDictionary *settingsInfo;

- (id)initWithSettings:(AWBSettings *)aSettings settingsInfo:(NSMutableDictionary *)aSettingsInfo rootController:(AWBRoadsignMagicSettingsTableViewController *)rootController;
- (void)finishSettingsWithInfo:(id)sender;
- (void)dismissSettings:(id)sender;
- (void)cellSelectedOrCellControlValueChanged:(id)sender;

@end
