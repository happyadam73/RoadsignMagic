//
//  AWBTextEditCell.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 08/09/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBSettingTableCell.h"

#define CellTextFieldWidth 270.0
#define MarginBetweenControls 20.0
#define LeftRightMargin 10.0

@interface AWBTextEditCell : UITableViewCell {
    UITextField *textField;
}

@property (nonatomic, readonly) UITextField *textField;

- (void)initialiseWithWithLabel:(NSString *)label textValue:(NSString *)value;
- (id)initWithLabel:(NSString *)label textValue:(NSString *)value reuseIdentifier:(NSString *)reuseIdentifier;

@end
