//
//  AWBSettings.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBSettings.h"
#import "AWBFacebookSignoutView.h"
#import "AWBMyFontStore.h"
#import "FileHelpers.h"

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
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup mainSettingsDrilldownSettingsGroupWithInfo:info], [AWBSettingsGroup helpSettingsDrilldownSettingsGroupWithInfo:info], nil];
    AWBSettings *mainSettings = [[self alloc] initWithSettingsGroups:settings title:@"Settings"];
    
    return [mainSettings autorelease];        
}

+ (AWBSettings *)exportSettingsWithInfo:(NSDictionary *)info
{
    if (IS_GOPRO_PURCHASED) {
        AWBSettingsGroup *exportQualityAndFormatSettings = [AWBSettingsGroup exportQualityAndFormatSettingsGroupWithInfo:info];
        AWBSettingsGroup *pngExportSettings = [AWBSettingsGroup pngExportSettingsGroupWithInfo:info];
        AWBSettingsGroup *jpgExportSettings = [AWBSettingsGroup jpgExportSettingsGroupWithInfo:info];
        
        NSMutableArray *settings = [NSMutableArray arrayWithObjects:exportQualityAndFormatSettings, pngExportSettings, jpgExportSettings, nil];
        AWBSettings *exportSettings = [[self alloc] initWithSettingsGroups:settings title:@"Export Settings"];
        
        exportQualityAndFormatSettings.parentSettings = exportSettings;
        exportQualityAndFormatSettings.dependentVisibleSettingsGroup = jpgExportSettings;
        exportQualityAndFormatSettings.dependentHiddenSettingsGroup = pngExportSettings;
        jpgExportSettings.visible = exportQualityAndFormatSettings.masterSwitchIsOn;
        pngExportSettings.visible = !exportQualityAndFormatSettings.masterSwitchIsOn;
        
        return [exportSettings autorelease];        
        
    } else {
        AWBSettingsGroup *exportQualitySettings = [AWBSettingsGroup exportQualitySettingsGroupWithInfo:info];
        AWBSettingsGroup *goToAppStoreSettings = [AWBSettingsGroup goToAppStoreSettingsGroup];
        
        NSMutableArray *settings = [NSMutableArray arrayWithObjects:exportQualitySettings, goToAppStoreSettings, nil];
        AWBSettings *exportSettings = [[self alloc] initWithSettingsGroups:settings title:@"Export Settings"];        
        
        return [exportSettings autorelease];        
    }
}

+ (AWBSettings *)helpSettingsWithFilename:(NSString *)filename title:(NSString *)title
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup helpTextSettingsGroupWithFilename:filename], nil];
    AWBSettings *helpSettings = [[self alloc] initWithSettingsGroups:settings title:title];
    
    return [helpSettings autorelease];    
}

+ (AWBSettings *)drawingAidsSettingsWithInfo:(NSDictionary *)info
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup snapToGridSettingsGroupWithInfo:info], [AWBSettingsGroup objectLockSettingsGroupWithInfo:info], [AWBSettingsGroup canvasLockSettingsGroupWithInfo:info], nil];
    AWBSettings *drawingAidsSettings = [[self alloc] initWithSettingsGroups:settings title:@"Drawing Aids"];
    
    return [drawingAidsSettings autorelease];    
}

+ (AWBSettings *)textSettingsWithInfo:(NSDictionary *)info
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup textEditSettingsGroupWithInfo:info], [AWBSettingsGroup textAlignmentPickerSettingsGroupWithInfo:info], [AWBSettingsGroup textColorPickerSettingsGroupWithInfo:info], [AWBSettingsGroup textSettingsDrilldownSettingsGroupWithInfo:info], nil];
    return [[[self alloc] initWithSettingsGroups:settings title:@"Add Text"] autorelease];
}

+ (AWBSettings *)editTextSettingsWithInfo:(NSDictionary *)info
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup textAlignmentPickerSettingsGroupWithInfo:info], [AWBSettingsGroup textColorPickerSettingsGroupWithInfo:info], [AWBSettingsGroup textSettingsDrilldownSettingsGroupWithInfo:info], nil];
    return [[[self alloc] initWithSettingsGroups:settings title:@"Edit Labels"] autorelease];
}

+ (AWBSettings *)editSingleTextSettingsWithInfo:(NSDictionary *)info
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup textEditSettingsGroupWithInfo:info], [AWBSettingsGroup textAlignmentPickerSettingsGroupWithInfo:info], [AWBSettingsGroup textColorPickerSettingsGroupWithInfo:info], [AWBSettingsGroup textSettingsDrilldownSettingsGroupWithInfo:info], nil];
    return [[[self alloc] initWithSettingsGroups:settings title:@"Edit Label"] autorelease];
}

+ (AWBSettings *)roadsignDescriptionSettingsWithInfo:(NSDictionary *)info header:(UIView *)header
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup roadsignNameWithHeaderSettingsGroupWithInfo:info], [AWBSettingsGroup roadsignInfoMetricsSettingsGroupWithInfo:info], nil];
    AWBSettings *roadsignDescriptionSettings = [[self alloc] initWithSettingsGroups:settings title:@"Roadsign Information"];
    roadsignDescriptionSettings.headerView = header;
    return [roadsignDescriptionSettings autorelease];
}

+ (AWBSettings *)createRoadsignSettingsWithInfo:(NSDictionary *)info
{
    AWBSettingsGroup *roadsignNameSettings = [AWBSettingsGroup roadsignNameSettingsGroupWithInfo:info];
    AWBSettingsGroup *backgroundTypeSettings = [AWBSettingsGroup backgroundTextureSwitchSettingsGroupWithInfo:info header:@"Choose a Background" footer:@"You can change this later in Background Settings"];
    AWBSettingsGroup *backgroundColorSettings = [AWBSettingsGroup backgroundColorPickerSettingsGroupWithInfo:info header:nil footer:kAWBBackgroundSettingsFooterText];
    AWBSettingsGroup *backgroundTextureSettings = [AWBSettingsGroup backgroundTextureListSettingsGroupWithInfo:info header:nil footer:kAWBBackgroundSettingsFooterText];
    
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:roadsignNameSettings, backgroundTypeSettings, backgroundColorSettings, backgroundTextureSettings, nil];
    AWBSettings *newRoadsignSettings = [[self alloc] initWithSettingsGroups:settings title:@"New Roadsign"];
    
    backgroundTypeSettings.parentSettings = newRoadsignSettings;
    backgroundTypeSettings.dependentVisibleSettingsGroup = backgroundTextureSettings;
    backgroundTypeSettings.dependentHiddenSettingsGroup = backgroundColorSettings;
    backgroundTextureSettings.visible = backgroundTypeSettings.masterSwitchIsOn;
    backgroundColorSettings.visible = !backgroundTypeSettings.masterSwitchIsOn;
    
    return [newRoadsignSettings autorelease];    
}

+ (AWBSettings *)backgroundSettingsWithInfo:(NSDictionary *)info
{
    AWBSettingsGroup *backgroundTypeSettings = [AWBSettingsGroup backgroundTextureSwitchSettingsGroupWithInfo:info header:nil footer:nil];
    AWBSettingsGroup *backgroundColorSettings = [AWBSettingsGroup backgroundColorPickerSettingsGroupWithInfo:info header:nil footer:kAWBBackgroundSettingsFooterText];
    AWBSettingsGroup *backgroundTextureSettings = [AWBSettingsGroup backgroundTextureListSettingsGroupWithInfo:info header:nil footer:kAWBBackgroundSettingsFooterText];
    
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:backgroundTypeSettings, backgroundColorSettings, backgroundTextureSettings, nil];
    AWBSettings *backgroundSettings = [[self alloc] initWithSettingsGroups:settings title:@"Background"];
    
    backgroundTypeSettings.parentSettings = backgroundSettings;
    backgroundTypeSettings.dependentVisibleSettingsGroup = backgroundTextureSettings;
    backgroundTypeSettings.dependentHiddenSettingsGroup = backgroundColorSettings;
    backgroundTextureSettings.visible = backgroundTypeSettings.masterSwitchIsOn;
    backgroundColorSettings.visible = !backgroundTypeSettings.masterSwitchIsOn;
    
    return [backgroundSettings autorelease];    
}

+ (AWBSettings *)fontSettingsWithInfo:(NSDictionary *)info
{
    AWBSettings *fontSettings = nil;
    NSString *settingsTitle = @"Choose a Font";
    
    if ([[[AWBMyFontStore defaultStore] allMyFonts] count] > 0) {
        AWBSettingsGroup *fontTypeSettings = [AWBSettingsGroup myFontsSwitchSettingsGroupWithInfo:info];
        AWBSettingsGroup *builtInFontSettings = [AWBSettingsGroup fontSettingsGroupWithInfo:info];
        AWBSettingsGroup *myFontSettings = [AWBSettingsGroup myFontSettingsGroupWithInfo:info];
        
        NSMutableArray *settings = [NSMutableArray arrayWithObjects:fontTypeSettings, builtInFontSettings, myFontSettings, nil];
        fontSettings = [[self alloc] initWithSettingsGroups:settings title:settingsTitle];
        fontTypeSettings.parentSettings = fontSettings;
        fontTypeSettings.dependentVisibleSettingsGroup = myFontSettings;
        fontTypeSettings.dependentHiddenSettingsGroup = builtInFontSettings;
        myFontSettings.visible = fontTypeSettings.masterSwitchIsOn;
        builtInFontSettings.visible = !fontTypeSettings.masterSwitchIsOn;
    } else {
        //no my fonts installed
        fontSettings = [[self alloc] initWithSettingsGroups:[NSMutableArray arrayWithObjects:[AWBSettingsGroup myFontsSwitchSettingsGroupWithInfo:info], [AWBSettingsGroup fontSettingsGroupWithInfo:info], nil] title:settingsTitle];
    }
       
    return [fontSettings autorelease];
}

+ (AWBSettings *)extraTextSettingsWithInfo:(NSDictionary *)info    
{
    AWBSettingsGroup *textBorderSettings = [AWBSettingsGroup textBordersSettingsGroupWithInfo:info];
    AWBSettingsGroup *textBorderColorPicker = [AWBSettingsGroup textBorderColorPickerSettingsGroupWithInfo:info];
    AWBSettingsGroup *textBackgroundSettings = [AWBSettingsGroup textBackgroundSettingsGroupWithInfo:info];
    AWBSettingsGroup *textBackgroundColorPicker = [AWBSettingsGroup textBackgroundColorPickerSettingsGroupWithInfo:info];

    NSMutableArray *settings = [NSMutableArray arrayWithObjects:textBorderSettings, textBorderColorPicker, textBackgroundSettings, textBackgroundColorPicker, nil];
    AWBSettings *textSettings = [[self alloc] initWithSettingsGroups:settings title:@"Text Settings"];
    textBorderSettings.parentSettings = textSettings;
    textBorderSettings.dependentVisibleSettingsGroup = textBorderColorPicker;
    textBorderColorPicker.visible = textBorderSettings.masterSwitchIsOn;
    textBackgroundSettings.parentSettings = textSettings;
    textBackgroundSettings.dependentVisibleSettingsGroup = textBackgroundColorPicker;
    textBackgroundColorPicker.visible = textBackgroundSettings.masterSwitchIsOn;
    
    return [textSettings autorelease];
}

+ (AWBSettings *)facebookSettingsWithInfo:(NSDictionary *)info
{
    AWBSettings *facebookSettings = [[self alloc] initWithSettingsGroups:nil title:@"Facebook"];
    
    AWBFacebookSignoutView *facebookSignOutView = [[AWBFacebookSignoutView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 200.0)];
    [facebookSignOutView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    facebookSettings.headerView = facebookSignOutView;
    [facebookSignOutView release];
    
    return [facebookSettings autorelease];
}

+ (AWBSettings *)myFontDescriptionSettingsWithInfo:(NSDictionary *)info header:(UIView *)header
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup myFontNameWithHeaderSettingsGroupWithInfo:info], [AWBSettingsGroup myFontPreviewSettingsGroupWithInfo:info], [AWBSettingsGroup myFontInfoMetricsSettingsGroupWithInfo:info], nil];
    AWBSettings *myFontDescriptionSettings = [[self alloc] initWithSettingsGroups:settings title:@"MyFont Preview"];
    myFontDescriptionSettings.headerView = header;
    return [myFontDescriptionSettings autorelease];
}

@end
