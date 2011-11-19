//
//  AWBLabel.m
//  Collage Maker
//
//  Created by Adam Buckley on 17/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBLabel.h"


@implementation AWBLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CATiledLayer *layerForView = (CATiledLayer *)self.layer;
        layerForView.levelsOfDetailBias = 4;
        //layerForView.levelsOfDetail = 4;
    }
    return self;
}

+ (Class)layerClass {
    return [CATiledLayer class]; 
}

@end
