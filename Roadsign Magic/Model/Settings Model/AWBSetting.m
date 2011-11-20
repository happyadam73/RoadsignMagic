//
//  AWBSetting.m
//  Collage Maker
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBSetting.h"
#import "AWBSettingsGroup.h"
#import "AWBSwitchCell.h"
#import "AWBQualitySliderCell.h"
#import "AWBColorPickerTableCell.h"
#import "AWBColorPickerSegmentedControl.h"
#import "AWBFontTableCell.h"
#import "AWBDrilldownCell.h"
#import "AWBTextEditCell.h"
#import "AWBImageAndTextTableCell.h"
#import "AWBTextValueTableCell.h"
#import "AWBSegmentControlCell.h"
#import "AWBSubtitleTableCell.h"

@implementation AWBSetting

@synthesize text, detailText, settingValue, settingKey, controlType, childSettings, readonly, items, visible, parentGroup, masterSlaveType;

- (id)initWithText:(NSString *)aText controlType:(AWBSettingControlType)aControlType value:(id)aValue key:(NSString *)aKey
{
    self = [super init];
    if (self) {
        [self setText:aText];
        [self setSettingValue:aValue];
        [self setSettingKey:aKey];
        [self setControlType:aControlType];
        [self setReadonly:NO];
        [self setVisible:YES];
        [self setMasterSlaveType:AWBSettingMasterSlaveTypeNone];
    }
    return self;
}

- (void)dealloc
{
    [text release];
    [detailText release];
    [settingValue release];
    [settingKey release];
    [childSettings release];
    [items release];
    [super dealloc];
}

- (BOOL)isSwitchedOn
{
    if (controlType == AWBSettingControlTypeSwitch) {
        if (settingValue) {
            return [settingValue boolValue];
        } else {
            return NO;
        }
    } else if (controlType == AWBSettingControlTypeSegmentControl) {
        return ([settingValue integerValue] != 0);
    } else {
        return NO;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\r    Text: %@\r    Control Type: %d\r", text, controlType];
}

+ (AWBSetting *)colorSettingWithValue:(id)aValue andKey:(NSString *)aKey
{
    UIColor *colorValue = aValue;
    if (!colorValue) {
        colorValue = [UIColor blackColor];
    }
    return [[[self alloc] initWithText:nil controlType:AWBSettingControlTypeColorPicker value:colorValue key:aKey] autorelease];
}

+ (AWBSetting *)qualitySliderSettingWithValue:(id)aValue andKey:(NSString *)aKey
{
    return [[[self alloc] initWithText:nil controlType:AWBSettingControlTypeQualitySlider value:aValue key:aKey] autorelease];
}

+ (AWBSetting *)switchSettingWithText:(NSString *)text value:(id)aValue key:(NSString *)aKey
{
    return [[[self alloc] initWithText:text controlType:AWBSettingControlTypeSwitch value:aValue key:aKey] autorelease];
}

+ (AWBSetting *)segmentControlSettingWithText:(NSString *)text items:(NSArray *)items value:(id)aValue key:(NSString *)aKey
{
    AWBSetting *setting = [[self alloc] initWithText:text controlType:AWBSettingControlTypeSegmentControl value:aValue key:aKey];
    setting.items = items;
    return [setting autorelease];
}

+ (AWBSetting *)textEditSettingWithText:(NSString *)text value:(id)aValue key:(NSString *)aKey
{
    return [[[self alloc] initWithText:text controlType:AWBSettingControlTypeTextEdit value:aValue key:aKey] autorelease];
}

+ (AWBSetting *)fontSettingWithValue:(id)aValue
{
    return [[[self alloc] initWithText:nil controlType:AWBSettingControlTypeFont value:aValue key:nil] autorelease];
}

+ (AWBSetting *)drilldownSettingWithText:(NSString *)aText value:(id)aValue key:(NSString *)aKey childSettings:(AWBSettings *)settings
{
    AWBSetting *setting = [[self alloc] initWithText:aText controlType:AWBSettingControlTypeDrilldown value:aValue key:aKey];
    setting.childSettings = settings;
    setting.readonly = YES;
    
    return [setting autorelease];
}

+ (AWBSetting *)imageAndTextListSettingWithText:(NSString *)aText value:(id)aValue
{
    return [[[self alloc] initWithText:aText controlType:AWBSettingControlTypeImageAndTextList value:aValue key:nil] autorelease];
}

+ (AWBSetting *)textAndValueSettingWithText:(NSString *)aText value:(id)aValue
{
    return [[[self alloc] initWithText:aText controlType:AWBSettingControlTypeTextAndValue value:aValue key:nil] autorelease];    
}

+ (AWBSetting *)subtitleSettingWithText:(NSString *)text detailText:(NSString *)detailText value:(id)aValue
{
    AWBSetting *setting = [[self alloc] initWithText:text controlType:AWBSettingControlTypeSubtitle value:aValue key:nil];
    setting.detailText = detailText;
    return [setting autorelease];
}

- (NSString *)cellReuseIdentifier
{
    switch (controlType) {
        case AWBSettingControlTypeSwitch:
            return @"AWBSettingControlTypeSwitch";
        case AWBSettingControlTypeTextEdit:
            return @"AWBSettingControlTypeTextEdit";
        case AWBSettingControlTypeQualitySlider:
            return @"AWBSettingControlTypeQualitySlider";
        case AWBSettingControlTypeColorPicker:
            return @"AWBSettingControlTypeColorPicker";
        case AWBSettingControlTypeFont:
            return @"AWBSettingControlTypeFont";
        case AWBSettingControlTypeDrilldown:
            return @"AWBSettingControlTypeDrilldown";
        case AWBSettingControlTypeDefault:
            return @"AWBSettingControlTypeDefault";
        case AWBSettingControlTypeImageAndTextList:
            return @"AWBSettingControlTypeImageAndTextList";   
        case AWBSettingControlTypeTextAndValue:
            return @"AWBSettingControlTypeTextAndValue";  
        case AWBSettingControlTypeSegmentControl:
            return @"AWBSettingControlTypeSegmentControl";   
        case AWBSettingControlTypeSubtitle:
            return @"AWBSettingControlTypeSubtitle";              
        default:
            return @"AWBSettingControlTypeDefault";
    }    
}

- (UITableViewCell *)settingTableCell;
{
    UITableViewCell *tableCell;
        
    switch (controlType) {
        case AWBSettingControlTypeSwitch:
            tableCell = [[AWBSwitchCell alloc] initWithText:self.text value:[settingValue boolValue] reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[(AWBSwitchCell *)tableCell cellSwitch] addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
            break;
        case AWBSettingControlTypeTextEdit:
            tableCell = [[AWBTextEditCell alloc] initWithLabel:self.text textValue:settingValue reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[(AWBTextEditCell *)tableCell cellTextField] addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
            break;
        case AWBSettingControlTypeQualitySlider:
            tableCell = [[AWBQualitySliderCell alloc] initWithQualityValue:[settingValue floatValue] reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[(AWBQualitySliderCell *)tableCell qualitySlider] addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
            break;
        case AWBSettingControlTypeColorPicker:
            tableCell = [[AWBColorPickerTableCell alloc] initWithSelectedColor:settingValue reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[(AWBColorPickerTableCell *)tableCell picker] addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
            break;
        case AWBSettingControlTypeFont:
            tableCell = [[AWBFontTableCell alloc] initWithFontType:[settingValue integerValue] reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        case AWBSettingControlTypeDrilldown:
            tableCell = [[AWBDrilldownCell alloc] initWithText:self.text textValue:[self settingValueDescription] reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        case AWBSettingControlTypeImageAndTextList:
            tableCell = [[AWBImageAndTextTableCell alloc] initWithWithText:self.text image:settingValue reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        case AWBSettingControlTypeTextAndValue:
            tableCell = [[AWBTextValueTableCell alloc] initWithWithText:self.text value:settingValue reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;  
        case AWBSettingControlTypeSegmentControl:
            tableCell = [[AWBSegmentControlCell alloc] initWithText:self.text items:self.items segmentIndex:[settingValue intValue] reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[(AWBSegmentControlCell *)tableCell cellSegmentedControl] addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
            break;
        case AWBSettingControlTypeSubtitle:
            tableCell = [[AWBSubtitleTableCell alloc] initWithWithText:self.text detailText:self.detailText image:settingValue reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        case AWBSettingControlTypeDefault:
            tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            tableCell.textLabel.text = self.text;
            break;
    }
    
    return [tableCell autorelease];
}

- (void)controlValueChanged:(id)sender
{
    switch (controlType) {
        case AWBSettingControlTypeSwitch:
            self.settingValue = [NSNumber numberWithBool:[(UISwitch *)sender isOn]];
            if (self.masterSlaveType == AWBSettingMasterSlaveTypeMasterSwitch) {
                if (self.parentGroup) {
                    [self.parentGroup masterSwitchSettingHasChangedValue:self];
                }
            }
            break;
        case AWBSettingControlTypeSegmentControl:
            self.settingValue = [NSNumber numberWithInteger:[(UISegmentedControl *)sender selectedSegmentIndex]];
            if (self.masterSlaveType == AWBSettingMasterSlaveTypeMasterSwitch) {
                if (self.parentGroup) {
                    [self.parentGroup masterSwitchSettingHasChangedValue:self];
                }
            }
            break;
        case AWBSettingControlTypeTextEdit:
            self.settingValue = [(UITextField *)sender text];
            break;
        case AWBSettingControlTypeQualitySlider:            
            self.settingValue = [NSNumber numberWithFloat:(((int)(2.0 * [(UISlider *)sender value])) / 2.0)];
            break;
        case AWBSettingControlTypeColorPicker:
            self.settingValue = [(AWBColorPickerSegmentedControl *)sender selectedColor];
            break;
        case AWBSettingControlTypeFont:
            self.settingValue = nil;
            break;
        case AWBSettingControlTypeImageAndTextList:
            self.settingValue = nil;
            break;
        case AWBSettingControlTypeDrilldown:
            self.settingValue = nil;
            break;
        case AWBSettingControlTypeTextAndValue:
            self.settingValue = nil;
            break;
        case AWBSettingControlTypeSubtitle:
            self.settingValue = nil;
            break;
        case AWBSettingControlTypeDefault:
            self.settingValue = nil;
            break;
    }    
}

- (NSString *)settingValueDescription
{
    NSString *description = nil;
    if (settingValue) {
        id value = [settingValue objectForKey:settingKey];
//        if ([value isEqual:[NSNull null]]) {
//            description = kAWBAllPhotosGroupName;
//        } else if ([value isKindOfClass:[ALAssetsGroup class]]) {
//            description = [value valueForProperty:ALAssetsGroupPropertyName];
//        } else {
            description = [value description];
//        }
    }
    return description;
}

@end
