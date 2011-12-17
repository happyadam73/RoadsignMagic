//
//  AWBLabel.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 17/10/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "AWBLabel.h"


@implementation AWBLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CATiledLayer *layerForView = (CATiledLayer *)self.layer;
        layerForView.levelsOfDetailBias = 0;
        layerForView.levelsOfDetail = 4;
    }
    return self;
}

+ (Class)layerClass {
    return [CATiledLayer class]; 
}

@end
