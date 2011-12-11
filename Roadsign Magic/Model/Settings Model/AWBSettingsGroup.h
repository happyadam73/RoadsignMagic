//
//  AWBSettingsGroup.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kAWBInfoKeyCollageThemeName = @"CollageThemeName";
static NSString *const kAWBInfoKeyCollageTheme = @"CollageTheme";
static NSString *const kAWBInfoKeyCollageThemeThumbnailFileName = @"CollageThemeThumbnailFileName";
static NSString *const kAWBInfoKeyCollageBackgroundColor = @"CollageBackgroundColor";
static NSString *const kAWBInfoKeyCollageBackgroundTexture = @"CollageBackgroundTexture";
static NSString *const kAWBInfoKeyCollageUseBackgroundTexture = @"CollageUseBackgroundTexture";
static NSString *const kAWBInfoKeyCollageBorder = @"CollageBorder";
static NSString *const kAWBInfoKeyCollageBorderColor = @"CollageBorderColor";
static NSString *const kAWBInfoKeyTextColor = @"TextColor";
static NSString *const kAWBInfoKeyTextAlignment = @"TextAlignment";
static NSString *const kAWBInfoKeyTextFontName = @"TextFontName";
static NSString *const kAWBInfoKeyImageShadows = @"ImageShadows";
static NSString *const kAWBInfoKeyTextShadows = @"TextShadows";
static NSString *const kAWBInfoKeyImageShadowColor = @"ImageShadowColor";
static NSString *const kAWBInfoKeyTextShadowColor = @"TextShadowColor";
static NSString *const kAWBInfoKeyImageBorders = @"ImageBorders";
static NSString *const kAWBInfoKeyTextBorders = @"TextBorders";
static NSString *const kAWBInfoKeyImageBorderColor = @"ImageBorderColor";
static NSString *const kAWBInfoKeyTextBorderColor = @"TextBorderColor";
static NSString *const kAWBInfoKeyTextBackgroundColor = @"TextBackgroundColor";
static NSString *const kAWBInfoKeyImageRoundedBorders = @"ImageRoundedBorders";
static NSString *const kAWBInfoKeyTextRoundedBorders = @"TextRoundedBorders";
static NSString *const kAWBInfoKeyTextBackground = @"TextBackground";
static NSString *const kAWBInfoKeyLabelTextLine1 = @"LabelTextLine1";
static NSString *const kAWBInfoKeyLabelTextLine2 = @"LabelTextLine2";
static NSString *const kAWBInfoKeyLabelTextLine3 = @"LabelTextLine3";
static NSString *const kAWBInfoKeyLabelTextLine4 = @"LabelTextLine4";
static NSString *const kAWBInfoKeySymbolColor = @"SymbolColor";
static NSString *const kAWBInfoKeyLuckyDipSourceSelectedIndex = @"LuckyDipSourceSelectedIndex";
static NSString *const kAWBInfoKeyLuckyDipAmountSelectedIndex = @"LuckyDipAmountSelectedIndex";
static NSString *const kAWBInfoKeyAssetGroups = @"AssetGroups";
static NSString *const kAWBInfoKeySelectedAssetGroup = @"SelectedAssetGroup";
static NSString *const kAWBInfoKeySelectedAssetGroupName = @"SelectedAssetGroupName";
static NSString *const kAWBInfoKeyLuckyDipContactTypeSelectedIndex = @"LuckyDipContactTypeSelectedIndex";
static NSString *const kAWBInfoKeyLuckyDipContactIncludePhoneNumber = @"LuckyDipContactIncludePhoneNumber";
static NSString *const kAWBInfoKeyObjectPlacementIndex = @"ObjectPlacementIndex";
static NSString *const kAWBAllPhotosGroupName = @"All Photos";
static NSString *const kAWBAllPhotosGroupPersistentID = @"+MM/AllPhotos";
static NSString *const kAWBInfoKeyAddContentOnCreation = @"AddContentOnCreation";
static NSString *const kAWBInfoKeyLockCanvas = @"LockCanvas";
static NSString *const kAWBInfoKeyScrollLocked = @"ScrollLocked";
static NSString *const kAWBInfoKeySnapToGrid = @"SnapToGrid";
static NSString *const kAWBInfoKeySnapToGridSize = @"SnapToGridSize";

static NSString *const kAWBInfoKeyExportSizeValue = @"ExportSizeValue";
static NSString *const kAWBInfoKeyExportFormatSelectedIndex = @"ExportFormatSelectedIndex";
static NSString *const kAWBInfoKeyPNGExportTransparentBackground = @"PNGExportTransparentBackground";
static NSString *const kAWBInfoKeyJPGExportQualityValue = @"JPGExportQualityValue";
static NSString *const kAWBInfoKeyRoadsignBackgroundColor = @"RoadsignBackgroundColor";
static NSString *const kAWBInfoKeyRoadsignBackgroundTexture = @"RoadsignBackgroundTexture";
static NSString *const kAWBInfoKeyRoadsignUseBackgroundTexture = @"RoadsignUseBackgroundTexture";

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
+ (AWBSettingsGroup *)aboutSettingsDrilldownSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)aboutTextSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)canvasLockSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)objectLockSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)snapToGridSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)backgroundColorPickerSettingsGroupWithInfo:(NSDictionary *)info;
+ (AWBSettingsGroup *)backgroundTextureListSettingsGroupWithInfo:(NSDictionary *)info header:(NSString *)header footer:(NSString *)footer;  
+ (AWBSettingsGroup *)backgroundTextureSwitchSettingsGroupWithInfo:(NSDictionary *)info;

@end

