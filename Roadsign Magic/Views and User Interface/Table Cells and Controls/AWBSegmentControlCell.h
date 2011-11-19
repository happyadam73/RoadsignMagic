//
//  AWBSegmentControlCell.h
//  Collage Maker
//
//  Created by Adam Buckley on 23/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBSettingTableCell.h"

@interface AWBSegmentControlCell : UITableViewCell {
    UISegmentedControl *cellSegmentedControl;
}

@property (nonatomic, assign) NSInteger segmentIndexValue;
@property (nonatomic, readonly) UISegmentedControl *cellSegmentedControl;

- (id)initWithText:(NSString *)text items:(NSArray *)items segmentIndex:(NSInteger)segmentIndex reuseIdentifier:(NSString *)reuseIdentifier;

@end
