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
    
    return [[[self alloc] initWithSettings:textEditSettings header:nil footer:nil] autorelease];
}

+ (AWBSettingsGroup *)qualitySliderSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting exportSizeSliderSettingWithValue:[info objectForKey:kAWBInfoKeyExportSizeValue] andKey:kAWBInfoKeyExportSizeValue]] header:@"Export Quality" footer:@"Applies only to saving & emailing the roadsign as a photo."] autorelease];
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
    
    NSMutableArray *roadsignInfoSettings = [NSMutableArray arrayWithObjects:[AWBSetting textAndValueSettingWithText:@"Symbols" value:imageObjectTotal], [AWBSetting textAndValueSettingWithText:@"Labels" value:labelObjectTotal], [AWBSetting textAndValueSettingWithText:@"Memory" value:imageMemoryTotal], [AWBSetting textAndValueSettingWithText:@"Disk" value:roadsignDiskTotal], nil];
    
    return [[[self alloc] initWithSettings:roadsignInfoSettings header:@"Info" footer:nil] autorelease];   
}

+ (AWBSettingsGroup *)roadsignNameSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *roadsignNameSettings = [NSMutableArray arrayWithObjects:[AWBSetting textEditSettingWithText:@"Roadsign Name" value:[info objectForKey:kAWBInfoKeyRoadsignName] key:kAWBInfoKeyRoadsignName], nil];
    
    return [[[self alloc] initWithSettings:roadsignNameSettings header:nil footer:nil] autorelease];
}

+ (AWBSettingsGroup *)exportQualityAndFormatSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *exportSizeSetting = [AWBSetting exportSizeSliderSettingWithValue:[info objectForKey:kAWBInfoKeyExportSizeValue] andKey:kAWBInfoKeyExportSizeValue];
    AWBSetting *exportFormatSetting = [AWBSetting segmentControlSettingWithText:@"Format" items:[NSArray arrayWithObjects:@"PNG", @"JPEG", nil] value:[info objectForKey:kAWBInfoKeyExportFormatSelectedIndex] key:kAWBInfoKeyExportFormatSelectedIndex];
    exportFormatSetting.masterSlaveType = AWBSettingMasterSlaveTypeMasterSwitch;
    NSMutableArray *exportQualityAndFormatSettings = [NSMutableArray arrayWithObjects:exportSizeSetting, exportFormatSetting, nil];
    
    AWBSettingsGroup *exportQualityAndFormatSettingsGroup = [[self alloc] initWithSettings:exportQualityAndFormatSettings header:@"Quality & Format" footer:@"PNG provides better quality and support for transparency.  JPEG can help reduce file size."];
    exportQualityAndFormatSettingsGroup.masterSwitchIsOn = exportFormatSetting.isSwitchedOn;
    exportFormatSetting.parentGroup = exportQualityAndFormatSettingsGroup; 
    
    return [exportQualityAndFormatSettingsGroup autorelease];    
}

+ (AWBSettingsGroup *)pngExportSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *pngExportSettings = [NSMutableArray arrayWithObjects:[AWBSetting switchSettingWithText:@"Transparency" value:[info objectForKey:kAWBInfoKeyPNGExportTransparentBackground] key:kAWBInfoKeyPNGExportTransparentBackground], nil];
    
    return [[[self alloc] initWithSettings:pngExportSettings header:@"PNG Format Settings" footer:@"Exports just the roadsign with no visible background.  To include the background switch off this setting."] autorelease];
}

+ (AWBSettingsGroup *)jpgExportSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *jpgExportSettings = [NSMutableArray arrayWithObjects:[AWBSetting exportQualitySliderSettingWithValue:[info objectForKey:kAWBInfoKeyJPGExportQualityValue] andKey:kAWBInfoKeyJPGExportQualityValue], nil];
    
    return [[[self alloc] initWithSettings:jpgExportSettings header:@"JPEG Format Settings" footer:@"Higher quality results in larger file sizes."] autorelease];
}

+ (AWBSettingsGroup *)mainSettingsDrilldownSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:[AWBSetting drilldownSettingWithText:@"Drawing Aids" value:nil key:nil childSettings:[AWBSettings drawingAidsSettingsWithInfo:info]], [AWBSetting drilldownSettingWithText:@"Background" value:nil key:nil childSettings:[AWBSettings exportSettingsWithInfo:info]], [AWBSetting drilldownSettingWithText:@"Export" value:nil key:nil childSettings:[AWBSettings exportSettingsWithInfo:info]], nil];
    
    return [[[self alloc] initWithSettings:buttonSettings header:nil footer:nil] autorelease];    
}

+ (AWBSettingsGroup *)aboutSettingsDrilldownSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:[AWBSetting drilldownSettingWithText:@"About" value:nil key:nil childSettings:[AWBSettings aboutSettingsWithInfo:info]], nil];
    
    return [[[self alloc] initWithSettings:buttonSettings header:nil footer:@"Roadsign Magic is intended for personal use - DO NOT use Roadsigns in a misleading context (e.g. not on roadside billboards where they could mislead drivers).  Some materials are UK Crown Copyright reproduced with permission under the UK Open Government License - tap on About for more information."] autorelease];    
}

+ (AWBSettingsGroup *)aboutTextSettingsGroupWithInfo:(NSDictionary *)info
{
    NSString *aboutText = @"Roadsign Magic is developed by happyadam development.\r\n\r\nRoadsign Magic is intended for personal use.  It is not intended for commercial use or for actual traffic sign making.  You must not reproduce roadsigns in a misleading context (e.g. not on roadside billboards where they could mislead drivers) or in any other way that may contravene local and international highway laws.\r\n\r\nThe majority of roadsign backgrounds and symbols as well as the Roadsign Typeface are Crown Copyright and reproduced with permission under the UK Open Government License v1.0.\r\nMore information on the terms of this license can be found at http://www.nationalarchives.gov.uk/doc/open-government-licence.\r\n\r\nThe Roadsign Typeface is based on the Transport Medium Typeface which is also UK Crown Copyright reproduced from the Department of Transport Working Drawings available under the UK Open Government License 1.0.  It was created between 1957 and 1963 by Jock Kinneir and Margaret Calvert as part of their work as designers for the Department of Transport's Anderson and Worboys committees.";
    
    NSMutableArray *aboutTextSettings = [NSMutableArray arrayWithObjects:[AWBSetting textViewSettingWithValue:aboutText andKey:nil], nil];
    AWBSettingsGroup *aboutTextSettingsGroup = [[self alloc] initWithSettings:aboutTextSettings header:nil footer:nil];
    aboutTextSettingsGroup.iPhoneRowHeight = 400;
    aboutTextSettingsGroup.iPadRowHeight = 400;
    return [aboutTextSettingsGroup autorelease];
}

+ (AWBSettingsGroup *)canvasLockSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *canvasLockSettings = [NSMutableArray arrayWithObjects:[AWBSetting switchSettingWithText:@"Canvas Lock" value:[info objectForKey:kAWBInfoKeyScrollLocked] key:kAWBInfoKeyScrollLocked], nil];
    
    return [[[self alloc] initWithSettings:canvasLockSettings header:nil footer:@"Lock the canvas to make it easier to resize and rotate objects.  Unlock to allow zooming and scrolling of the main screen.  You can also use the Anchor button at the top of the main screen."] autorelease];
}

+ (AWBSettingsGroup *)objectLockSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *objectLockSettings = [NSMutableArray arrayWithObjects:[AWBSetting switchSettingWithText:@"Lock Objects" value:[info objectForKey:kAWBInfoKeyLockCanvas] key:kAWBInfoKeyLockCanvas], nil];
    
    return [[[self alloc] initWithSettings:objectLockSettings header:nil footer:@"Locks all symbols and text in place.  You can also use the Lock button at the top of the main screen."] autorelease];
}

+ (AWBSettingsGroup *)snapToGridSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *snapToGridSettings = [NSMutableArray arrayWithObjects:[AWBSetting switchSettingWithText:@"Snap to Grid" value:[info objectForKey:kAWBInfoKeySnapToGrid] key:kAWBInfoKeySnapToGrid], nil];
    
    return [[[self alloc] initWithSettings:snapToGridSettings header:nil footer:nil] autorelease];
}


@end
