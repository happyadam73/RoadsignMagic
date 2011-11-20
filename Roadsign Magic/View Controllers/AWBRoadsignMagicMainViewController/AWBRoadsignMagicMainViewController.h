//
//  AWBRoadsignMagicMainViewController.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 20/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWBRoadsignMagicMainViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView *mainScrollView;
    
    UIBarButtonItem *signBackgroundPickerButton;
    UIBarButtonItem *textButton;
    UIBarButtonItem *toolbarSpacing;
    
}

@property (nonatomic, retain) UIBarButtonItem *signBackgroundPickerButton;
@property (nonatomic, retain) UIBarButtonItem *textButton;
@property (nonatomic, retain) UIBarButtonItem *toolbarSpacing;

@end

