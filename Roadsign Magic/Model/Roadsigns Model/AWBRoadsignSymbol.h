//
//  AWBRoadsignSymbol.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 29/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWBRoadsignSymbol : NSObject {
    NSUInteger signSymbolId;
    NSString *fullsizeImageFilename;
    NSString *thumbnailImageFilename;
}

@property (nonatomic, assign) NSUInteger signSymbolId;
@property (nonatomic, retain) NSString *fullsizeImageFilename;
@property (nonatomic, retain) NSString *thumbnailImageFilename;

- (id)initWithIdentifier:(NSUInteger)symbolId fullSizeImageFilename:(NSString *)fullSizeFilename thumbnailImageFilename:(NSString *)thumbnailFilename;
+ (id)signSymbolWithIdentifier:(NSUInteger)symbolId fullSizeImageFilename:(NSString *)fullSizeFilename thumbnailImageFilename:(NSString *)thumbnailFilename;

@end
