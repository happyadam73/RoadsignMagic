//
//  AWBLockedView.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 25/11/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBLockedView.h"

@implementation AWBLockedView

@synthesize objectsLocked, canvasAnchored, delegate;

- (id)initWithObjectsLocked:(BOOL)locked canvasAnchored:(BOOL)anchored
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 68.0, 26.0)];    
    if (self) {
        canvasAnchoredButton = [UIButton buttonWithType:UIButtonTypeCustom];
        canvasAnchoredButton.frame = CGRectMake(0.0, 0.0, 26.0, 26.0);
        [canvasAnchoredButton setImage:[UIImage imageNamed:@"unanchored"] forState:UIControlStateNormal];
        [canvasAnchoredButton setImage:[UIImage imageNamed:@"anchored"] forState:UIControlStateHighlighted];
        [canvasAnchoredButton setImage:[UIImage imageNamed:@"anchored"] forState:UIControlStateSelected];
        canvasAnchoredButton.showsTouchWhenHighlighted = YES;
        [canvasAnchoredButton addTarget:self action:@selector(toggleAnchor) forControlEvents:UIControlEventTouchUpInside];

        objectsLockedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        objectsLockedButton.frame = CGRectMake(42.0, 0.0, 26.0, 26.0);
        [objectsLockedButton setImage:[UIImage imageNamed:@"unlocked"] forState:UIControlStateNormal];
        [objectsLockedButton setImage:[UIImage imageNamed:@"locked"] forState:UIControlStateHighlighted];
        [objectsLockedButton setImage:[UIImage imageNamed:@"locked"] forState:UIControlStateSelected];
        objectsLockedButton.showsTouchWhenHighlighted = YES;
        [objectsLockedButton addTarget:self action:@selector(toggleLock) forControlEvents:UIControlEventTouchUpInside];
        
        self.canvasAnchored = anchored;
        self.objectsLocked = locked;
        [self addSubview:canvasAnchoredButton];
        [self addSubview:objectsLockedButton];
    }
    return self; 
}

- (void)dealloc
{
    [objectsLockedButton release];
    [canvasAnchoredButton release];
    [super dealloc];
}

- (BOOL)objectsLocked
{
    return objectsLockedButton.selected;
}

- (void)setObjectsLocked:(BOOL)locked
{
    objectsLockedButton.selected = locked;
    objectsLockedButton.alpha = (locked ? 1.0 : 0.5);
    
    if([delegate respondsToSelector:@selector(awbLockedView:didSetLock:)]) {
        [delegate awbLockedView:self didSetLock:locked];
	}  
}

- (BOOL)canvasAnchored
{
    return canvasAnchoredButton.selected;
}

- (void)setCanvasAnchored:(BOOL)anchored
{
    canvasAnchoredButton.selected = anchored;
    canvasAnchoredButton.alpha = (anchored ? 1.0 : 0.5);
    
    if([delegate respondsToSelector:@selector(awbLockedView:didSetAnchor:)]) {
        [delegate awbLockedView:self didSetAnchor:anchored];
	}
}

- (void)toggleLock
{
    self.objectsLocked = !self.objectsLocked;
}

- (void)toggleAnchor
{
    self.canvasAnchored = !self.canvasAnchored;
}

@end
