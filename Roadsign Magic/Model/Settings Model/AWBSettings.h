//
//  AWBSettings.h
//  Collage Maker
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBSetting.h"
#import "AWBSettingsGroup.h"

@class AWBSettings;

@protocol AWBSettingsDelegate

@optional
- (void)masterSwitchSettingHasChangedValue:(AWBSetting *)setting forSettingsGroup:(AWBSettingsGroup *)settingsGroup;

@end

@interface AWBSettings : NSObject {
    NSMutableArray *settingsGroups;
    NSMutableArray *visibleSettingsGroups;
    NSString *settingsTitle;
    UIView *headerView;
    id delegate;
}

@property (nonatomic, retain) NSMutableArray *settingsGroups;
@property (nonatomic, retain) NSString *settingsTitle;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) NSMutableArray *visibleSettingsGroups;

- (id)initWithSettingsGroups:(NSMutableArray *)aSettingsGroups title:(NSString *)title;
- (id)initWithSettingsGroups:(NSMutableArray *)aSettingsGroups;
- (void)masterSwitchSettingHasChangedValue:(AWBSetting *)setting forSettingsGroup:(AWBSettingsGroup *)settingsGroup;
- (void)visibleSettingsGroupsHaveChanged;

- (NSMutableDictionary *)infoFromSettings;

@end
