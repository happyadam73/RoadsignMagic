//
//  AWBLockedView.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 25/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBLockedView.h"

@implementation AWBLockedView

@synthesize objectsLocked, canvasAnchored;

- (id)initWithObjectsLocked:(BOOL)locked canvasAnchored:(BOOL)anchored
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 50.0, 20.0)];    
    if (self) {
        canvasAnchoredView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
        canvasAnchoredView.image = [UIImage imageNamed:@"anchored"];
        objectsLockedView = [[UIImageView alloc] initWithFrame:CGRectMake(30.0, 0.0, 20.0, 20.0)];
        objectsLockedView.image = [UIImage imageNamed:@"locked"];
        [self addSubview:canvasAnchoredView];
        [self addSubview:objectsLockedView];
        canvasAnchoredView.hidden = !anchored;
        objectsLockedView.hidden = !locked;
    }
    return self; 
}

- (void)dealloc
{
    [objectsLockedView release];
    [canvasAnchoredView release];
    [super dealloc];
}

- (BOOL)objectsLocked
{
    return !objectsLockedView.hidden;
}

- (void)setObjectsLocked:(BOOL)locked
{
    objectsLockedView.hidden = !locked;
}

- (BOOL)canvasAnchored
{
    return !canvasAnchoredView.hidden;
}

- (void)setCanvasAnchored:(BOOL)anchored
{
    canvasAnchoredView.hidden = !anchored;
}

@end
