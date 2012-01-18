//
//  AWBSetting.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBSetting.h"
#import "AWBSettingsGroup.h"
#import "AWBSwitchCell.h"
#import "AWBExportSizeSliderCell.h"
#import "AWBColorPickerTableCell.h"
#import "AWBColorPickerSegmentedControl.h"
#import "AWBFontTableCell.h"
#import "AWBDrilldownCell.h"
#import "AWBTextEditCell.h"
#import "AWBImageAndTextTableCell.h"
#import "AWBTextValueTableCell.h"
#import "AWBSegmentControlCell.h"
#import "AWBSubtitleTableCell.h"
#import "AWBExportQualitySliderCell.h"
#import "AWBTextViewCell.h"
#import "AWBZFontTableCell.h"
#import "AWBSettingTableCell.h"
#import "AWBMyFontPreviewTableCell.h"
#import "AWBWebViewCell.h"

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

+ (AWBSetting *)exportSizeSliderSettingWithValue:(id)aValue andKey:(NSString *)aKey
{
    return [[[self alloc] initWithText:nil controlType:AWBSettingControlTypeExportSizeSlider value:aValue key:aKey] autorelease];
}

+ (AWBSetting *)exportQualitySliderSettingWithValue:(id)aValue andKey:(NSString *)aKey
{
    return [[[self alloc] initWithText:nil controlType:AWBSettingControlTypeExportQualitySlider value:aValue key:aKey] autorelease];
}

+ (AWBSetting *)textViewSettingWithValue:(id)aValue andKey:(NSString *)aKey
{
    return [[[self alloc] initWithText:nil controlType:AWBSettingControlTypeTextView value:aValue key:aKey] autorelease];
}

+ (AWBSetting *)webViewSettingWithValue:(id)aValue andKey:(NSString *)aKey
{
    return [[[self alloc] initWithText:nil controlType:AWBSettingControlTypeWebView value:aValue key:aKey] autorelease];
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

+ (AWBSetting *)zFontSettingWithValue:(id)aValue
{
    return [[[self alloc] initWithText:nil controlType:AWBSettingControlTypeZFont value:aValue key:nil] autorelease];
}

+ (AWBSetting *)myFontPreviewSettingWithText:(NSString *)text value:(id)aValue
{
    return [[[self alloc] initWithText:text controlType:AWBSettingControlTypeMyFontPreview value:aValue key:nil] autorelease];
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

+ (AWBSetting *)goToInAppStoreSettingWithText
{
    AWBSetting *setting = [[self alloc] initWithText:nil controlType:AWBSettingControlTypeGoToInAppStore value:nil key:nil];
    return [setting autorelease];
}

+ (AWBSetting *)defaultSettingWithText:(NSString *)text
{
    AWBSetting *setting = [[self alloc] initWithText:text controlType:AWBSettingControlTypeDefault value:nil key:nil];
    return [setting autorelease];
}

- (NSString *)cellReuseIdentifier
{
    switch (controlType) {
        case AWBSettingControlTypeSwitch:
            return @"AWBSettingControlTypeSwitch";
        case AWBSettingControlTypeTextEdit:
            return @"AWBSettingControlTypeTextEdit";
        case AWBSettingControlTypeExportSizeSlider:
            return @"AWBSettingControlTypeExportSizeSlider";
        case AWBSettingControlTypeExportQualitySlider:
            return @"AWBSettingControlTypeExportQualitySlider";
        case AWBSettingControlTypeColorPicker:
            return @"AWBSettingControlTypeColorPicker";
        case AWBSettingControlTypeFont:
            return @"AWBSettingControlTypeFont";
        case AWBSettingControlTypeZFont:
            return @"AWBSettingControlTypeZFont";
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
        case AWBSettingControlTypeTextView:
            return @"AWBSettingControlTypeTextView"; 
        case AWBSettingControlTypeMyFontPreview:
            return @"AWBSettingControlTypeMyFontPreview"; 
        case AWBSettingControlTypeWebView:
            return @"AWBSettingControlTypeWebView";
        case AWBSettingControlTypeGoToInAppStore:
            return @"AWBSettingControlTypeGoToInAppStore";
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
        case AWBSettingControlTypeExportSizeSlider:
            tableCell = [[AWBExportSizeSliderCell alloc] initWithExportSizeValue:[settingValue floatValue] reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[(AWBExportSizeSliderCell *)tableCell exportSizeSlider] addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
            break;
        case AWBSettingControlTypeExportQualitySlider:
            tableCell = [[AWBExportQualitySliderCell alloc] initWithExportQualityValue:[settingValue floatValue] reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[(AWBExportQualitySliderCell *)tableCell exportQualitySlider] addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
            break;
        case AWBSettingControlTypeTextView:
            tableCell = [[AWBTextViewCell alloc] initWithText:settingValue reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case AWBSettingControlTypeWebView:
            tableCell = [[AWBWebViewCell alloc] initWithUrl:settingValue ReuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        case AWBSettingControlTypeZFont:
            tableCell = [[AWBZFontTableCell alloc] initWithFontType:[settingValue integerValue] reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        case AWBSettingControlTypeMyFontPreview:
            tableCell = [[AWBMyFontPreviewTableCell alloc] initWithFontFileUrl:settingValue previewText:self.text reuseIdentifier:self.cellReuseIdentifier];
            tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        case AWBSettingControlTypeGoToInAppStore:
            tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellReuseIdentifier];
            tableCell.textLabel.textAlignment = UITextAlignmentCenter;
            tableCell.textLabel.textColor = TABLE_CELL_BLUE_TEXT_COLOR;
            tableCell.textLabel.text = @"Go To In-App Store";
            tableCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        case AWBSettingControlTypeDefault:
            tableCell = [[AWBSettingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellReuseIdentifier];
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
        case AWBSettingControlTypeExportSizeSlider:            
            self.settingValue = [NSNumber numberWithFloat:(((int)(10.0 * [(UISlider *)sender value])) / 10.0)];
            break;
        case AWBSettingControlTypeExportQualitySlider:            
            self.settingValue = [NSNumber numberWithFloat:(((int)(10.0 * [(UISlider *)sender value])) / 10.0)];
            break;
        case AWBSettingControlTypeColorPicker:
            self.settingValue = [(AWBColorPickerSegmentedControl *)sender selectedColor];
            break;
        case AWBSettingControlTypeFont:
            self.settingValue = nil;
            break;
        case AWBSettingControlTypeZFont:
            self.settingValue = nil;
            break;
        case AWBSettingControlTypeTextView:
            self.settingValue = nil;
            break;
        case AWBSettingControlTypeWebView:
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
        case AWBSettingControlTypeMyFontPreview:
            self.settingValue = nil;
            break;
        case AWBSettingControlTypeGoToInAppStore:
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
        description = [value description];
    }
    return description;
}

@end
