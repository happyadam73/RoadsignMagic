//
//  AWBSettingsGroup.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBSettingsGroup.h"
#import "AWBSetting.h"
#import "AWBSettings.h"
#import "AWBCollageFont.h"
#import "FileHelpers.h"
#import "UIImage+NonCached.h"
#import "AWBRoadsignDescriptor.h"

@implementation AWBSettingsGroup

@synthesize header, footer, settings, parentSettings, visible, dependentVisibleSettingsGroup, dependentHiddenSettingsGroup, masterSwitchIsOn;
@synthesize isMutuallyExclusive, selectedIndex, settingKeyForMutuallyExclusiveObjects, mutuallyExclusiveObjects;
@synthesize iPhoneRowHeight, iPadRowHeight;

- (id)initWithSettings:(NSMutableArray *)aSettings header:(NSString *)aHeader footer:(NSString *)aFooter    
{
    self = [super init];
    if (self) {
        [self setSettings:aSettings];
        [self setHeader:aHeader];
        [self setFooter:aFooter];
        [self setVisible:YES];
        isMutuallyExclusive = NO;
        selectedIndex = 0;
        iPhoneRowHeight = 0.0;    //default - means no row height override
        iPadRowHeight = 0.0;      //default - means no row height override
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\r  Header: %@\r  Footer: %@\r  Settings: %@", header, footer, [settings description]];
}

- (NSMutableArray *)visibleSettings
{
    if (visibleSettings) {
        return visibleSettings;
    } else {
        visibleSettings = [[NSMutableArray alloc] init];
        if (self.settings && ([self.settings count] > 0)) {
            for (AWBSetting *setting in self.settings) {
                if (setting.visible) {
                    if (setting) {
                        [visibleSettings addObject:setting];
                    }
                }
            }
        }
        return visibleSettings;       
    }
}

- (void)masterSwitchSettingHasChangedValue:(id)setting
{
    if (self.parentSettings) {
        masterSwitchIsOn = [(AWBSetting *)setting isSwitchedOn];
        [self.parentSettings masterSwitchSettingHasChangedValue:setting forSettingsGroup:self];
    }
}

- (void)notifySlaveSettingsOfMasterSwitchSettingValue:(BOOL)masterSwitchValue
{
    [visibleSettings release];
    visibleSettings = nil;
    for (AWBSetting *setting in self.settings) {
        if (setting.masterSlaveType == AWBSettingMasterSlaveTypeSlaveCell) {
            setting.visible = (masterSwitchValue == YES);
        } else if (setting.masterSlaveType == AWBSettingMasterSlaveTypeSlaveCellNegative) {
            setting.visible = (masterSwitchValue == NO);
        }
    }
    
    if (dependentVisibleSettingsGroup && parentSettings) {
        dependentVisibleSettingsGroup.visible = (masterSwitchValue == YES);
        [parentSettings visibleSettingsGroupsHaveChanged];
    }

    if (dependentHiddenSettingsGroup && parentSettings) {
        dependentHiddenSettingsGroup.visible = (masterSwitchValue == NO);
        [parentSettings visibleSettingsGroupsHaveChanged];
    }
}

- (void)dealloc
{
    [settings release];
    [header release];
    [footer release];
    [mutuallyExclusiveObjects release];
    [settingKeyForMutuallyExclusiveObjects release];
    [visibleSettings release];
    [super dealloc];
}

+ (AWBSettingsGroup *)textColorPickerSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting colorSettingWithValue:[info objectForKey:kAWBInfoKeyTextColor] andKey:kAWBInfoKeyTextColor]] header:@"Text Colour" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)textAlignmentPickerSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting segmentControlSettingWithText:@"Alignment" items:[NSArray arrayWithObjects:[UIImage imageNamed:@"leftalignment"], [UIImage imageNamed:@"centeralignment"], [UIImage imageNamed:@"rightalignment"], nil] value:[info objectForKey:kAWBInfoKeyTextAlignment] key:kAWBInfoKeyTextAlignment]] header:nil footer:nil] autorelease];
}

+ (AWBSettingsGroup *)textEditSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *textEditSettings = [NSMutableArray arrayWithObjects:[AWBSetting textEditSettingWithText:@"Line 1" value:[info objectForKey:kAWBInfoKeyLabelTextLine1] key:kAWBInfoKeyLabelTextLine1], [AWBSetting textEditSettingWithText:@"Line 2" value:[info objectForKey:kAWBInfoKeyLabelTextLine2] key:kAWBInfoKeyLabelTextLine2], [AWBSetting textEditSettingWithText:@"Line 3" value:[info objectForKey:kAWBInfoKeyLabelTextLine3] key:kAWBInfoKeyLabelTextLine3], nil];
    
    return [[[self alloc] initWithSettings:textEditSettings header:@"Label Text" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)qualitySliderSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting qualitySliderSettingWithValue:[info objectForKey:kAWBInfoKeyExportQualityValue] andKey:kAWBInfoKeyExportQualityValue]] header:@"Export Quality" footer:@"Applies only to saving & emailing the roadsign as a photo."] autorelease];
}

+ (AWBSettingsGroup *)roadsignNameWithHeaderSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *roadsignNameSettings = [NSMutableArray arrayWithObjects:[AWBSetting textEditSettingWithText:@"Name" value:[info objectForKey:kAWBInfoKeyRoadsignName] key:kAWBInfoKeyRoadsignName], nil];
    
    return [[[self alloc] initWithSettings:roadsignNameSettings header:@"Edit Roadsign Name" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)roadsignInfoMetricsSettingsGroupWithInfo:(NSDictionary *)info
{
    NSString *imageObjectTotal = [NSString stringWithFormat:@"%d", [[info objectForKey:kAWBInfoKeyRoadsignTotalImageObjects] intValue]];
    NSString *labelObjectTotal = [NSString stringWithFormat:@"%d", [[info objectForKey:kAWBInfoKeyRoadsignTotalLabelObjects] intValue]];
    NSString *imageMemoryTotal = AWBFileSizeIntToString([[info objectForKey:kAWBInfoKeyRoadsignTotalImageMemoryBytes] intValue]);
    NSString *roadsignDiskTotal = AWBFileSizeIntToString([[info objectForKey:kAWBInfoKeyRoadsignTotalDiskBytes] intValue]);
    
    NSMutableArray *roadsignInfoSettings = [NSMutableArray arrayWithObjects:[AWBSetting textAndValueSettingWithText:@"Symbols" value:imageObjectTotal], [AWBSetting textAndValueSettingWithText:@"Labels" value:labelObjectTotal], [AWBSetting textAndValueSettingWithText:@"Symbol Memory" value:imageMemoryTotal], [AWBSetting textAndValueSettingWithText:@"Disk" value:roadsignDiskTotal], nil];
    
    return [[[self alloc] initWithSettings:roadsignInfoSettings header:@"Info" footer:nil] autorelease];   
}

+ (AWBSettingsGroup *)roadsignNameSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *roadsignNameSettings = [NSMutableArray arrayWithObjects:[AWBSetting textEditSettingWithText:@"Roadsign Name" value:[info objectForKey:kAWBInfoKeyRoadsignName] key:kAWBInfoKeyRoadsignName], nil];
    
    return [[[self alloc] initWithSettings:roadsignNameSettings header:nil footer:nil] autorelease];
}

@end
