//
//  InAppStore.h
//  InAppStore
//

#import <Foundation/Foundation.h>
#import "IAPHelper.h"

@interface InAppStore : IAPHelper {

}

+ (InAppStore *) defaultStore;
+ (UIImage *)productImageWithIdentifier:(NSString *)productId;

@end
