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

@end
