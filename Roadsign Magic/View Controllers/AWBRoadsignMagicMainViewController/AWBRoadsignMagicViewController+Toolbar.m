//
//  AWBRoadsignMagicViewController+Toolbar.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 24/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBRoadsignMagicViewController+Toolbar.h"
#import "AWBRoadsignMagicMainViewController+Text.h"
#import "AWBRoadsignMagicMainViewController+UI.h"
#import "UIColor+SignColors.h"

@implementation AWBRoadsignMagicMainViewController (Toolbar)

- (NSArray *)normalToolbarButtons
{
    return [NSArray arrayWithObjects:self.actionButton, self.toolbarSpacing, self.textButton, self.toolbarSpacing, self.signBackgroundPickerButton, self.toolbarSpacing, self.addSymbolButton, self.toolbarSpacing, self.settingsButton, nil];
}

- (void)resetToNormalToolbar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.toolbarItems = [self normalToolbarButtons];
}

- (void)setToolbarForEditMode  
{
    self.toolbarItems = [self editModeButtons];
}

- (NSArray *)editModeButtons
{
    return [NSArray arrayWithObjects:self.selectNoneOrAllButton, self.editTextButton, self.deleteButton, nil];    
}

- (UIBarButtonItem *)actionButton
{
    if (!actionButton) {
        actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(performAction:)];
        actionButton.style = UIBarButtonItemStylePlain;
    }
    return actionButton;
}

- (UIBarButtonItem *)toolbarSpacing
{
    if (!toolbarSpacing) {
        toolbarSpacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return toolbarSpacing;    
}

- (UIBarButtonItem *)textButton
{
    if (!textButton) {
        textButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"textbutton"] style:UIBarButtonItemStylePlain target:self action:@selector(addTextView:)];
    }
    return textButton;    
}

- (UIBarButtonItem *)signBackgroundPickerButton
{
    if (!signBackgroundPickerButton) {
        UIImage* image = [UIImage imageNamed:@"signs-up"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton* button = [[UIButton alloc] initWithFrame:frame];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        image = [UIImage imageNamed:@"signs-down"];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        [button setBackgroundImage:image forState:UIControlStateSelected];
        [button addTarget:self action:@selector(toggleThumbView:) forControlEvents:UIControlEventTouchUpInside];
        [button setShowsTouchWhenHighlighted:YES];
        signBackgroundPickerButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [button release];        
    }
    return signBackgroundPickerButton;    
}

- (UIBarButtonItem *)addSymbolButton
{
    if (!addSymbolButton) {
        UIImage* image = [UIImage imageNamed:@"symbols-up"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton* button = [[UIButton alloc] initWithFrame:frame];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        image = [UIImage imageNamed:@"symbols-down"];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        [button setBackgroundImage:image forState:UIControlStateSelected];
        [button addTarget:self action:@selector(toggleThumbView:) forControlEvents:UIControlEventTouchUpInside];
        [button setShowsTouchWhenHighlighted:YES];
        addSymbolButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [button release];        
    }
    return addSymbolButton;    
}

- (UIBarButtonItem *)settingsButton
{
    if (!settingsButton) {
        settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonAction:)];
    }
    return settingsButton;    
}

- (void)insertBarButtonItem:(UIBarButtonItem *)button atIndex:(NSUInteger)index 
{
    NSMutableArray *items = [self.toolbarItems mutableCopy];
    [items insertObject:button atIndex:index];
    self.toolbarItems = items;
    [items release];
}

- (void)removeBarButtonItem:(UIBarButtonItem *)button
{
    NSMutableArray *items = [self.toolbarItems mutableCopy];
    [items removeObject:button];
    self.toolbarItems = items;
    [items release];
}

- (UIBarButtonItem *)editButton
{
    if (!editButton) {
        editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enableEditMode:)];
        editButton.style = UIBarButtonItemStylePlain;
    }
    return editButton;    
}

- (UIBarButtonItem *)cancelButton
{
    if (!cancelButton) {
        cancelButton = [[UIBarButtonItem alloc] initWithCustomView:[self tintedSegmentedControlButtonWithTitle:@"Cancel" color:[UIColor blueSignBackgroundColor] target:self action:@selector(resetEditMode:)]];
    }
    return cancelButton;    
}

- (UIBarButtonItem *)deleteButton
{
    if (!deleteButton) {
        deleteButton = [[UIBarButtonItem alloc] initWithCustomView:[self tintedSegmentedControlButtonWithTitle:@"Delete" color:[UIColor redSignBackgroundColor] target:self action:@selector(deleteSelectedViews:)]];
    }
    return deleteButton;    
}

- (UIBarButtonItem *)editTextButton
{
    if (!editTextButton) {
        editTextButton = [[UIBarButtonItem alloc] initWithCustomView:[self tintedSegmentedControlButtonWithTitle:@"Edit Text" color:[UIColor blueSignBackgroundColor] target:self action:@selector(editSelectedTextViews:)]];
    }
    return editTextButton;       
}

- (UIBarButtonItem *)selectNoneOrAllButton
{
    if (!selectNoneOrAllButton) {
        selectNoneOrAllButton = [[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStyleBordered target:self action:@selector(selectAllOrNoneInEditMode:)];
    }
    return selectNoneOrAllButton;    
}

- (UISegmentedControl *)tintedSegmentedControlButtonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action
{
    CGFloat width = [title sizeWithFont:[UIFont systemFontOfSize:12.0]].width;
    UISegmentedControl *button = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10,7,(width+30.0),30)];
    [button setTintColor:color];
    [button addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    [button setSegmentedControlStyle:UISegmentedControlStyleBar];
    [button insertSegmentWithTitle:title atIndex:0 animated:NO];
    [button setMomentary:YES];  
    return [button autorelease];
}

- (void)updateTintedSegmentedControlButton:(UIBarButtonItem *)button withTitle:(NSString *)title
{
    CGFloat width = [title sizeWithFont:[UIFont systemFontOfSize:12.0]].width;
    UISegmentedControl *segmentedControl = (UISegmentedControl *)button.customView;
    [segmentedControl setTitle:title forSegmentAtIndex:0];
    CGRect newRect = segmentedControl.frame;
    newRect.size.width = width+30.0;
    segmentedControl.frame = newRect;
}

@end
