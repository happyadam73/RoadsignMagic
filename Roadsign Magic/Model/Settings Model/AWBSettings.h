//
//  AWBSettings.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
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

+ (AWBSettings *)mainSettingsWithInfo:(NSDictionary *)info;
+ (AWBSettings *)exportSettingsWithInfo:(NSDictionary *)info;
+ (AWBSettings *)textSettingsWithInfo:(NSDictionary *)info;
+ (AWBSettings *)editTextSettingsWithInfo:(NSDictionary *)info;
+ (AWBSettings *)editSingleTextSettingsWithInfo:(NSDictionary *)info;
+ (AWBSettings *)roadsignDescriptionSettingsWithInfo:(NSDictionary *)info header:(UIView *)header;
+ (AWBSettings *)createRoadsignSettingsWithInfo:(NSDictionary *)info;
+ (AWBSettings *)aboutSettingsWithInfo:(NSDictionary *)info;
+ (AWBSettings *)drawingAidsSettingsWithInfo:(NSDictionary *)info;
+ (AWBSettings *)backgroundSettingsWithInfo:(NSDictionary *)info;
+ (AWBSettings *)fontSettingsWithInfo:(NSDictionary *)info;

@end
