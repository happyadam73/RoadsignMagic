//
//  AWBWebViewCell.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 09/01/2012.
//  Copyright (c) 2012 Callcredit. All rights reserved.
//

#import "AWBWebViewCell.h"
#import "FileHelpers.h"

@implementation AWBWebViewCell

@synthesize webView;

- (id)initWithUrl:(NSURL *)url ReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        webView = [[UIWebView alloc] initWithFrame:CGRectZero];
//        NSString *path = AWBPathInMainBundleSubdirectory(@"Help Files", @"AboutRoadsignMagic.rtfd.zip");
//        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        webView.scalesPageToFit = YES;
        [webView loadRequest:request];
        [webView setDelegate:self];
        [[self contentView] addSubview:webView];
        [webView release];
    }
    return self;    
}

- (void)layoutSubviews  
{
    [super layoutSubviews];
    CGFloat marginX = 4.0;
    CGFloat marginY = 4.0;
    CGSize contentViewSize = self.contentView.bounds.size;
    webView.frame = CGRectMake(marginX, marginY, contentViewSize.width - (2.0 * marginX), contentViewSize.height - (2.0 * marginY));
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    if ([url isFileURL]) {
        return YES;
    } else {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
}

@end
