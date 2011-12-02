//
//  AWBRoadsignSymbolGroup.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 29/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWBRoadsignSymbolGroup : NSObject {
    NSUInteger signSymbolGroupId;
    NSArray *signSymbols;
    NSString *groupDescription;
    NSString *thumbnailImageFilename;
}

@property (nonatomic, assign) NSUInteger signSymbolGroupId;
@property (nonatomic, retain) NSArray *signSymbols;
@property (nonatomic, retain) NSString *groupDescription;
@property (nonatomic, retain) NSString *thumbnailImageFilename;

- (id)initWithIdentifier:(NSUInteger)symbolGroupId description:(NSString *)description thumbnailImageFilename:(NSString *)imageFilename signSymbols:(NSArray *)symbols;

+ (AWBRoadsignSymbolGroup *)arrowSignSymbols;
+ (AWBRoadsignSymbolGroup *)regulatorySignSymbols;
+ (AWBRoadsignSymbolGroup *)touristSignSymbols;
+ (NSArray *)allSignSymbolCategories;

@end
