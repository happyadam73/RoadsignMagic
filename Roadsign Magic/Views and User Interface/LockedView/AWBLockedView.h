//
//  AWBLockedView.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 25/11/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AWBLockedView;

@protocol AWBLockedViewDelegate

@optional

- (void)awbLockedView:(AWBLockedView *)lockedView didSetLock:(BOOL)locked;
- (void)awbLockedView:(AWBLockedView *)lockedView didSetAnchor:(BOOL)anchored;
@end

@interface AWBLockedView : UIView {
    id delegate;
    UIButton *objectsLockedButton;
    UIButton *canvasAnchoredButton;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL objectsLocked;
@property (nonatomic, assign) BOOL canvasAnchored;

- (id)initWithObjectsLocked:(BOOL)locked canvasAnchored:(BOOL)anchored;
- (void)toggleLock;
- (void)toggleAnchor;

@end
