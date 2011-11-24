//
//  AWBSetting.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AWBSettings;
@class AWBSettingsGroup;

typedef enum {
    AWBSettingControlTypeDefault,
    AWBSettingControlTypeQualitySlider,              
    AWBSettingControlTypeSwitch,
    AWBSettingControlTypeTextEdit,
    AWBSettingControlTypeColorPicker,
    AWBSettingControlTypeFont,
    AWBSettingControlTypeDrilldown,
    AWBSettingControlTypeImageAndTextList,
    AWBSettingControlTypeTextAndValue, 
    AWBSettingControlTypeSegmentControl,
    AWBSettingControlTypeSubtitle
} AWBSettingControlType;

typedef enum {
    AWBSettingMasterSlaveTypeNone,
    AWBSettingMasterSlaveTypeMasterSwitch,
    AWBSettingMasterSlaveTypeSlaveCell,
    AWBSettingMasterSlaveTypeSlaveCellNegative
} AWBSettingMasterSlaveType;

@interface AWBSetting : NSObject {
    NSString *text;
    NSString *detailText;
    id settingValue;
    NSString *settingKey;
    AWBSettingControlType controlType;
    AWBSettings *childSettings;
    NSArray *items;
    BOOL readonly;
    BOOL visible;
    AWBSettingsGroup *parentGroup;
    AWBSettingMasterSlaveType masterSlaveType;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *detailText;
@property (nonatomic, retain) id settingValue;
@property (nonatomic, retain) NSString *settingKey;
@property (nonatomic, assign) AWBSettingControlType controlType;
@property (nonatomic, readonly) NSString *cellReuseIdentifier;
@property (nonatomic, retain) AWBSettings *childSettings;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) BOOL readonly;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, readonly) BOOL isSwitchedOn;
@property (nonatomic, assign) AWBSettingsGroup *parentGroup;
@property (nonatomic, assign) AWBSettingMasterSlaveType masterSlaveType;

+ (AWBSetting *)colorSettingWithValue:(id)aValue andKey:(NSString *)aKey;
+ (AWBSetting *)qualitySliderSettingWithValue:(id)aValue andKey:(NSString *)aKey;
+ (AWBSetting *)switchSettingWithText:(NSString *)text value:(id)aValue key:(NSString *)aKey;
+ (AWBSetting *)textEditSettingWithText:(NSString *)text value:(id)aValue key:(NSString *)aKey;
+ (AWBSetting *)fontSettingWithValue:(id)aValue;
+ (AWBSetting *)drilldownSettingWithText:(NSString *)aText value:(id)aValue key:(NSString *)aKey childSettings:(AWBSettings *)settings;
+ (AWBSetting *)imageAndTextListSettingWithText:(NSString *)text value:(id)aValue;
+ (AWBSetting *)textAndValueSettingWithText:(NSString *)text value:(id)aValue;
+ (AWBSetting *)segmentControlSettingWithText:(NSString *)text items:(NSArray *)items value:(id)aValue key:(NSString *)aKey;
+ (AWBSetting *)subtitleSettingWithText:(NSString *)text detailText:(NSString *)detailText value:(id)aValue;

- (id)initWithText:(NSString *)aText controlType:(AWBSettingControlType)aControlType value:(id)aValue key:(NSString *)aKey;
- (UITableViewCell *)settingTableCell;
- (void)controlValueChanged:(id)sender;
- (NSString *)settingValueDescription;

@end
