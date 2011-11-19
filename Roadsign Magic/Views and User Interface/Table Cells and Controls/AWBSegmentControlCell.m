//
//  AWBSegmentControlCell.m
//  Collage Maker
//
//  Created by Adam Buckley on 23/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBSegmentControlCell.h"


@implementation AWBSegmentControlCell

@synthesize cellSegmentedControl, segmentIndexValue;

- (id)initWithText:(NSString *)text items:(NSArray *)items segmentIndex:(NSInteger)segmentIndex reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        cellSegmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        CGRect bounds = cellSegmentedControl.bounds;
        bounds.size.height = 33;
        [cellSegmentedControl setBounds:bounds];
        cellSegmentedControl.selectedSegmentIndex = segmentIndex;
        self.accessoryView = cellSegmentedControl;
        [self.textLabel setText:text];
        [cellSegmentedControl release];
    }
    return self;    
}

- (NSInteger)segmentIndexValue
{
    return cellSegmentedControl.selectedSegmentIndex;
}

- (void)setSegmentIndexValue:(NSInteger)aSegmentIndexValue
{
    cellSegmentedControl.selectedSegmentIndex = aSegmentIndexValue;
}

- (void)updateCellWithSetting:(AWBSetting *)aSetting
{
    [cellSegmentedControl removeTarget:nil action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [cellSegmentedControl addTarget:aSetting action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
    cellSegmentedControl.selectedSegmentIndex = [aSetting.settingValue intValue];
    [self.textLabel setText:aSetting.text];
}

@end
