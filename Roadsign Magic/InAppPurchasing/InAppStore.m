//
//  InAppStore.m
//  InAppStore
//

#import "InAppStore.h"

@implementation InAppStore

static InAppStore * _sharedHelper;

+ (InAppStore *) defaultStore {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[InAppStore alloc] init];
    return _sharedHelper;
    
}

- (id)init {
    
    NSSet *productIdentifiers = [NSSet setWithObjects:
        @"com.happyadam.roadsignmagic.myfonts", 
        @"com.happyadam.roadsignmagic.gopro",
        @"com.happyadam.roadsignmagic.signpack1",
        @"com.happyadam.roadsignmagic.signpack2",                                 
        nil];
    
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {                
        
    }
    return self;
    
}

+ (UIImage *)productImageWithIdentifier:(NSString *)productId
{
    if ([productId isEqualToString:@"com.happyadam.roadsignmagic.myfonts"]) {
        return [UIImage imageNamed:@"inappmyfonts.png"];
    } else if ([productId isEqualToString:@"com.happyadam.roadsignmagic.gopro"]) {
        return [UIImage imageNamed:@"inappgopro.png"];
    } else if ([productId isEqualToString:@"com.happyadam.roadsignmagic.signpack1"]) {
        return [UIImage imageNamed:@"inappsignpack1.png"];
    } else if ([productId isEqualToString:@"com.happyadam.roadsignmagic.signpack2"]) {
        return [UIImage imageNamed:@"inappsignpack2.png"];
    } else {
        return nil;
    }
}

@end
