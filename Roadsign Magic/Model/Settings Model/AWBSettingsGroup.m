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
#import "AWBRoadsignFont.h"
#import "FileHelpers.h"
#import "UIImage+NonCached.h"
#import "AWBRoadsignDescriptor.h"
#import "UIColor+Texture.h"
#import "AWBMyFontStore.h"
#import "AWBMyFont.h"

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
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting colorSettingWithValue:[info objectForKey:kAWBInfoKeyTextColor] andKey:kAWBInfoKeyTextColor]] header:nil footer:nil] autorelease];
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
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting exportSizeSliderSettingWithValue:[info objectForKey:kAWBInfoKeyExportSizeValue] andKey:kAWBInfoKeyExportSizeValue]] header:@"Export Quality" footer:@"Applies to saving & emailing the roadsign as a photo."] autorelease];
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

+ (AWBSettingsGroup *)exportQualitySettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *exportSizeSetting = [AWBSetting exportSizeSliderSettingWithValue:[info objectForKey:kAWBInfoKeyExportSizeValue] andKey:kAWBInfoKeyExportSizeValue];
    NSMutableArray *exportQualitySettings = [NSMutableArray arrayWithObjects:exportSizeSetting, nil];
    
    AWBSettingsGroup *exportQualitySettingsGroup = [[self alloc] initWithSettings:exportQualitySettings header:@"Quality" footer:@"Enable changes to export size, format & transparency with the \"Go Pro\" In-App purchase."];
    
    return [exportQualitySettingsGroup autorelease];    
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
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:[AWBSetting drilldownSettingWithText:@"Drawing Aids" value:nil key:nil childSettings:[AWBSettings drawingAidsSettingsWithInfo:info]], [AWBSetting drilldownSettingWithText:@"Background" value:nil key:nil childSettings:[AWBSettings backgroundSettingsWithInfo:info]], [AWBSetting drilldownSettingWithText:@"Export" value:nil key:nil childSettings:[AWBSettings exportSettingsWithInfo:info]], nil];
    
    if (IS_GOPRO_PURCHASED) {
        [buttonSettings addObject:[AWBSetting drilldownSettingWithText:@"Facebook" value:nil key:nil childSettings:[AWBSettings facebookSettingsWithInfo:info]]];
    }
    
    return [[[self alloc] initWithSettings:buttonSettings header:nil footer:nil] autorelease];    
}

+ (AWBSettingsGroup *)helpSettingsDrilldownSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:[AWBSetting drilldownSettingWithText:@"Help" value:nil key:nil childSettings:[AWBSettings helpSettingsWithFilename:@"Help.rtf" title:@"Help"]], [AWBSetting drilldownSettingWithText:@"About" value:nil key:nil childSettings:[AWBSettings helpSettingsWithFilename:@"AboutRoadsignMagic.rtf" title:@"About"]], nil];
    
    return [[[self alloc] initWithSettings:buttonSettings header:nil footer:@"Roadsign Magic is intended for personal use - DO NOT use Roadsigns in a misleading context (e.g. not on roadside billboards where they could mislead drivers).  Some materials are UK Crown Copyright reproduced with permission under the UK Open Government License - tap on About for more information."] autorelease];    
}

+ (AWBSettingsGroup *)helpTextSettingsGroupWithFilename:(NSString *)filename
{    
    NSString *path = AWBPathInMainBundleSubdirectory(@"Help Files", filename);
    NSURL *url = [NSURL fileURLWithPath:path];
    NSMutableArray *helpTextSettings = [NSMutableArray arrayWithObjects:[AWBSetting webViewSettingWithValue:url andKey:nil], nil];
    AWBSettingsGroup *helpTextSettingsGroup = [[self alloc] initWithSettings:helpTextSettings header:nil footer:nil];
    
    //ensure the table cell fills screen (this will be capped by the settings controller)
    helpTextSettingsGroup.iPhoneRowHeight = 480;
    helpTextSettingsGroup.iPadRowHeight = 1024;
    
    return [helpTextSettingsGroup autorelease];
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
    NSMutableArray *snapToGridSettings = [NSMutableArray arrayWithObjects:[AWBSetting switchSettingWithText:@"Snap to Grid" value:[info objectForKey:kAWBInfoKeySnapToGrid] key:kAWBInfoKeySnapToGrid], [AWBSetting switchSettingWithText:@"Snap Rotation" value:[info objectForKey:kAWBInfoKeySnapRotation] key:kAWBInfoKeySnapRotation], nil];
    
    return [[[self alloc] initWithSettings:snapToGridSettings header:nil footer:@"Snap to Grid limits sizing and position. Snap Rotation limits angles of rotation."] autorelease];
}

+ (AWBSettingsGroup *)backgroundColorPickerSettingsGroupWithInfo:(NSDictionary *)info header:(NSString *)header footer:(NSString *)footer 
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting colorSettingWithValue:[info objectForKey:kAWBInfoKeyRoadsignBackgroundColor] andKey:kAWBInfoKeyRoadsignBackgroundColor]] header:header footer:footer] autorelease];
}

+ (AWBSettingsGroup *)backgroundTextureListSettingsGroupWithInfo:(NSDictionary *)info header:(NSString *)header footer:(NSString *)footer   
{
    NSArray *colorDescriptions = [UIColor allTextureColorDescriptions];
    NSArray *colorImages = [UIColor allTextureColorImages];
    NSUInteger colorCount = [colorDescriptions count];
    NSMutableArray *colorSettings = [[NSMutableArray alloc] initWithCapacity:colorCount];
    
    for (NSUInteger colorIndex = 0; colorIndex < colorCount; colorIndex++) {
        AWBSetting *setting = [AWBSetting imageAndTextListSettingWithText:[colorDescriptions objectAtIndex:colorIndex] value:[colorImages objectAtIndex:colorIndex]];
        if (setting) {
            [colorSettings addObject:setting];
        }
    }
    
    AWBSettingsGroup *colorSettingsGroup = [[self alloc] initWithSettings:colorSettings header:header footer:footer];
    [colorSettings release];
    colorSettingsGroup.isMutuallyExclusive = YES;
    colorSettingsGroup.settingKeyForMutuallyExclusiveObjects = kAWBInfoKeyRoadsignBackgroundTexture;
    colorSettingsGroup.mutuallyExclusiveObjects = [NSMutableArray arrayWithArray:colorDescriptions];
    colorSettingsGroup.selectedIndex = [colorSettingsGroup.mutuallyExclusiveObjects indexOfObject:[info objectForKey:kAWBInfoKeyRoadsignBackgroundTexture]];
    if (colorSettingsGroup.selectedIndex >= [colorSettingsGroup.mutuallyExclusiveObjects count]) {
        colorSettingsGroup.selectedIndex = 0;
    }
    colorSettingsGroup.iPhoneRowHeight = 50.0;
    colorSettingsGroup.iPadRowHeight = 106.0;
    
    return [colorSettingsGroup autorelease];
}

+ (AWBSettingsGroup *)backgroundTextureSwitchSettingsGroupWithInfo:(NSDictionary *)info header:(NSString *)header footer:(NSString *)footer
{
    AWBSetting *backgroundTextureSwitchSetting = [AWBSetting switchSettingWithText:@"Textured Background" value:[info objectForKey:kAWBInfoKeyRoadsignUseBackgroundTexture] key:kAWBInfoKeyRoadsignUseBackgroundTexture];
    backgroundTextureSwitchSetting.masterSlaveType = AWBSettingMasterSlaveTypeMasterSwitch;
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObject:backgroundTextureSwitchSetting];
    AWBSettingsGroup *backgroundTextureSwitchSettings = [[self alloc] initWithSettings:buttonSettings header:header footer:footer];
    backgroundTextureSwitchSettings.masterSwitchIsOn = backgroundTextureSwitchSetting.isSwitchedOn;
    backgroundTextureSwitchSetting.parentGroup = backgroundTextureSwitchSettings;
    return [backgroundTextureSwitchSettings autorelease];
}

+ (AWBSettingsGroup *)fontSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *fontSettings = nil;
    fontSettings = [NSMutableArray arrayWithObjects:[AWBSetting zFontSettingWithValue:[NSNumber numberWithInteger:AWBRoadsignFontTypeBritishRoadsign]], nil];
    if (IS_SIGNPACK3_PURCHASED) {
        [fontSettings addObject:[AWBSetting zFontSettingWithValue:[NSNumber numberWithInteger:AWBRoadsignFontTypeUSHighwayNarrow]]];
        [fontSettings addObject:[AWBSetting zFontSettingWithValue:[NSNumber numberWithInteger:AWBRoadsignFontTypeUSHighwayWide]]];
        [fontSettings addObject:[AWBSetting zFontSettingWithValue:[NSNumber numberWithInteger:AWBRoadsignFontTypeUSFreeway]]];
    }
    [fontSettings addObject:[AWBSetting zFontSettingWithValue:[NSNumber numberWithInteger:AWBRoadsignFontTypeGraffiti]]];
    [fontSettings addObject:[AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBRoadsignFontTypeArialRoundedMTBold]]];
    [fontSettings addObject:[AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBRoadsignFontTypeHelvetica]]];
    
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    NSString *versionWithExtraFonts = @"5.0";
    NSString *footer = nil;
    BOOL extraFontsAvailable = ([versionWithExtraFonts compare:osVersion options:NSNumericSearch] != NSOrderedDescending);
    if (extraFontsAvailable) {
        [fontSettings addObject:[AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBRoadsignFontTypeGillSans]]];
        footer = @"The Roadsign & Graffiti Fonts do not support all international languages - for full international keyboard support, select Arial, Helvetica or Gill Sans.";
    } else {
        footer = @"The Roadsign & Graffiti Fonts do not support all international languages - for full international keyboard support, select Arial or Helvetica.";  
    }
    
    AWBSettingsGroup *fontGroup = [[self alloc] initWithSettings:fontSettings header:@"Select a Font" footer:footer];
    fontGroup.isMutuallyExclusive = YES;
    fontGroup.settingKeyForMutuallyExclusiveObjects = kAWBInfoKeyTextFontName;
    //fontGroup.mutuallyExclusiveObjects = [NSMutableArray arrayWithObjects:@"BritishRoadsign", @"ArialRoundedMTBold", @"Helvetica", nil]; 
    
    fontGroup.mutuallyExclusiveObjects = [NSMutableArray arrayWithObjects:@"BritishRoadsign", nil]; 
    if (IS_SIGNPACK3_PURCHASED) {
        [fontGroup.mutuallyExclusiveObjects addObject:@"Highway Gothic Narrow"];
        [fontGroup.mutuallyExclusiveObjects addObject:@"Highway Gothic Wide"];
        [fontGroup.mutuallyExclusiveObjects addObject:@"Freeway Gothic"];
    }
    [fontGroup.mutuallyExclusiveObjects addObject:@"Most Wasted"];
    [fontGroup.mutuallyExclusiveObjects addObject:@"ArialRoundedMTBold"];
    [fontGroup.mutuallyExclusiveObjects addObject:@"Helvetica"];
    
    if (extraFontsAvailable) {
        [fontGroup.mutuallyExclusiveObjects addObject:@"GillSans"];
    }
    
    NSUInteger foundFontIndex = [fontGroup.mutuallyExclusiveObjects indexOfObject:[info objectForKey:kAWBInfoKeyTextFontName]];
    if (foundFontIndex == NSNotFound) {
        fontGroup.selectedIndex = 0;
    } else {
        fontGroup.selectedIndex = foundFontIndex;        
    }
        
    return [fontGroup autorelease];
}

+ (AWBSettingsGroup *)myFontSettingsGroupWithInfo:(NSDictionary *)info
{
    NSArray *allMyFonts = [[AWBMyFontStore defaultStore] allMyFonts];
    NSMutableArray *fontSettings = [[NSMutableArray alloc] initWithCapacity:[allMyFonts count]];
    NSMutableArray *fontFilenames = [[NSMutableArray alloc] initWithCapacity:[allMyFonts count]];
    NSString *selectedFontFilename = [info objectForKey:kAWBInfoKeyMyFontName];
    NSUInteger selectedFontIndex = 0;
    NSUInteger currentFontIndex = 0;
    
    for (AWBMyFont *myFont in allMyFonts) {
        [fontSettings addObject:[AWBSetting defaultSettingWithText:myFont.fontName]];
        NSString *fontFilename = myFont.filename;
        [fontFilenames addObject:fontFilename];
        if ([selectedFontFilename isEqualToString:fontFilename]) {
            selectedFontIndex = currentFontIndex;
        }
        currentFontIndex++;
    }
    
    AWBSettingsGroup *fontGroup = [[self alloc] initWithSettings:fontSettings header:@"Select a Font" footer:nil];
    fontGroup.isMutuallyExclusive = YES;
    fontGroup.settingKeyForMutuallyExclusiveObjects = kAWBInfoKeyMyFontName;
    fontGroup.mutuallyExclusiveObjects = fontFilenames; 
    fontGroup.selectedIndex = selectedFontIndex;
    [fontSettings release];
    [fontFilenames release];
    
    return [fontGroup autorelease];
}

+ (AWBSettingsGroup *)myFontsSwitchSettingsGroupWithInfo:(NSDictionary *)info
{    
    NSUInteger myFontCount = [[[AWBMyFontStore defaultStore] allMyFonts] count];
    id settingValue;
    if (myFontCount > 0) {
        settingValue = [info objectForKey:kAWBInfoKeyUseMyFonts];
    } else {
        settingValue = [NSNumber numberWithBool:NO];
    }
    
    AWBSetting *useMyFontsSetting = [AWBSetting switchSettingWithText:@"Use MyFonts" value:settingValue key:kAWBInfoKeyUseMyFonts];
    NSString *footer = nil;
    if (myFontCount > 0) {
        useMyFontsSetting.disableControl = NO;
    } else {
        useMyFontsSetting.disableControl = YES;
        if (IS_MYFONTS_PURCHASED) {
            footer = @"No extra fonts installed - go to the MyFonts screen or Help to find out how to install more fonts.";
        } else {
            footer = @"MyFonts allows you to install your own fonts.  You first need to purchase it from the In-App Store (go to the MySigns screen).";            
        }
    }
    useMyFontsSetting.masterSlaveType = AWBSettingMasterSlaveTypeMasterSwitch;
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObject:useMyFontsSetting];
    AWBSettingsGroup *myFontsSettings = [[self alloc] initWithSettings:buttonSettings header:nil footer:footer];
    myFontsSettings.masterSwitchIsOn = useMyFontsSetting.isSwitchedOn;
    useMyFontsSetting.parentGroup = myFontsSettings;
    return [myFontsSettings autorelease];    
}

+ (AWBSettingsGroup *)textSettingsDrilldownSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:[AWBSetting drilldownSettingWithText:@"Fonts" value:nil key:nil childSettings:[AWBSettings fontSettingsWithInfo:info]], [AWBSetting drilldownSettingWithText:@"Borders & Background" value:nil key:nil childSettings:[AWBSettings extraTextSettingsWithInfo:info]], nil];
    
    NSString *footer = nil;
    if (!IS_MYFONTS_PURCHASED) {
        footer = @"You can also install and use your own fonts with MyFonts available as a purchase from the In-App Store (go to the MySigns screen).";
    }
    
    return [[[self alloc] initWithSettings:buttonSettings header:nil footer:footer] autorelease];    
}

+ (AWBSettingsGroup *)textBordersSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *addTextBordersSetting = [AWBSetting switchSettingWithText:@"Add Text Border" value:[info objectForKey:kAWBInfoKeyTextBorders] key:kAWBInfoKeyTextBorders];
    addTextBordersSetting.masterSlaveType = AWBSettingMasterSlaveTypeMasterSwitch;
    AWBSetting *roundedBordersSetting = [AWBSetting switchSettingWithText:@"Rounded Border" value:[info objectForKey:kAWBInfoKeyTextRoundedBorders] key:kAWBInfoKeyTextRoundedBorders];
    roundedBordersSetting.masterSlaveType = AWBSettingMasterSlaveTypeSlaveCell;
    roundedBordersSetting.visible = addTextBordersSetting.isSwitchedOn;
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:addTextBordersSetting, roundedBordersSetting, nil];
    AWBSettingsGroup *textBorderSettings = [[self alloc] initWithSettings:buttonSettings header:nil footer:nil];    
    textBorderSettings.masterSwitchIsOn = addTextBordersSetting.isSwitchedOn;
    addTextBordersSetting.parentGroup = textBorderSettings; 
    return [textBorderSettings autorelease];    
}

+ (AWBSettingsGroup *)textBorderColorPickerSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting colorSettingWithValue:[info objectForKey:kAWBInfoKeyTextBorderColor] andKey:kAWBInfoKeyTextBorderColor]] header:@"Text Border Colour" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)textBackgroundSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *addTextBackgroundSetting = [AWBSetting switchSettingWithText:@"Add Text Background" value:[info objectForKey:kAWBInfoKeyTextBackground] key:kAWBInfoKeyTextBackground];
    addTextBackgroundSetting.masterSlaveType = AWBSettingMasterSlaveTypeMasterSwitch;
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObject:addTextBackgroundSetting];
    AWBSettingsGroup *textBackgroundSettings = [[self alloc] initWithSettings:buttonSettings header:nil footer:nil];
    textBackgroundSettings.masterSwitchIsOn = addTextBackgroundSetting.isSwitchedOn;
    addTextBackgroundSetting.parentGroup = textBackgroundSettings;
    return [textBackgroundSettings autorelease];    
}

+ (AWBSettingsGroup *)textBackgroundColorPickerSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting colorSettingWithValue:[info objectForKey:kAWBInfoKeyTextBackgroundColor] andKey:kAWBInfoKeyTextBackgroundColor]] header:@"Text Background Colour" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)myFontNameWithHeaderSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *myFontNameSettings = [NSMutableArray arrayWithObjects:[AWBSetting textEditSettingWithText:@"Name" value:[info objectForKey:kAWBInfoKeyMyFontFontName] key:kAWBInfoKeyMyFontFontName], nil];
    
    return [[[self alloc] initWithSettings:myFontNameSettings header:nil footer:@"Tap to edit the font name"] autorelease];
}

+ (AWBSettingsGroup *)myFontInfoMetricsSettingsGroupWithInfo:(NSDictionary *)info
{
    NSDate *installDate = [info objectForKey:kAWBInfoKeyMyFontCreatedDate];
    NSString *installDateDescription = [NSString stringWithFormat:@"%@", AWBDateStringForCurrentLocale(installDate)];   
    NSString *myFontDiskTotal = AWBFileSizeIntToString([[info objectForKey:kAWBInfoKeyMyFontFileSizeBytes] intValue]);
    NSString *familyName = [info objectForKey:kAWBInfoKeyMyFontFamilyName];
    NSString *postScriptName = [info objectForKey:kAWBInfoKeyMyFontPostscriptName];
    NSString *filename = [info objectForKey:kAWBInfoKeyMyFontFilename];
       
    NSMutableArray *myFontInfoSettings = [NSMutableArray arrayWithObjects:[AWBSetting textAndValueSettingWithText:@"Family" value:familyName], [AWBSetting textAndValueSettingWithText:@"Postscript" value:postScriptName], [AWBSetting textAndValueSettingWithText:@"Filename" value:filename], [AWBSetting textAndValueSettingWithText:@"Installed" value:installDateDescription], [AWBSetting textAndValueSettingWithText:@"File Size" value:myFontDiskTotal], nil];
    
    return [[[self alloc] initWithSettings:myFontInfoSettings header:@"Info" footer:nil] autorelease];   
}

+ (AWBSettingsGroup *)myFontPreviewSettingsGroupWithInfo:(NSDictionary *)info
{
    NSURL *fontFileUrl = [info objectForKey:kAWBInfoKeyMyFontFileUrl];
    NSUInteger fontDiskBytes = [[info objectForKey:kAWBInfoKeyMyFontFileSizeBytes] integerValue];

    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    NSString *versionWithBetterFontRendering = @"5.0";
    BOOL shorterPreviewForLargeFonts = ([versionWithBetterFontRendering compare:osVersion options:NSNumericSearch] == NSOrderedDescending);
    NSString *previewText = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz 0123456789";
    NSString *footer = nil;
    
    if (shorterPreviewForLargeFonts) {
        if (fontDiskBytes > 500000) {
            previewText = @"ABC abc";
            footer = @"This is a very large font and may render slowly on this device (fonts render quicker with iOS5 and above).  A short preview is being displayed.";
        } else if (fontDiskBytes > 100000) {
            previewText = @"ABCDEFG abcdefg 0123456789";            
            footer = @"This font may render slowly on this device (fonts render quicker with iOS5 and above).  A shorter preview is being displayed.";
        }
    }
    
    NSMutableArray *myFontPreviewSettings = [NSMutableArray arrayWithObjects:[AWBSetting myFontPreviewSettingWithText:previewText value:fontFileUrl], nil];
    AWBSettingsGroup *myFontPreviewSettingsGroup = [[self alloc] initWithSettings:myFontPreviewSettings header:@"Preview" footer:footer];
    myFontPreviewSettingsGroup.iPhoneRowHeight = 200;
    myFontPreviewSettingsGroup.iPadRowHeight = 300;
    return [myFontPreviewSettingsGroup autorelease];
}

+ (AWBSettingsGroup *)goToAppStoreSettingsGroup
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting goToInAppStoreSettingWithText]] header:nil footer:@"\"Go Pro\" is an In-App purchase that allows different export sizes, formats and transparency as well as exporting to Facebook. If you have purchased it already, you can also restore your purchase in the In-App Store."] autorelease];
}

@end
