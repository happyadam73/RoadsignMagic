//
//  AWBWebViewCell.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 09/01/2012.
//  Copyright (c) 2012 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWBWebViewCell : UITableViewCell <UIWebViewDelegate> {
    UIWebView *webView;
}

@property (nonatomic, readonly) UIWebView *webView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
