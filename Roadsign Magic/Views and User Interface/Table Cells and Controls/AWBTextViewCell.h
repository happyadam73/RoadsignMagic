//
//  AWBTextViewCell.h
//  Roadsign Magic
//
//  Created by Buckley Adam on 11/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWBTextViewCell : UITableViewCell {
    UITextView *textView;
}

@property (nonatomic, readonly) UITextView *textView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithText:(NSString *)text reuseIdentifier:(NSString *)reuseIdentifier;

@end
