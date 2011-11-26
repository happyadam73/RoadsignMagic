//
//  AWBSettings.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBSettings.h"

@implementation AWBSettings

@synthesize settingsGroups;
@synthesize settingsTitle;
@synthesize headerView;
@synthesize delegate;

- (id)initWithSettingsGroups:(NSMutableArray *)aSettingsGroups title:(NSString *)title
{
    self = [super init];
    if (self) {
        [self setSettingsTitle:title];
        [self setSettingsGroups:aSettingsGroups];
    }
    return self;
}

- (id)initWithSettingsGroups:(NSMutableArray *)aSettingsGroups
{
    return [self initWithSettingsGroups:aSettingsGroups title:@"Settings"];
}

- (void)dealloc
{
    [visibleSettingsGroups release];
    [settingsGroups release];
    [settingsTitle release];
    [headerView release];
    [super dealloc];
}

- (NSMutableArray *)visibleSettingsGroups
{
    if (visibleSettingsGroups) {
        return visibleSettingsGroups;
    } else {
        visibleSettingsGroups = [[NSMutableArray alloc] init];
        if (self.settingsGroups && ([self.settingsGroups count] > 0)) {
            for (AWBSettingsGroup *settingsGroup in self.settingsGroups) {
                if (settingsGroup.visible) {
                    [visibleSettingsGroups addObject:settingsGroup];
                }
            }
        }
        return visibleSettingsGroups;       
    }
}

- (void)visibleSettingsGroupsHaveChanged
{
    [visibleSettingsGroups release];
    visibleSettingsGroups = nil;
}

- (NSString *)description
{
    return [settingsGroups description];
}

- (void)masterSwitchSettingHasChangedValue:(AWBSetting *)setting forSettingsGroup:(AWBSettingsGroup *)settingsGroup
{
    if([delegate respondsToSelector:@selector(masterSwitchSettingHasChangedValue:forSettingsGroup:)]) {
		[delegate performSelector:@selector(masterSwitchSettingHasChangedValue:forSettingsGroup:) withObject:setting withObject:settingsGroup];
	}    
}

- (NSMutableDictionary *)infoFromSettings
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    
    for (AWBSettingsGroup *settingsGroup in self.settingsGroups) {
        for (AWBSetting *setting in settingsGroup.settings) {
            if (setting.settingKey && setting.settingValue) {
                if (!setting.readonly) {
                    [info setObject:setting.settingValue forKey:setting.settingKey];                    
                }
            }
        }
        
        if (settingsGroup.isMutuallyExclusive) {
            if (settingsGroup.settingKeyForMutuallyExclusiveObjects && settingsGroup.mutuallyExclusiveObjects && (settingsGroup.selectedIndex != NSNotFound)) {
                [info setObject:[settingsGroup.mutuallyExclusiveObjects objectAtIndex:settingsGroup.selectedIndex] forKey:settingsGroup.settingKeyForMutuallyExclusiveObjects];
            }
        }
    }
    
    return [info autorelease];
}

+ (AWBSettings *)mainSettingsWithInfo:(NSDictionary *)info
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup qualitySliderSettingsGroupWithInfo:info], nil];
    AWBSettings *mainSettings = [[self alloc] initWithSettingsGroups:settings title:@"Roadsign Settings"];
    
    return [mainSettings autorelease];
}

+ (AWBSettings *)textSettingsWithInfo:(NSDictionary *)info
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup textEditSettingsGroupWithInfo:info], [AWBSettingsGroup textAlignmentPickerSettingsGroupWithInfo:info], [AWBSettingsGroup textColorPickerSettingsGroupWithInfo:info], nil];
    return [[[self alloc] initWithSettingsGroups:settings title:@"Add Text Settings"] autorelease];
}

+ (AWBSettings *)editTextSettingsWithInfo:(NSDictionary *)info
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup textAlignmentPickerSettingsGroupWithInfo:info], [AWBSettingsGroup textColorPickerSettingsGroupWithInfo:info], nil];
    return [[[self alloc] initWithSettingsGroups:settings title:@"Edit Text Labels"] autorelease];
}

+ (AWBSettings *)editSingleTextSettingsWithInfo:(NSDictionary *)info
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup textEditSettingsGroupWithInfo:info], [AWBSettingsGroup textAlignmentPickerSettingsGroupWithInfo:info], [AWBSettingsGroup textColorPickerSettingsGroupWithInfo:info], nil];
    return [[[self alloc] initWithSettingsGroups:settings title:@"Edit Text Label"] autorelease];
}


@end
