//
//  AWBMyFontPreviewTableCell.h
//  Roadsign Magic
//
//  Created by Buckley Adam on 03/01/2012.
//  Copyright (c) 2012 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"

@interface AWBMyFontPreviewTableCell : UITableViewCell {
    FontLabel *fontLabel;
}

- (id)initWithFontFileUrl:(NSURL *)fontFileUrl reuseIdentifier:(NSString *)reuseIdentifier;

@end
