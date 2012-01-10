//
//  AWBSettingsGroup.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kAWBInfoKeyLockCanvas = @"LockCanvas";
static NSString *const kAWBInfoKeyScrollLocked = @"ScrollLocked";
static NSString *const kAWBInfoKeySnapToGrid = @"SnapToGrid";
static NSString *const kAWBInfoKeySnapRotation = @"SnapRotation";
static NSString *const kAWBInfoKeySnapToGridSize = @"SnapToGridSize";
static NSString *const kAWBInfoKeyExportSizeValue = @"ExportSizeValue";
static NSString *const kAWBInfoKeyExportFormatSelectedIndex = @"ExportFormatSelectedIndex";
static NSString *const kAWBInfoKeyPNGExportTransparentBackground = @"PNGExportTransparentBackground";
static NSString *const kAWBInfoKeyJPGExportQualityValue = @"JPGExportQualityValue";
static NSString *const kAWBInfoKeyRoadsignBackgroundColor = @"RoadsignBackgroundColor";
static NSString *const kAWBInfoKeyRoadsignBackgroundTexture = @"RoadsignBackgroundTexture";
static NSString *const kAWBInfoKeyRoadsignUseBackgroundTexture = @"RoadsignUseBackgroundTexture";
static NSString *const kAWBInfoKeyTextColor = @"TextColor";
static NSString *const kAWBInfoKeyTextAlignment = @"TextAlignment";
static NSString *const kAWBInfoKeyUseMyFonts = @"UseMyFonts";
static NSString *const kAWBInfoKeyTextFontName = @"TextFontName";
static NSString *const kAWBInfoKeyMyFontName = @"MyFontName";
static NSString *const kAWBInfoKeyLabelTextLine1 = @"LabelTextLine1";
static NSString *const kAWBInfoKeyLabelTextLine2 = @"LabelTextLine2";
static NSString *const kAWBInfoKeyLabelTextLine3 = @"LabelTextLine3";
static NSString *const kAWBInfoKeyTextBorders = @"TextBorders";
static NSString *const kAWBInfoKeyTextBorderColor = @"TextBorderColor";
static NSString *const kAWBInfoKeyTextBackground = @"TextBackground";
static NSString *const kAWBInfoKeyTextBackgroundColor = @"TextBackgroundColor";
static NSString *const kAWBInfoKeyTextRoundedBorders = @"TextRoundedBorders";

static NSString *const kAWBBackgroundSettingsFooterText = @"By default, this background is not included when exporting or sharing.  You can change this in Export Settings.";

@class AWBSetting;
@class AWBSettings;

@interface AWBSettingsGroup : NSObject {
    NSString *header;
    NSString *footer;
    NSMutableArray *settings;
    BOOL isMutuallyExclusive;
    NSInteger selectedIndex;
    NSString *settingKeyForMutuallyExclusiveObjects;
    NSMutableArray *mutuallyExclusiveObjects;
    CGFloat iPhoneRowHeight;
    CGFloat iPadRowHeight;
    NSMutableArray *visibleSettings;
    AWBSettings *parentSettings;
    BOOL visible;
    AWBSettingsGroup *dependentVisibleSettingsGroup;
    AWBSettingsGroup *dependentHiddenSettingsGroup;
    BOOL masterSwitchIsOn;
}

@property (nonatomic, retain) NSString *header;
@property (nonatomic, retain) NSString *footer;
@property (nonatomic, retain) NSMutableArray *settings;
@property (nonatomic, assign) BOOL isMutuallyExclusive;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) NSString *settingKeyForMutuallyExclusiveObjects;
@property (nonatomic, retain) NSMutableArray *mutuallyExclusiveObjects;
@property (nonatomic, assign) CGFloat iPhoneRowHeight;
@property (nonatomic, assign) CGFloat iPadRowHeight;
@property (nonatomic, readonly) NSMutableArray *visibleSettings;
@property (nonatomic, assign) AWBSettings *parentSettings;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) AWBSettingsGroup *dependentVisibleSettingsGroup;
@property (nonatomic, assign) AWBSettingsGroup *dependentHiddenSettingsGroup;
@property (nonatomic, assign) BOOL masterSwitchIsOn;

- (id)initWithSettings:(NSMutableArray *)aSettings header:(NSString *)aHeader footer:(NSString *)aFooter;
- (void)masterSwitchSettingHasChangedValue:(AWBSetting *)setting;
- (void)notifySlaveSettingsOfMasterSwitchSettingValue:(BOOL)masterSwitchValue;

+ (AWBSettingsGroup *)textColorPickerSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)textAlignmentPickerSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)textEditSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)qualitySliderSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)roadsignNameWithHeaderSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)roadsignInfoMetricsSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)roadsignNameSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)exportQualityAndFormatSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)pngExportSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)jpgExportSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)mainSettingsDrilldownSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)helpSettingsDrilldownSettingsGroupWithInfo:(NSDictionary *)info;
//+ (AWBSettingsGroup *)aboutTextSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)helpTextSettingsGroupWithFilename:(NSString *)filename;
+ (AWBSettingsGroup *)canvasLockSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)objectLockSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)snapToGridSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)backgroundColorPickerSettingsGroupWithInfo:(NSDictionary *)info header:(NSString *)header footer:(NSString *)footer;
+ (AWBSettingsGroup *)backgroundTextureListSettingsGroupWithInfo:(NSDictionary *)info header:(NSString *)header footer:(NSString *)footer;  
+ (AWBSettingsGroup *)backgroundTextureSwitchSettingsGroupWithInfo:(NSDictionary *)info header:(NSString *)header footer:(NSString *)footer;
+ (AWBSettingsGroup *)fontSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)myFontSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)myFontsSwitchSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)textSettingsDrilldownSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)textBordersSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)textBorderColorPickerSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)textBackgroundSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)textBackgroundColorPickerSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)myFontNameWithHeaderSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)myFontInfoMetricsSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)myFontPreviewSettingsGroupWithInfo:(NSDictionary *)info;

@end

