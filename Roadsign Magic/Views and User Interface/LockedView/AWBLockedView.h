//
//  AWBLockedView.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 25/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWBLockedView : UIView {
    UIImageView *objectsLockedView;
    UIImageView *canvasAnchoredView;
}

@property (nonatomic, assign) BOOL objectsLocked;
@property (nonatomic, assign) BOOL canvasAnchored;

- (id)initWithObjectsLocked:(BOOL)locked canvasAnchored:(BOOL)anchored;

@end
